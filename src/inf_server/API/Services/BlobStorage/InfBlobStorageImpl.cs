using System;
using System.Fabric;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Serilog;
using static API.Interfaces.InfBlobStorage;

namespace API.Services.BlobStorage
{
    public sealed class InfBlobStorageImpl : InfBlobStorageBase
    {
        private readonly ILogger logger;

        public InfBlobStorageImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfBlobStorageImpl>();
        }

        public override Task<GetUploadUrlResponse> GetUploadUrl(GetUploadUrlRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                logger,
                async (logger) =>
                {
                    var configurationPackage = FabricRuntime.GetActivationContext().GetConfigurationPackageObject("Config");
                    var storageConnectionString = configurationPackage.Settings.Sections["Storage"].Parameters["ConnectionString"].Value;
                    logger.Debug("Storaged connection string is {StorageConnectionString}", storageConnectionString);
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
                    logger.Debug("Computed hash of user ID {UserId} is {Hash}, which will be used as the container name", userId, userIdHash);

                    var containerName = userIdHash;
                    var container = blobClient.GetContainerReference(containerName);

                    logger.Debug("Ensuring container with name {ContainerName} exists", containerName);
                    await container.CreateIfNotExistsAsync(BlobContainerPublicAccessType.Blob, new BlobRequestOptions { }, new OperationContext { }, context.CancellationToken);

                    var fileName = request.FileName;
                    var blob = container.GetBlockBlobReference(fileName);

                    logger.Debug("Creating shared access token for container {ContainerName}, file {FileName}", containerName, fileName);
                    var sas = new SharedAccessBlobPolicy
                    {
                        SharedAccessExpiryTime = DateTime.UtcNow.AddHours(1),
                        Permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.Write | SharedAccessBlobPermissions.Create,
                    };
                    var sasToken = blob.GetSharedAccessSignature(sas);

                    var uploadUrl = blob.Uri.ToString() + sasToken;
                    var publicUrl = blob.Uri.ToString();
                    var result = new GetUploadUrlResponse
                    {
                        UploadUrl = uploadUrl,
                        PublicUrl = publicUrl,
                    };

                    logger.Debug("Generated upload URL {UploadUrl}, public URL {PublicURL}", uploadUrl, publicUrl);

                    return result;
                });
    }
}
