import 'dart:async';
import 'dart:io';

class ImageUploadException implements Exception {
  final String message;

  ImageUploadException(this.message,);

  @override
  String toString() {
    return message;
  }
}


class ImageReference {
  final String imageUrl;
  final File imageFile;

  bool get isFile => imageFile != null;

  ImageReference({
    this.imageUrl,
    this.imageFile,
  }) : assert(!(imageUrl != null && imageFile != null));
}


abstract class ImageService {
  Future<File> pickImage();

  Future<String> uploadImageFromFile(String fileName, File imageFile);
  
  Future<String> uploadImageFromBytes(String fileName, List<int> value);

  Future<File> takePicture();

  // TODO not sure how we will do that with S3
  Future<void> deleteImage(String url);

}

