﻿using System;
using System.Fabric;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using static API.Interfaces.InfBlobStorage;

namespace API.Services.BlobStorage
{
    public sealed class InfBlobStorageImpl : InfBlobStorageBase
    {
        public override Task<GetUploadUrlResponse> GetUploadUrl(GetUploadUrlRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("GetUploadUrl.");

                    var configurationPackage = FabricRuntime.GetActivationContext().GetConfigurationPackageObject("Config");
                    var storageConnectionString = configurationPackage.Settings.Sections["Storage"].Parameters["ConnectionString"].Value;
                    var storageAccount = CloudStorageAccount.Parse(storageConnectionString);
                    var blobClient = storageAccount.CreateCloudBlobClient();

                    var encoding = Encoding.UTF8;
                    var userId = context.GetAuthenticatedUserId();
                    var userIdHashBytes = MD5.Create().ComputeHash(Encoding.UTF8.GetBytes(userId));
                    var userIdHash = userIdHashBytes
                        .Select(b => b.ToString("X2").ToLowerInvariant())
                        .Aggregate(
                            new StringBuilder(),
                            (sb, next) => sb.Append(next),
                            sb => sb.ToString());
                    ServiceEventSource.Current.Message("Computed hash of user ID '{0}' is '{1}', which will be used as the container name.", userId, userIdHash);

                    var containerName = userIdHash;
                    var container = blobClient.GetContainerReference(containerName);

                    ServiceEventSource.Current.Message("Ensuring storage container exists.");
                    await container.CreateIfNotExistsAsync(BlobContainerPublicAccessType.Blob, new BlobRequestOptions { }, new OperationContext { }, context.CancellationToken);

                    var blob = container.GetBlockBlobReference(request.FileName);

                    ServiceEventSource.Current.Message("Creating shared access token.");
                    var sas = new SharedAccessBlobPolicy
                    {
                        SharedAccessExpiryTime = DateTime.UtcNow.AddHours(1),
                        Permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.Write | SharedAccessBlobPermissions.Create,
                    };
                    var sasToken = blob.GetSharedAccessSignature(sas);

                    var result = new GetUploadUrlResponse
                    {
                        UploadUrl = blob.Uri.ToString() + sasToken,
                        PublicUrl = blob.Uri.ToString(),
                    };

                    return result;
                });
    }
}
