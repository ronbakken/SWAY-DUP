import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/image_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:http/http.dart' as http;

class ImageServiceImplementation implements ImageService {
  @override
  Future<File> pickImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
  }

  @override
  Future<String> uploadImageFromFile(String fileName, File imageFile) async {
    return await uploadImageFromBytes(fileName, await imageFile.readAsBytes());
  }

  @override
  Future<String> uploadImageFromBytes(String fileName, List<int> value) async {
    GetUploadUrlResponse cloudUrls;
    try {
      cloudUrls = await backend<InfApiClientsService>().blobStorageClient.getUploadUrl(
            GetUploadUrlRequest()..fileName = fileName,
            options: backend<AuthenticationService>().callOptions,
          );
    } on GrpcError catch (e) {
      if (e.code == 7) // permission denied
      {
        // retry with new access token
        await backend<AuthenticationService>().refreshAccessToken();
        cloudUrls = await backend<InfApiClientsService>().blobStorageClient.getUploadUrl(
              GetUploadUrlRequest()..fileName = fileName,
              options: backend<AuthenticationService>().callOptions,
            );
      }
      else
      {
        await backend<ErrorReporter>().logException(e, message: 'uploadImageFromBytes');
        print(e);
        rethrow;

      }
    }

    if (cloudUrls == null) {
      throw ImageUploadException("No Url from server");
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
  Future<ImageReference> uploadImageReference(
      {String fileNameTrunc,
      ImageReference imageReference,
      int imageWidth,
      int lowResWidth,
      VoidCallback onImageUploaded}) async {
    // if there is already an existing image url extract file name
    String fileName;
    String fileNameLowRes;
    if (imageReference.imageUrl != null) {
      var start = imageReference.imageUrl.indexOf(fileNameTrunc);
      if (start >= 0) {
        var end = imageReference.imageUrl.indexOf('jpg') + 3;
        if (end > start) {}
        fileName = imageReference.imageUrl.substring(start, end);
      }
    }

    if (imageReference.lowresUrl != null) {
      var start = imageReference.lowresUrl.indexOf(fileNameTrunc);
      if (start >= 0) {
        var end = imageReference.lowresUrl.indexOf('jpg') + 3;
        if (end > start) {}
        fileNameLowRes = imageReference.lowresUrl.substring(start, end);
      }
    }

    if (fileName == null) // no previous or valid file name in url
    {
      fileName = '$fileNameTrunc-${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
      fileNameLowRes = '${fileNameTrunc}_lowres-${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
    }

    var imageBytes = await imageReference.imageFile.readAsBytes();

    var image = decodeImage(imageBytes);
    var imageReducedSize = copyResize(image, imageWidth);
    var imageUrl = await backend<ImageService>().uploadImageFromBytes(
          fileName,
          encodeJpg(imageReducedSize, quality: 90),
        );

    if (onImageUploaded != null) {
      onImageUploaded();
    }

    String lowResUrl;
    if (lowResWidth != null) {
      var imageLowRes = copyResize(image, lowResWidth);
      lowResUrl = await backend<ImageService>().uploadImageFromBytes(
            fileNameLowRes,
            encodeJpg(imageLowRes, quality: 60),
          );
    }
    if (onImageUploaded != null) {
      onImageUploaded();
    }
    return imageReference.copyWith(imageUrl: imageUrl, imageLowResUrl: lowResUrl);
  }

  @override
  Future<File> takePicture() async {
    return await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
  }

  @override
  Future<void> deleteImage(String url) async {
    // TODO
    throw new Exception("Not Implemented yet");
  }
}
