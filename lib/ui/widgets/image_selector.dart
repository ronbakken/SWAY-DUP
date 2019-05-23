import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/asset_image_circle_background.dart';
import 'package:inf/ui/widgets/image_source_selector_dialog.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ImageSelector extends StatefulWidget {
  final List<ImageReference> imageReferences;
  final double imageAspecRatio;
  final ValueChanged<List<ImageReference>> onImageChanged;

  const ImageSelector({Key key, @required this.imageReferences, @required this.imageAspecRatio, this.onImageChanged})
      : super(key: key);

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  int selectedImageIndex = 0;
  List<ImageReference> imageReferences;

  @override
  void initState() {
    super.initState();
    imageReferences = widget.imageReferences.map((x) => x.copyWith()).toList();
  }

  @override
  void didUpdateWidget(ImageSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    imageReferences = widget.imageReferences.map((x) => x.copyWith()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: widget.imageAspecRatio,
          child: buildMainImage(),
        ),
        buildSelectedImageRow()
      ],
    );
  }

  Widget buildSelectedImageRow() {
    if (imageReferences.isEmpty) {
      return emptyWidget;
    }
    var images = <Widget>[];
    for (var i = 0; i < imageReferences.length; i++) {
      images.add(
        InkWell(
          onTap: () => setState(() => selectedImageIndex = i),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: imageReferences[i].isFile
                  ? Image.file(
                      imageReferences[i].imageFile,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageReferences[i].imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      );
    }
    images.add(
      InkWell(
        onTap: () => _onAddPicture(),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Container(
              color: AppTheme.grey,
              child: const Center(
                child: Icon(Icons.add, color: AppTheme.white30),
              ),
            ),
          ),
        ),
      ),
    );
    return Container(
      height: 72.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: images,
      ),
    );
  }

  Widget buildMainImage() {
    if (imageReferences.isEmpty) {
      return Container(
          color: AppTheme.grey,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AssetImageCircleBackgroundButton(
                asset: AppIcons.photo,
                radius: 40.0,
                backgroundColor: AppTheme.darkGrey,
                onTap: () => _onAddPicture(camera: false),
              ),
              horizontalMargin36,
              AssetImageCircleBackgroundButton(
                asset: AppIcons.camera,
                radius: 40.0,
                backgroundColor: AppTheme.darkGrey,
                onTap: () => _onAddPicture(camera: true),
              ),
            ],
          ));
    } else {
      assert(selectedImageIndex < imageReferences.length);
      return Stack(
        fit: StackFit.passthrough,
        children: [
          if (imageReferences[selectedImageIndex].isFile)
            Image.file(
              imageReferences[selectedImageIndex].imageFile,
              fit: BoxFit.cover,
            )
          else
            Image.network(
              imageReferences[selectedImageIndex].imageUrl,
              fit: BoxFit.cover,
            ),
          Positioned(
            right: 8.0,
            top: 10.0,
            child: InkResponse(
              onTap: onRemoveImage,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.red),
                child: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      );
    }
  }

  void onRemoveImage() {
    setState(() {
      imageReferences.removeAt(selectedImageIndex);
      selectedImageIndex = selectedImageIndex > 0 ? selectedImageIndex - 1 : 0;
    });
    widget.onImageChanged(imageReferences);
  }

  /// if [camera] is null a dialog is dispplayed to select which source should be used
  void _onAddPicture({bool camera}) async {
    if (camera == null) {
      camera = await showDialog<bool>(context: context, builder: (context) => ImageSourceSelectorDialog());
      // user aborted the dialog
      if (camera == null) {
        return;
      }
    }
    var imageFile = camera ? await backend<ImageService>().takePicture() : await backend<ImageService>().pickImage();
    if (imageFile != null) {
      imageReferences.add(ImageReference(imageFile: imageFile));
      setState(() {
        selectedImageIndex = imageReferences.length - 1;
      });
      widget.onImageChanged(imageReferences);
    }
  }
}
