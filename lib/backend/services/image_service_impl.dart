import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/image_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:http/http.dart' as http;


class ImageServiceImplementation implements ImageService {
  @override
  Future<File> pickImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 800, maxWidth: 800);
  }

  @override
  Future<String> uploadImageFromFile(String fileName, File imageFile) async {
    return await uploadImageFromBytes(fileName, await imageFile.readAsBytes());
  }

  @override
  Future<String> uploadImageFromBytes(String fileName, List<int> value) async {
    var cloudUrls = await backend
        .get<InfApiClientsService>()
        .blobStorageClient
        .getUploadUrl(GetUploadUrlRequest()..fileName = fileName);

    if (cloudUrls == null)
    {
      throw ImageUploadException("No Url from server");
    }

    Map<String,String> headers = <String,String>{};
    headers['x-ms-blob-type'] = 'BlockBlob';
    var response = await http.put(cloudUrls.uploadUrl, headers: headers, body: value);
    if (response.statusCode == 201) {
      print(cloudUrls.publicUrl);
      return cloudUrls.publicUrl;
    }
    else
    {
      throw ImageUploadException(cloudUrls.uploadUrl);
    }
  }

  @override
  Future<File> takePicture() async {
    return await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 800, maxWidth: 800);
  }

  @override
  Future<void> deleteImage(String url) async {
    // TODO
    throw new Exception("Not Implemented yet");
  }
}
