import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/social_network_toggle_button.dart';

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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, top: 32.0, bottom: 24.0),
                              child: Text(
                                'PLEASE SELECT CATEGORIES',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: buildCategoryRow(),
                            ),
                            _spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, bottom: 16.0),
                              child: Text(
                                'SOCIAL PLATFORM',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, right: 24.0),
                              child: buildSocialPlatformRow(),
                            ),
                            _spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, bottom: 24.0),
                              child: Text(
                                'CONTENT TYPE',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, right: 24),
                              child: buildDeliverableTypeRow(),
                            ),
                            _spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, bottom: 24.0),
                              child: Text(
                                'DELIVERABLE DESCRIPTION',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, right: 24),
                              child: TextField(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 32.0),
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

  Container _spacer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(32.0, 16.0, 32, 24.0),
      height: 1,
      color: AppTheme.white30,
    );
  }

  Widget buildCategoryRow() {
        final topLevelCategories =
            backend.get<ResourceService>().categories.where((item) => item.parentId == null);
        final rowItems = <Widget>[];
        for (var category in topLevelCategories) {
          rowItems.add(
            CategoryButton(
              radius: 35.0,
              child: InfMemoryImage(
                category.iconData,
                color: Colors.white,
              ),
              selectedSubCategories: 2,
              label: category.name,
            ),
          );
        }
        return new OverFlowRow(
          height: 100.0,
          items: rowItems,
          numberOfItemsToDisplay: 4,
          spacing: 4.0,
        );
  }

  Widget buildDeliverableTypeRow() {
        final rowItems = <Widget>[];
        for (var icon in backend.get<ResourceService>().deliverableIcons) {
          rowItems.add(
            CategoryButton(
              radius: 35.0,
              child: InfMemoryImage(
                icon.iconData,
                color: Colors.white,
              ),
              label: icon.name,
            ),
          );
        }

        return SizedBox(
          height: 100.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowItems,
          ),
        );
  }

  Widget buildSocialPlatformRow() {
    var rowContent = <Widget>[];
    for (var provider
        in backend.get<ResourceService>().socialNetworkProviders) {
      if (provider.canBeUsedAsFilter) {
        rowContent.add(Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            width: 60.0,
            height: 60.0,
            child: SocialNetworkToggleButton(
              isSelected: false,
              provider: provider,
            )));
      }
    }
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowContent,
      ),
    );
  }

  void onNext(BuildContext context) {
    MultiPageWizard.of(context).nextPage();
  }
}

class OverFlowRow extends StatelessWidget {
  final double numberOfItemsToDisplay;
  final List<Widget> items;
  final double height;
  final double spacing;

  const OverFlowRow(
      {Key key,
      @required this.numberOfItemsToDisplay,
      @required this.items,
      @required this.height,
      this.spacing = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var segmentSpace =
              constraints.maxWidth / (numberOfItemsToDisplay + 0.5);

          var listItems = <Widget>[];
          for (var item in items) {
            listItems.add(Container(
                padding: EdgeInsets.only(right: spacing),
                width: segmentSpace,
                child: item));
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: listItems,
          );
        },
      ),
    );
  }
}
