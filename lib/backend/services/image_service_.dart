import 'dart:async';
import 'dart:io';

import 'package:inf_api_client/inf_api_client.dart';

class ImageUploadException implements Exception {
  final String message;

  ImageUploadException(
    this.message,
  );

  @override
  String toString() {
    return message;
  }
}

class ImageReference {
  final String imageUrl;
  final String lowresUrl;
  final File imageFile;

  bool get isFile => imageFile != null;

  ImageReference({this.imageUrl, this.imageFile, this.lowresUrl}) : assert(!(imageUrl != null && imageFile != null));

  ImageReference copyWith({
    String imageUrl,
    String imageLowResUrl,
    File imageFile,
  }) {
    return ImageReference(
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      lowresUrl: imageLowResUrl ?? this.lowresUrl,
    );
  }

  ImageDto toDto() {
    assert(imageUrl != null);
    return ImageDto()
      ..lowResUrl = lowresUrl ?? ''
      ..url = imageUrl;
  }

  static ImageReference fromImageDto(ImageDto dto)
  {
    return ImageReference(imageUrl: dto.url,lowresUrl: dto.lowResUrl);
  }

}

abstract class ImageService {
  Future<File> pickImage();

  Future<String> uploadImageFromFile(String fileName, File imageFile);

  Future<String> uploadImageFromBytes(String fileName, List<int> value);

  /// resizes and updloads images. if [lowResWidth != null] it also uploads a lowres version
  /// if [imageUrl] of [imageReference != null] it uploads with the same fileName  
  Future<ImageReference> uploadImageReference({
    String fileNameTrunc,
    ImageReference imageReference,
    int imageWidth,
    int lowResWidth,
  });

  Future<File> takePicture();

  // TODO not sure how we will do that with S3
  Future<void> deleteImage(String url);
}
