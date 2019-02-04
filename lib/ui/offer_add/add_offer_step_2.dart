import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/category_selector.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';

import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/overflow_row.dart';
import 'package:inf/ui/widgets/social_network_toggle_button.dart';

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
  ValueNotifier<Category> activeTopLevelCategory = ValueNotifier<Category>(null);

  GlobalKey form = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minWidth: constraints.maxWidth,
                maxWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomAnimatedCurves(),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 32.0, bottom: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PLEASE SELECT CATEGORIES',
                                textAlign: TextAlign.left,
                                style: AppTheme.formFieldLabelStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: HelpButton(),
                              ),
                            ],
                          ),
                        ),
                        buildCategoryRow(),
                        AnimatedSwitcher(
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                axis: Axis.vertical,
                                axisAlignment: -1.0,
                                sizeFactor: animation,
                                child: child,
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 500),
                          child: activeTopLevelCategory.value == null ? _spacer() : buildCategorySelector(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SOCIAL PLATFORM',
                                textAlign: TextAlign.left,
                                style: AppTheme.formFieldLabelStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: HelpButton(),
                              ),
                            ],
                          ),
                        ),
                        buildSocialPlatformRow(),
                        _spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                          child: Text(
                            'CONTENT TYPE',
                            textAlign: TextAlign.left,
                            style: AppTheme.formFieldLabelStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
                          child: buildDeliverableTypeRow(),
                        ),
                        _spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                          child: Text(
                            'DELIVERABLE DESCRIPTION',
                            textAlign: TextAlign.left,
                            style: AppTheme.formFieldLabelStyle,
                          ),
                        ),
                        Form(
                          key: form,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0, right: 24),
                            child: TextFormField(
                              onSaved: (s) => widget.offerBuilder.deliverableDescription = s,
                              validator: (s) => s.isEmpty ? 'You have so provide a description' : null,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
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
                  ],
                ),
              ),
            ),
          );
        },
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
        final topLevelCategories = backend.get<ConfigService>().categories.where((item) => item.parentId == -1);
        final rowItems = <Widget>[];
        for (var topLevelCategory in topLevelCategories) {
          rowItems.add(
            CategoryButton(
              onTap: () => setState(() {
                    activeTopLevelCategory.value = topLevelCategory;
                  }),
              radius: 64.0,
              child: InfMemoryImage(
                topLevelCategory.iconData,
                color: Colors.white,
                width: 32.0,
                height: 32.0,
              ),
              selectedSubCategories:
                  categories.values.where((category) => category.parentId == topLevelCategory.id).length,
              label: topLevelCategory.name,
            ),
          );
        }
        return new OverflowRow(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 96.0,
          childrenWidth: 64.0,
          children: rowItems,
        );
      },
    );
  }

  Widget buildDeliverableTypeRow() {
    final rowItems = <Widget>[];
    for (var icon in backend.get<ConfigService>().deliverableIcons) {
      rowItems.add(
        CategoryButton(
          onTap: () => setState(() => widget.offerBuilder.deliverableTypes.toggle(icon.deliverableType)),
          radius: 64.0,
          child: InfMemoryImage(
            icon.iconData,
            color: Colors.white,
            width: 32.0,
            height: 32.0,
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
    for (var provider in backend.get<ConfigService>().socialNetworkProviders) {
      rowContent.add(SocialNetworkToggleButton(
        onTap: () => setState(() => widget.offerBuilder.channels.toggle(provider)),
        isSelected: widget.offerBuilder.channels.contains(provider),
        provider: provider,
      ));
    }
    return OverflowRow(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 96.0,
      childrenWidth: 48.0,
      children: rowContent,
    );
  }

  void onNext(BuildContext context) {
    FormState state = form.currentState;
    if (true /*state.validate()*/) {
      state.save();
      MultiPageWizard.of(context).nextPage();
    }
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
              color: AppTheme.darkGrey2,
              child: Center(
                child: InkWell(
                  onTap: () => setState(() => activeTopLevelCategory.value = null),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Close'),
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
