
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/asset_imageI_circle_background.dart';
import 'package:inf/ui/widgets/image_source_selector_dialog.dart';

class ImageSelector extends StatefulWidget {
  final List<ImageReference> images;
  final double imageAspecRatio;

  const ImageSelector({
    Key key,
    @required this.images,
    @required this.imageAspecRatio,
  }) : super(key: key);
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  int selectedImageIndex = 0;
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
    var imageReferences = widget.images;
    if (imageReferences.isEmpty) {
      return SizedBox();
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
              child: Center(
                  child: Icon(
                Icons.add,
                color: AppTheme.white30,
              )),
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
    if (widget.images.isEmpty) {
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
              SizedBox(
                width: 48.0,
              ),
              AssetImageCircleBackgroundButton(
                asset: AppIcons.camera,
                radius: 40.0,
                backgroundColor: AppTheme.darkGrey,
                onTap: () => _onAddPicture(camera: true),
              ),
            ],
          ));
    } else {
      assert(selectedImageIndex < widget.images.length);
      return Stack(
        fit: StackFit.passthrough,
        children: [
          widget.images[selectedImageIndex].isFile
              ? Image.file(
                  widget.images[selectedImageIndex].imageFile,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  widget.images[selectedImageIndex].imageUrl,
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.red),
                child: Icon(Icons.close),
              ),
            ),
          ),
        ],
      );
    }
  }

  void onRemoveImage() {
    setState(() {
      widget.images.removeAt(selectedImageIndex);
      selectedImageIndex = selectedImageIndex > 0 ? selectedImageIndex - 1 : 0;
    });
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
    var imageFile =
        camera ? await backend.get<ImageService>().takePicture() : await backend.get<ImageService>().pickImage();
    if (imageFile != null) {
      widget.images.add(ImageReference(imageFile: imageFile));
      setState(() {
        selectedImageIndex = widget.images.length - 1;
      });
    }
  }
}