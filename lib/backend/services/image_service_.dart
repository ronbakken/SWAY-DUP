import 'dart:async';
import 'dart:io';


abstract class ImageService {
  Future<File> pickImage();

  Future<String> uploadImage(File imageFile);

  Future<File> takePicture();

  // TODO not sure how we will do that with S3
  Future<void> deleteImage(String url);

}

