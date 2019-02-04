import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/inf_date_picker.dart';
import 'package:inf/ui/widgets/inf_radio_button.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/inf_time_picker.dart';

import 'package:intl/intl.dart';

class AddOfferStep4 extends StatefulWidget {
  const AddOfferStep4({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep4State createState() {
    return new _AddOfferStep4State();
  }
}

class _AddOfferStep4State extends State<AddOfferStep4> {
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
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  fit: StackFit.passthrough,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomAnimatedCurves(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                      child: Form(
                        key: form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Table(
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                        child: InfDatePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER START DATE',
                                          ),
                                          // initialValue: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(Duration(days: 90)),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                        child: InfTimePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER START TIME',
                                          ),
                                          initialValue: TimeOfDay.now(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                        child: InfDatePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER END DATE',
                                          ),
                                          //initialValue: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(Duration(days: 90)),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                        child: InfTimePicker(
                                          decoration: InputDecoration(
                                            labelText: 'OFFER END TIME',
                                          ),
                                          initialValue: TimeOfDay.now(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 32.0),
                            Text(
                              'AMOUNT AVAILABLE',
                              textAlign: TextAlign.left,
                              style: AppTheme.formFieldLabelStyle,
                            ),
                            TextFormField(
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              onSaved: (s) => widget.offerBuilder.barterValue = int.tryParse(s),
                              validator: (s) => s.isEmpty ? 'You have so provide value' : null,
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                            ),
                            Row(
                              children: [
                                Align(
                                  widthFactor: 0.4,
                                  child: Checkbox(
                                    value: widget.offerBuilder.unlimitedAvailable,
                                    onChanged: (val) => setState(() => widget.offerBuilder.unlimitedAvailable = val),
                                    activeColor: AppTheme.lightBlue,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(child: Text('There is no limit')),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'How do you like to deal with proposals?',
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                            SizedBox(height: 16.0),
                            InfRadioButton<AcceptancePolicy>(
                              value: AcceptancePolicy.manualReview,
                              groupValue: widget.offerBuilder.acceptancePolicy,
                              label: 'MANUALLY REVIEW PROPOSALS',
                              onChanged: (val) => setState(() => widget.offerBuilder.acceptancePolicy = val),
                            ),
                            SizedBox(height: 8.0),
                            InfRadioButton<AcceptancePolicy>(
                              value: AcceptancePolicy.automaticAcceptMatching,
                              groupValue: widget.offerBuilder.acceptancePolicy,
                              label: 'ACCEPT MATCHING PROPOSALS',
                              onChanged: (val) => setState(() => widget.offerBuilder.acceptancePolicy = val),
                            ),
                            SizedBox(height: 8.0),
                            InfRadioButton<AcceptancePolicy>(
                              value: AcceptancePolicy.allowNegotiation,
                              groupValue: widget.offerBuilder.acceptancePolicy,
                              label: 'ALLOW NEGOTIATION',
                              onChanged: (val) => setState(() => widget.offerBuilder.acceptancePolicy = val),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                              child: InfStadiumButton(
                                height: 56,
                                color: Colors.white,
                                text: 'SAVE OFFER',
                                onPressed: () => onNext(context),
                              ),
                            )
                          ],
                        ),
                      ),
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

  void onNext(BuildContext context) {
    FormState state = form.currentState;
    if (true /*state.validate()*/) {
      state.save();
    }
  }
}

class _TimeFormField extends StatefulWidget {
  final String label;
  final TimeOfDay initialValue;

  const _TimeFormField({Key key, this.label, this.initialValue}) : super(key: key);

  @override
  _TimeFormFieldState createState() {
    return new _TimeFormFieldState();
  }
}

class _TimeFormFieldState extends State<_TimeFormField> {
  TimeOfDay _selectedTime;

  @override
  void initState() {
    _selectedTime = widget.initialValue;

    super.initState();
  }

  @override
  void didUpdateWidget(_TimeFormField oldWidget) {
    _selectedTime = widget.initialValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTheme.formFieldLabelStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(_selectedTime.format(context)),
        SizedBox(
          height: 8.0,
        ),
        Container(
          height: 1,
          color: AppTheme.white30,
        )
      ],
    );
  }
}
