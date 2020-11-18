import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/image_selector.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class AddOfferStep1 extends MultiPageWizardPageWidget {
  const AddOfferStep1({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep1State createState() => _AddOfferStep1State();
}

class _AddOfferStep1State extends MultiPageWizardPageState<AddOfferStep1> {
  int selectedImageIndex = 0;

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
            children: [
              ImageSelector(
                imageReferences: widget.offerBuilder.images,
                imageAspecRatio: 4 / 3,
                onImageChanged: (images) => widget.offerBuilder.images = images,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InfTextFormField(
                          initialValue: widget.offerBuilder.title,
                          decoration: const InputDecoration(labelText: 'TITLE'),
                          onSaved: (s) => widget.offerBuilder.title = s,
                          validator: (s) => s.isEmpty ? 'You have so provide a title' : null,
                        ),
                        verticalMargin32,
                        InfTextFormField(
                          initialValue: widget.offerBuilder.deliverableDescription,
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
  void nextPage() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      super.nextPage();
    } else {
      showMessageDialog(
        context,
        'We need a bit more...',
        'Please fill out all fields',
      );
    }
  }
}
