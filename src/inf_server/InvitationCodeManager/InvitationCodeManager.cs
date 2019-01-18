using System;
using System.Collections.Generic;
using System.Fabric;
using System.Text;
using System.Threading.Tasks;
using InvitationCode.Interfaces;
using InvitationCodeManager.Interfaces;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
using Microsoft.ServiceFabric.Data.Collections;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Actor = InvitationCode.Interfaces;
using Manager = InvitationCodeManager.Interfaces;

namespace InvitationCodeManager
{
    internal sealed class InvitationCodeManager : StatefulService, IInvitationCodeManagerService
    {
        private const string invitationCodesStateKey = "invitationCodes";

        public InvitationCodeManager(StatefulServiceContext context)
            : base(context)
        {
        }

        public async Task<string> Generate()
        {
            var invitationCodes = await this.GetInvitationCodes();
            string invitationCode;

            using (var transaction = this.StateManager.CreateTransaction())
            {
                while (true)
                {
                    invitationCode = GenerateRandomString(8);
                    Log("Generated invitation code '{0}'.", invitationCode);

                    if (await invitationCodes.ContainsKeyAsync(transaction, invitationCode))
                    {
                        Log("Invitation code '{0}' has already been allocated - trying again.");
                    }
                    else
                    {
                        await invitationCodes.AddAsync(transaction, invitationCode, true);
                        await transaction.CommitAsync();
                        Log("Invitation code '{0}' has been allocated.", invitationCode);
                        break;
                    }
                }
            }

            // Force the creation of the actor (which is important because the expiry is assigned therein).
            var actor = GetInvitationCodeActor(invitationCode);

            return invitationCode;
        }

        public async Task<InvitationCodeStatus> GetStatus(string invitationCode)
        {
            Log("Determining status of invitation code '{0}'.", invitationCode);
            var invitationCodes = await this.GetInvitationCodes();

            using (var transaction = this.StateManager.CreateTransaction())
            {
                if (!await invitationCodes.ContainsKeyAsync(transaction, invitationCode))
                {
                    Log("Invitation code does not exist.");
                    return InvitationCodeStatus.DoesNotExist;
                }

                var actor = GetInvitationCodeActor(invitationCode);

                if (await actor.IsExpired())
                {
                    Log("Invitation code is expired.");
                    return InvitationCodeStatus.Expired;
                }
                else if (await actor.IsUsed())
                {
                    Log("Invitation code is used.");
                    return InvitationCodeStatus.Used;
                }
                else
                {
                    Log("Invitation code is pending use.");
                    return InvitationCodeStatus.PendingUse;
                }
            }
        }

        public async Task<Manager.InvitationCodeUseResult> Use(string invitationCode)
        {
            Log("Attempting to use invitation code '{0}'.", invitationCode);
            var invitationCodes = await this.GetInvitationCodes();

            using (var transaction = this.StateManager.CreateTransaction())
            {
                if (!await invitationCodes.ContainsKeyAsync(transaction, invitationCode))
                {
                    Log("Invitation code does not exist.");
                    return Manager.InvitationCodeUseResult.DoesNotExist;
                }
            }

            var actor = GetInvitationCodeActor(invitationCode);
            var result = await actor.Use();

            switch (result)
            {
                case Actor.InvitationCodeUseResult.AlreadyUsed:
                    return Manager.InvitationCodeUseResult.AlreadyUsed;
                case Actor.InvitationCodeUseResult.Expired:
                    return Manager.InvitationCodeUseResult.Expired;
                case Actor.InvitationCodeUseResult.Success:
                    return Manager.InvitationCodeUseResult.Success;
                default:
                    throw new NotSupportedException();
            }
        }

        protected override IEnumerable<ServiceReplicaListener> CreateServiceReplicaListeners() =>
            this.CreateServiceRemotingReplicaListeners();

        private Task<IReliableDictionary<string, bool>> GetInvitationCodes() =>
            this.StateManager.GetOrAddAsync<IReliableDictionary<string, bool>>(invitationCodesStateKey);

        private static string GenerateRandomString(int length)
        {
            var sb = new StringBuilder();
            var random = new Random();
            // Intentionally left out characters that often render ambiguously, even though that is down to the font.
            var chars = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";

            for (var i = 0; i < length; ++i)
            {
                var ch = chars[random.Next(chars.Length)];
                sb.Append(ch);
            }

            return sb.ToString();
        }

        private static IInvitationCode GetInvitationCodeActor(string code) =>
            ActorProxy.Create<IInvitationCode>(new ActorId(code), new Uri("fabric:/server/InvitationCodeActorService"));

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
