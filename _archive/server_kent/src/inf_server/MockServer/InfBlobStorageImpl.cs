using System;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using static API.Interfaces.InfApi;

namespace MockServer
{
    class InfBlobStorageImpl : InfBlobStorage.InfBlobStorageBase
    {
        public override Task<GetUploadUrlResponse> GetUploadUrl(GetUploadUrlRequest request, ServerCallContext context)
        {
            Console.WriteLine("InfBlobStorageImpl.GetUploadUrl called");
            if (request.FileName.Contains("lowres") || request.FileName.Contains("Thumb"))
            {
                return Task.FromResult(new GetUploadUrlResponse
                {
                    PublicUrl = "https://linkstest.blob.core.windows.net/images/profile-lowres.jpg",
                    UploadUrl = "https://linkstest.blob.core.windows.net/images/profile-lowres.jpg?sp=rwd&st=2019-01-24T10:10:51Z&se=2019-05-02T17:10:51Z&spr=https&sv=2018-03-28&sig=4ber0HsRBxTiSdaaqu8ozhxfzGLnA32bYrtcOnD56u8%3D&sr=b"

                });
            }
            return Task.FromResult(new GetUploadUrlResponse
            {
                PublicUrl = "https://linkstest.blob.core.windows.net/images/profile.jpg",
                UploadUrl = "https://linkstest.blob.core.windows.net/images/profile.jpg?sp=rw&st=2019-01-23T15:47:10Z&se=2019-08-02T22:47:10Z&spr=https&sv=2018-03-28&sig=QuTHzHYaHRVSKd5UhVC2UXeRK9sJZ9XkHfk0IpDCzJU%3D&sr=b"
            });
        }
    }
}
