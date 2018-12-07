import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
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
    final rowContent = [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration:
                  BoxDecoration(color: AppTheme.grey, shape: BoxShape.circle),
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
              decoration:
                  BoxDecoration(color: AppTheme.grey, shape: BoxShape.circle),
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
                              padding: const EdgeInsets.only(
                                  left: 24.0, top: 24.0, bottom: 24.0),
                              child: Text(
                                'PLEASE SELECT CATEGORIES',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: buildCategoryRow(rowContent),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 24.0),
                              height: 1,
                              color: AppTheme.white30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, bottom: 24.0),
                              child: Text(
                                'SOCIAL PLATFORM',
                                textAlign: TextAlign.left,
                                style: AppTheme.textStyleformfieldLabel,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0),
                                child: buildSocialPlatformRow(),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 24.0),
                              height: 1,
                              color: AppTheme.white30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, bottom: 24.0),
                              child: Text(
                                'CONTENT TYPE',
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 24.0),
                              height: 1,
                              color: AppTheme.white30,
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

  Widget buildCategoryRow(List<Padding> rowContent) {
    return new OverFlowRow(
      height: 60.0,
      items: <Widget>[
        CategoryButton(
          child: Icon(Icons.account_box),
          selectedSubCategories: 4,
        ),
        CategoryButton(
          child: Icon(Icons.account_box),
        ),
        CategoryButton(
          child: Icon(Icons.account_box),
        ),
        CategoryButton(
          child: Icon(Icons.account_box),
        ),
        CategoryButton(
          child: Icon(Icons.account_box),
        ),
        CategoryButton(
          child: Icon(Icons.account_box),
        ),
        CategoryButton(
          child: Icon(Icons.account_box),
        ),
      ],
      numberOfItemsToDisplay: 4,
      spacing: 4.0,
    );
  }

  Widget buildSocialPlatformRow() {
    return FutureBuilder<List<SocialNetworkProvider>>(
        future: backend
            .get<AuthenticationService>()
            .getAvailableSocialNetworkProviders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SizedBox(
              height: 40.0,
            );
          }
          var rowContent = <Widget>[];
          for (var provider in snapshot.data) {
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
        });
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
                child: AspectRatio(aspectRatio: 1.0, child: item)));
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

