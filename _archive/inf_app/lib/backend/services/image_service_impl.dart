import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/image_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:meta/meta.dart';

class ImageServiceImplementation implements ImageService {
  @override
  Future<File> pickImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
  }

  @override
  Future<File> takePicture() async {
    return await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
  }

  Future<String> _uploadImageFromBytes(String fileName, List<int> value) async {
    GetUploadUrlResponse cloudUrls;
    try {
      cloudUrls = await backend<InfApiClientsService>()
          .blobStorageClient
          .getUploadUrl(GetUploadUrlRequest()..fileName = fileName);
    } on GrpcError catch (e) {
      if (e.code == 7) // permission denied
      {
        // retry with new access token
        await backend<AuthenticationService>().refreshAccessToken();
        cloudUrls = await backend<InfApiClientsService>()
            .blobStorageClient
            .getUploadUrl(GetUploadUrlRequest()..fileName = fileName);
      } else {
        await backend<ErrorReporter>().logException(e, message: 'uploadImageFromBytes');
        print(e);
        rethrow;
      }
    }

    if (cloudUrls == null) {
      throw ImageUploadException('No Url from server');
    }

    Map<String, String> headers = <String, String>{};
    headers['x-ms-blob-type'] = 'BlockBlob';
    var response = await http.put(cloudUrls.uploadUrl, headers: headers, body: value);
    if (response.statusCode == 201) {
      print(cloudUrls.publicUrl);
      return cloudUrls.publicUrl;
    } else {
      throw ImageUploadException(cloudUrls.uploadUrl);
    }
  }

  @override
  Future<ImageReference> uploadImageReference({
    @required String fileNameTrunc,
    @required ImageReference imageReference,
    @required int imageWidth,
    @required int lowResWidth,
  }) async {
    // if there is already an existing image url extract file name
    String fileName;
    String fileNameLowRes;
    if (imageReference.imageUrl != null) {
      var start = imageReference.imageUrl.indexOf(fileNameTrunc);
      if (start >= 0) {
        var end = imageReference.imageUrl.indexOf('jpg') + 3;
        if (end > start) {
          fileName = imageReference.imageUrl.substring(end, start);
        } else {
          fileName = imageReference.imageUrl.substring(start, end);
        }
      }
    }

    if (imageReference.lowResUrl != null) {
      var start = imageReference.lowResUrl.indexOf(fileNameTrunc);
      if (start >= 0) {
        var end = imageReference.lowResUrl.indexOf('jpg') + 3;
        if (end > start) {
          fileNameLowRes = imageReference.lowResUrl.substring(end, start);
        } else {
          fileNameLowRes = imageReference.lowResUrl.substring(start, end);
        }
      }
    }

    if (fileName == null) // no previous or valid file name in url
    {
      fileName = '$fileNameTrunc-${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
      fileNameLowRes = '${fileNameTrunc}_lowres-${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
    }

    var imageBytes = await imageReference.imageFile.readAsBytes();

    var image = decodeImage(imageBytes);
    var imageReducedSize = copyResize(image, width: imageWidth);
    var imageUrl = await _uploadImageFromBytes(
      fileName,
      encodeJpg(imageReducedSize, quality: 90),
    );

    String lowResUrl;
    if (lowResWidth != null) {
      var imageLowRes = copyResize(image, width: lowResWidth);
      lowResUrl = await _uploadImageFromBytes(
        fileNameLowRes,
        encodeJpg(imageLowRes, quality: 60),
      );
    }

    return imageReference.copyWith(imageUrl: imageUrl, imageLowResUrl: lowResUrl);
  }

  @override
  Future<void> deleteImage(String url) async {
    // TODO
    throw UnimplementedError('Not Implemented yet');
  }
}
