import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:inf/backend/services/image_service_.dart';

class ImageServiceMock implements ImageService {

  @override
  Future<File> pickImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    return null;
  }

  @override
  Future<File> takePicture() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  @override
  Future<void> deleteImage(String url) async {
  }

}
