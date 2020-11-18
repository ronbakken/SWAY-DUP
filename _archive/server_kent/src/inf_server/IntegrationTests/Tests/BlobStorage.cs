using System;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using API.Interfaces;
using Xunit;

namespace IntegrationTests.Tests
{
    public static class BlobStorage
    {
        public static async Task<ExecutionContext> Upload(ExecutionContext context)
        {
            var logger = context.Logger;
            var client = new InfBlobStorage.InfBlobStorageClient(context.GetServerChannel());

            logger.Debug("Requesting an upload URL");
            var getUploadUrlResponse = await client.GetUploadUrlAsync(new GetUploadUrlRequest { FileName = "test.bytes" }, headers: context.GetAccessHeaders(UserType.Influencer));
            var uploadUrl = getUploadUrlResponse.UploadUrl;
            var publicUrl = getUploadUrlResponse.PublicUrl;

            using (var httpClient = new HttpClient())
            {
                var data = new byte[] { 1, 2, 3, 4 };

                var content = new ByteArrayContent(data);
                content.Headers.Add("x-ms-blob-type", "BlockBlob");

                logger.Debug("Uploading data to upload URL {UploadURL}", uploadUrl);
                var uploadResponse = await httpClient.PutAsync(uploadUrl, content);
                uploadResponse.EnsureSuccessStatusCode();
                logger.Debug("Data successfully uploaded to {UploadURL}", uploadUrl);

                logger.Debug("Requesting data back from public URL {PublicURL}", publicUrl);
                var getResponse = await httpClient.GetAsync(publicUrl);
                getResponse.EnsureSuccessStatusCode();

                var dataFromGet = await getResponse.Content.ReadAsByteArrayAsync();

                Assert.True(data.SequenceEqual(dataFromGet));
            }

            return context;
        }
    }
}
