import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/category_selector_view.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/deliverable_selector.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/social_platform_selector.dart';

class AddOfferStep2 extends MultiPageWizardPageWidget {
  const AddOfferStep2({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep2State createState() => _AddOfferStep2State();
}

class _AddOfferStep2State extends MultiPageWizardPageState<AddOfferStep2> {
  ValueNotifier<Category> activeTopLevelCategory = ValueNotifier<Category>(null);

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const Align(
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
              const ColumnSeparator(),
              DeliverySelector(
                padding: const EdgeInsets.only(left: 24.0, right: 24),
                label: 'CONTENT TYPE',
                deliverableTypes: widget.offerBuilder.deliverableTypes,
              ),
              const ColumnSeparator(),
              Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24),
                  child: InfTextFormField(
                    initialValue: widget.offerBuilder.deliverableDescription,
                    decoration: const InputDecoration(labelText: 'DELIVERABLE DESCRIPTION'),
                    onSaved: (s) => widget.offerBuilder.deliverableDescription = s,
                    validator: (s) => s.isEmpty ? 'You have so provide a description' : null,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ],
          ), // InfBottomButton
          bottom: InfBottomButton(
            color: Colors.white,
            text: 'NEXT',
            onPressed: nextPage,
          ),
        ),
      ],
    );
  }

  @override
  void onPrevPage() {
    print('onPrevPage 2');
    _form.currentState.save();
  }

  @override
  void nextPage() async {
    if (_form.currentState.validate()) {
      if (widget.offerBuilder.categories.isEmpty ||
          widget.offerBuilder.channels.isEmpty ||
          widget.offerBuilder.deliverableTypes.isEmpty) {
        await showMessageDialog(context, 'We need a bit more...',
            'Please select at least one of categories, social platforms and content types.');
        return;
      }
      _form.currentState.save();
      super.nextPage();
    } else {
      await showMessageDialog(context, 'We need a bit more...', 'Please fill out all fields');
    }
  }
}
