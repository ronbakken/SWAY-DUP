import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/asset_imageI_circle_background.dart';
import 'package:inf/ui/widgets/image_source_selector_dialog.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';

class AddOfferStep1 extends StatefulWidget {
  const AddOfferStep1({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep1State createState() {
    return new _AddOfferStep1State();
  }
}

class _AddOfferStep1State extends State<AddOfferStep1> {
  int selectedImageIndex = 0;

  GlobalKey form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomAnimatedCurves(),
        ),
        InfPageScrollView(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: buildMainImage(),
              ),
              buildSelectedImageRow(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: Form(
                    key: form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InfTextFormField(
                          decoration: const InputDecoration(labelText: 'TITLE'),
                          onSaved: (s) => widget.offerBuilder.title = s,
                          validator: (s) => s.isEmpty ? 'You have so provide a title' : null,
                        ),
                        SizedBox(height: 32.0),
                        InfTextFormField(
                          decoration: const InputDecoration(
                            labelText: 'DESCRIPTION',
                          ),
                          onSaved: (s) => widget.offerBuilder.description = s,
                          validator: (s) => s.isEmpty ? 'You have so provide a description' : null,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                child: InfStadiumButton(
                  height: 56,
                  color: Colors.white,
                  text: 'NEXT',
                  onPressed: () => onNext(context),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSelectedImageRow() {
    var imageFiles = widget.offerBuilder.imagesToUpLoad;
    if (imageFiles.isEmpty) {
      return SizedBox();
    }
    var images = <Widget>[];
    for (var i = 0; i < imageFiles.length; i++) {
      images.add(
        InkWell(
          onTap: () => setState(() => selectedImageIndex = i),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Image.file(
                imageFiles[i],
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
    if (widget.offerBuilder.imagesToUpLoad.isEmpty) {
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
      assert(selectedImageIndex < widget.offerBuilder.imagesToUpLoad.length);
      return Stack(
        fit: StackFit.passthrough,
        children: [
          Image.file(
            widget.offerBuilder.imagesToUpLoad[selectedImageIndex],
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
      widget.offerBuilder.imagesToUpLoad.removeAt(selectedImageIndex);
      selectedImageIndex = selectedImageIndex > 0 ? selectedImageIndex - 1 : 0;
    });
  }

  void onNext(BuildContext context) {
    FormState state = form.currentState;
    if (true /*state.validate()*/) {
      state.save();
      MultiPageWizard.of(context).nextPage();
    }
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
      widget.offerBuilder.imagesToUpLoad.add(imageFile);
      setState(() {
        selectedImageIndex = widget.offerBuilder.imagesToUpLoad.length - 1;
      });
    }
  }
}
