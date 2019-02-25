import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/category_selector_view.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/deliverable_selector.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';

import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/social_platform_selector.dart';

class AddOfferStep2 extends StatefulWidget {
  const AddOfferStep2({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep2State createState() => _AddOfferStep2State();
}

class _AddOfferStep2State extends State<AddOfferStep2> with MultiPageWizardNav<AddOfferStep2> {
  ValueNotifier<Category> activeTopLevelCategory = ValueNotifier<Category>(null);

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setUpNav(context);
  }


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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CategorySelectorView(
                selectedCategories: widget.offerBuilder.categories,
                label: 'PLEASE SELECT CATEGORIES',
                padding: const EdgeInsets.only(left: 24.0, top: 32.0, bottom: 24.0),
              ),
              SocialPlatformSelector(
                label: 'SOCIAL PLATFORM',
                channels: widget.offerBuilder.channels,
                padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
              ),
              ColumnSeparator(),
              DeliverySelector(
                padding: const EdgeInsets.only(left: 24.0, right: 24),
                label: 'CONTENT TYPE',
                deliverableTypes: widget.offerBuilder.deliverableTypes,
              ),
              ColumnSeparator(),
              Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  child: InfTextFormField(
                    decoration: const InputDecoration(labelText: 'DELIVERABLE DESCRIPTION'),
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
                  onPressed: onNextPage,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onPrevPage() {
    _form.currentState.save();
  }

  @override
  void onNextPage() {
    if (_form.currentState.validate() || true) {
      _form.currentState.save();
      MultiPageWizard.of(context).nextPage();
    }
  }
}
