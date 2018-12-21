import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/location_selector_page.dart';

import 'package:inf/ui/widgets/multipage_wizard.dart';
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
                child: Stack(fit: StackFit.passthrough, alignment: Alignment.bottomCenter, children: [
                  InfAssetImage(
                    AppImages.mockCurves, // FIXME:
                    alignment: Alignment.bottomCenter,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                    child: Form(
                      key: form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                    child: _DateFormField(
                                      label: 'OFFER START DATE',
                                      initialValue: DateTime.now(),
                                    ),
                                  )),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                      child: _TimeFormField(
                                        label: 'OFFER START TIME',
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
                                    child: _DateFormField(
                                      label: 'OFFER START DATE',
                                      initialValue: DateTime.now(),
                                    ),
                                  )),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                                      child: _TimeFormField(
                                        label: 'OFFER START TIME',
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
                            style: AppTheme.textStyleformfieldLabel,
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
                            onChanged: (val) => setState( () => widget.offerBuilder.acceptancePolicy = val),
                          ),
                          SizedBox(height: 8.0),
                          InfRadioButton<AcceptancePolicy>(
                            value: AcceptancePolicy.automaticAcceptMatching,
                            groupValue: widget.offerBuilder.acceptancePolicy,
                            label: 'ACCEPT MATCHING PROPOSALS',
                            onChanged: (val) => setState( () => widget.offerBuilder.acceptancePolicy = val),
                          ),
                          SizedBox(height: 8.0),
                          InfRadioButton<AcceptancePolicy>(
                            value: AcceptancePolicy.allowNegotiation,
                            groupValue: widget.offerBuilder.acceptancePolicy,
                            label: 'ALLOW NEGOTIATION',
                            onChanged: (val) => setState( () => widget.offerBuilder.acceptancePolicy = val),

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
                ]),
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

  Container _spacer() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 32),
      height: 1,
      color: AppTheme.white30,
    );
  }
}

class _DateFormField extends StatefulWidget {
  final String label;
  final DateTime initialValue;

  const _DateFormField({Key key, this.label, this.initialValue}) : super(key: key);

  @override
  _DateFormFieldState createState() {
    return new _DateFormFieldState();
  }
}

class _DateFormFieldState extends State<_DateFormField> {
  DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.initialValue;
    _dateAsString = _formatter.format(_selectedDate);
    super.initState();
  }

  @override
  void didUpdateWidget(_DateFormField oldWidget) {
    _selectedDate = widget.initialValue;
    _dateAsString = _formatter.format(_selectedDate);
    super.didUpdateWidget(oldWidget);
  }

  final DateFormat _formatter = DateFormat("MM / dd / yyyy");

  String _dateAsString;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTheme.textStyleformfieldLabel,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(_dateAsString),
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
          style: AppTheme.textStyleformfieldLabel,
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

class InfRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;

  const InfRadioButton({Key key, this.value, this.groupValue, this.label, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        decoration: BoxDecoration(
          color: value == groupValue ? AppTheme.radioButtonBgSelected : AppTheme.radioButtonBgUnselected,
          borderRadius: BorderRadius.all(const Radius.circular(5.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: AppTheme.grey,
                  ),
                  shape: BoxShape.circle,
                  color: value == groupValue ? AppTheme.lightBlue : AppTheme.darkGrey,
                ),
                child: value == groupValue
                    ? Icon(
                        Icons.check,
                        size: 24,
                      )
                    : SizedBox(),
              ),
              Text(label),
              HelpButton(),
            ],
          ),
        ),
      ),
    );
  }
}
