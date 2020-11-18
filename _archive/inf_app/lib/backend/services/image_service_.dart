import 'dart:async';
import 'dart:io';

import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:meta/meta.dart';

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

class ImageReference implements InfImageProvider {
  const ImageReference({
    this.lowResUrl,
    this.imageUrl,
    this.imageFile,
  });

  factory ImageReference.fromImageDto(ImageDto dto) {
    return ImageReference(
      lowResUrl: dto.lowResUrl,
      imageUrl: dto.url,
    );
  }

  factory ImageReference.fromJson(Map<String, dynamic> data) {
    return ImageReference(
      lowResUrl: data['lowResUrl'],
      imageUrl: data['imageUrl'],
      // imageFile: data['imageFile'], // FIXME: see [toJson()]
    );
  }

  @override
  final String lowResUrl;

  @override
  final String imageUrl;

  final File imageFile;

  bool get isFile => imageFile != null;

  ImageReference copyWith({
    String imageLowResUrl,
    String imageUrl,
    File imageFile,
  }) {
    return ImageReference(
      lowResUrl: imageLowResUrl ?? this.lowResUrl,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  ImageDto toImageDto() {
    assert(imageUrl != null);
    return ImageDto()
      ..lowResUrl = lowResUrl ?? ''
      ..url = imageUrl;
  }

  Map<String, dynamic> toJson() {
    return {
      'lowResUrl': lowResUrl,
      'imageUrl': imageUrl,
      // 'imageFile': imageFile, // FIXME: Do we need to convert the imageFile into JSON? And if so; how?
    };
  }
}

abstract class ImageService {
  Future<File> pickImage();

  Future<File> takePicture();

  /// Resizes and uploads images.
  ///
  /// If [lowResWidth != null], it also uploads a lower resolution version.
  /// If [imageUrl] of [imageReference != null] it uploads with the same fileName
  Future<ImageReference> uploadImageReference({
    @required String fileNameTrunc,
    @required ImageReference imageReference,
    @required int imageWidth,
    @required int lowResWidth,
  });

  // TODO not sure how we will do that with S3
  Future<void> deleteImage(String url);
}
