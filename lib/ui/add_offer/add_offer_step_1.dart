import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
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
          AnimatedBuilder(
            animation: widget.offer,
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
                              height: constraints.maxHeight * 0.12,
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Placeholder(
                                      fallbackWidth: 100.0,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Placeholder(
                                      fallbackWidth: 100.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
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
                                    TextField(
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(
                                          borderSide: const BorderSide(color: AppTheme.white30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 32.0),
                                    Text(
                                      'DESCRIPTION',
                                      textAlign: TextAlign.left,
                                      style: AppTheme.textStyleformfieldLabel,
                                    ),
                                    TextField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ],
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

  Widget buildMainImage() {
    if (selectedImages.isEmpty) {
      return Container(
          color: AppTheme.grey,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(width: 50.0, height: 50.0, child: InfAssetImage(AppIcons.photo)),
              // SizedBox(width: 50.0, height: 50.0, child: InfAssetImage(AppIcons.camera, color: Colors.white,)),
              SizedBox(width: 50.0, height: 50.0, child: Placeholder()),
              SizedBox(width: 50.0, height: 50.0, child: Placeholder()),
            ],
          )
          );          
    }
    else
    {
      assert(selectedImageIndex < selectedImages.length);
      return Image.file(selectedImages[selectedImageIndex]);
    }
  }

  void onNext(BuildContext context) {
    MultiPageWizard.of(context).nextPage();
  }
}
