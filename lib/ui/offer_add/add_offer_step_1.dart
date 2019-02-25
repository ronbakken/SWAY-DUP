import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/image_selector.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';

class AddOfferStep1 extends StatefulWidget {
  const AddOfferStep1({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep1State createState() => _AddOfferStep1State();
}

class _AddOfferStep1State extends State<AddOfferStep1> with MultiPageWizardNav<AddOfferStep1> {
  int selectedImageIndex = 0;
  
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
                          decoration: const InputDecoration(labelText: 'TITLE'),
                          onSaved: (s) => widget.offerBuilder.title = s,
                          validator: (s) => s.isEmpty ? 'You have so provide a title' : null,
                        ),
                        SizedBox(height: 32.0),
                        InfTextFormField(
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
