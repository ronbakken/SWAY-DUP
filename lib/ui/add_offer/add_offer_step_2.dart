import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/category_selector.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';

import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/social_network_toggle_button.dart';
import 'package:inf/utils/selection_set.dart';

class AddOfferStep2 extends StatefulWidget {
  const AddOfferStep2({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep2State createState() {
    return new _AddOfferStep2State();
  }
}

class _AddOfferStep2State extends State<AddOfferStep2> {
  ValueNotifier<Category> activeTopLevelCategory =
      ValueNotifier<Category>(null);

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
          LayoutBuilder(
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
                        AnimatedCrossFade(
                          duration: const Duration(microseconds: 500),
                          firstChild: _spacer(),
                          secondChild: buildCategorySelector(),
                          crossFadeState: activeTopLevelCategory.value == null
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 24.0, bottom: 16.0),
                          child: Text(
                            'SOCIAL PLATFORM',
                            textAlign: TextAlign.left,
                            style: AppTheme.textStyleformfieldLabel,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: buildSocialPlatformRow(),
                        ),
                        _spacer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 24.0, bottom: 24.0),
                          child: Text(
                            'CONTENT TYPE',
                            textAlign: TextAlign.left,
                            style: AppTheme.textStyleformfieldLabel,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
                          child: buildDeliverableTypeRow(),
                        ),
                        _spacer(),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 24.0, bottom: 24.0),
                          child: Text(
                            'DELIVERABLE DESCRIPTION',
                            textAlign: TextAlign.left,
                            style: AppTheme.textStyleformfieldLabel,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
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
    var categories = widget.offerBuilder.categories;
    return ListenableBuilder(
        listenable: categories,
        builder: (context, widget) {
          final topLevelCategories = backend
              .get<ResourceService>()
              .categories
              .where((item) => item.parentId == null);
          final rowItems = <Widget>[];
          for (var topLevelCategory in topLevelCategories) {
            rowItems.add(
              CategoryButton(
                onTap: () => setState(() {
                      activeTopLevelCategory.value = topLevelCategory;
                    }),
                radius: 35.0,
                child: InfMemoryImage(
                  topLevelCategory.iconData,
                  color: Colors.white,
                ),
                selectedSubCategories: categories.values
                    .where(
                        (category) => category.parentId == topLevelCategory.id)
                    .length,
                label: topLevelCategory.name,
              ),
            );
          }
          return new OverFlowRow(
            height: 100.0,
            items: rowItems,
            numberOfItemsToDisplay: 4,
            spacing: 4.0,
          );
        });
  }

  Widget buildDeliverableTypeRow() {
    final rowItems = <Widget>[];
    for (var icon in backend.get<ResourceService>().deliverableIcons) {
      rowItems.add(
        CategoryButton(
          onTap: () => setState(() => widget.offerBuilder.deliverableTypes.toggle(icon.deliverableType)),
          radius: 35.0,
          child: InfMemoryImage(
            icon.iconData,
            color: Colors.white,
          ),
          label: icon.name,
          selected: widget.offerBuilder.deliverableTypes.contains(icon.deliverableType),
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
              onTap: ()=> setState(() => widget.offerBuilder.channels.toggle(provider)),
              isSelected: widget.offerBuilder.channels.contains(provider),
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

  Widget buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: CurvedBox(
        curveFactor: 1.5,
        bottom: false,
        top: true,
        color: AppTheme.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32, 16, 8),
                child: ListenableBuilder(
                  listenable: activeTopLevelCategory,
                  builder: (contex, child) => CategorySelector(
                        topLevelCategory: activeTopLevelCategory.value,
                        selectedCategories: widget.offerBuilder.categories,
                      ),
                )),
            Container(
              color: AppTheme.darkGrey,
              child: Center(
                child: InkWell(
                  onTap: () => setState(() => activeTopLevelCategory.value = null),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.lightBlue,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 10.0,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text('Close'),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
