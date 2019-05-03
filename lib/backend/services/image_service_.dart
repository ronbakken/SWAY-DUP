import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inf/ui/widgets/inf_image.dart';
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
}

abstract class ImageService {
  Future<File> pickImage();

  Future<String> uploadImageFromFile(String fileName, File imageFile);

  Future<String> uploadImageFromBytes(String fileName, List<int> value);

  /// resize's and upload's images. if [lowResWidth != null] it also uploads a lowres version
  /// if [imageUrl] of [imageReference != null] it uploads with the same fileName
  Future<ImageReference> uploadImageReference(
      {String fileNameTrunc,
      ImageReference imageReference,
      int imageWidth,
      int lowResWidth,
      VoidCallback onImageUploaded});

  Future<File> takePicture();

  // TODO not sure how we will do that with S3
  Future<void> deleteImage(String url);
}
