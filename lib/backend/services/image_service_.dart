import 'dart:async';
import 'dart:io';


import 'package:image_picker/image_picker.dart';


abstract class ImageService {
  Future<File> pickImage();

  Future<String> uploadImage(File imageFile);

  Future<File> takePicture();

  // TODO not sure how we will do that with S3
  Future<void> deleteImage(String url);

}

