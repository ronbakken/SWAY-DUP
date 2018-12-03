import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';

class AddOfferStep2 extends StatefulWidget {
  const AddOfferStep2({
    Key key,
    this.offer,
  }) : super(key: key);

  final ValueNotifier<BusinessOffer> offer;

  @override
  _AddOfferStep2State createState() {
    return new _AddOfferStep2State();
  }
}

class _AddOfferStep2State extends State<AddOfferStep2> {
  @override
  Widget build(BuildContext context) {
    final rowContent = [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: AppTheme.grey, shape: BoxShape.circle),
              child: InfAssetImage(AppIcons.category),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text('Food'),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: AppTheme.grey, shape: BoxShape.circle),
              child: InfAssetImage(AppIcons.category),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text('Food'),
          ],
        ),
      ),
    ];

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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 24.0),
                              child: Text(
                                'PLEASE SELECT CATEGORIES',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: rowContent,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                              height: 1,
                              color: AppTheme.white30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                              child: Text(
                                'PLEASE SELECT CATEGORIES',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: rowContent,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                              height: 1,
                              color: AppTheme.white30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                              child: Text(
                                'PLEASE SELECT CATEGORIES',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: rowContent,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                              height: 1,
                              color: AppTheme.white30,
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

  void onNext(BuildContext context) {
    MultiPageWizard.of(context).nextPage();
  }
}
