import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/ui/widgets/asset_imageI_circle_background.dart';
import 'package:inf/ui/widgets/image_source_selector_dialog.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';

class AddOfferStep1 extends StatefulWidget {
  const AddOfferStep1({
    Key key,
    this.offer,
  }) : super(key: key);

  final ValueNotifier<BusinessOffer> offer;

  @override
  _AddOfferStep1State createState() {
    return new _AddOfferStep1State();
  }
}

class _AddOfferStep1State extends State<AddOfferStep1> {
  final selectedImages = <File>[];
  int selectedImageIndex = 0;

  String title;
  String description;

  GlobalKey form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.bottomCenter,
        children: [
          InfAssetImage(
            AppImages.mockCurves, // FIXME:
            alignment: Alignment.bottomCenter,
          ),
          ListenableBuilder(
            listenable: widget.offer,
            builder: (BuildContext context, Widget child) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: constraints.copyWith(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight,
                        maxHeight: double.infinity,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight * 0.38,
                              child: buildMainImage(),
                            ),
                            SizedBox(
                              height: selectedImages.isNotEmpty ? constraints.maxHeight * 0.12 : 0,
                              child: buildSelectedImageRow(),
                            ),
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
                                      Text(
                                        'TITLE',
                                        textAlign: TextAlign.left,
                                        style: AppTheme.textStyleformfieldLabel,
                                      ),
                                      SizedBox(height: 8.0),
                                      TextFormField(
                                        onSaved: (s) => title = s,
                                        validator: (s) => s.isEmpty ? 'You have so provide a title' : null,
                                      ),
                                      SizedBox(height: 32.0),
                                      Text(
                                        'DESCRIPTION',
                                        textAlign: TextAlign.left,
                                        style: AppTheme.textStyleformfieldLabel,
                                      ),
                                      TextFormField(
                                        onSaved: (s) => description = s,
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
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSelectedImageRow() {
    if (selectedImages.isEmpty) {
      return SizedBox();
    }
    var images = <Widget>[];
    for (var i = 0; i < selectedImages.length; i++) {
      images.add(
        InkWell(
          onTap: () => setState(() => selectedImageIndex = i),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Image.file(
              selectedImages[i],
              fit: BoxFit.cover,
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
            child: Container(
              color: AppTheme.grey,
              child: Center(
                  child: Icon(
                Icons.add,
                color: AppTheme.white30,
              )),
            )),
      ),
    );
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: images,
        ),
      ),
    );
  }

  Widget buildMainImage() {
    if (selectedImages.isEmpty) {
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
      assert(selectedImageIndex < selectedImages.length);
      return Image.file(
        selectedImages[selectedImageIndex],
        fit: BoxFit.cover,
      );
    }
  }

  void onNext(BuildContext context) {
    FormState state = form.currentState;
    if (state.validate())
    {
      state.save();
      widget.offer.value = widget.offer.value.copyWith(title: title, description: description); 
      MultiPageWizard.of(context).nextPage();
    }
  }

  /// if [camera] is null a dialog is dispplayed to select which source should be used
  void _onAddPicture({bool camera}) async {
    if (camera == null) {
      camera = await showDialog<bool>(context: context, builder: (context) => ImageSourceSelectorDialog());
      if (camera == null) {
        return;
      }
    }
    var imageFile =
        camera ? await backend.get<ImageService>().takePicture() : await backend.get<ImageService>().pickImage();
    if (imageFile != null) {
      selectedImages.add(imageFile);
      setState(() {
        selectedImageIndex = selectedImages.length - 1;
      });
    }
  }
}
