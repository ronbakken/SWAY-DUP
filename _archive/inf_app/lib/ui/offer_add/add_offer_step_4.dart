import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/animated_curves.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_date_picker.dart';
import 'package:inf/ui/widgets/inf_loader.dart';
import 'package:inf/ui/widgets/inf_page_scroll_view.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/inf_time_picker.dart';
import 'package:inf/ui/widgets/multipage_wizard.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:rx_command/rx_command.dart';

class AddOfferStep4 extends MultiPageWizardPageWidget {
  AddOfferStep4({
    Key key,
    this.offerBuilder,
  }) : super(key: key);

  final OfferBuilder offerBuilder;

  @override
  _AddOfferStep4State createState() => _AddOfferStep4State();
}

class _AddOfferStep4State extends MultiPageWizardPageState<AddOfferStep4> {
  ValueNotifier<Category> activeTopLevelCategory = ValueNotifier<Category>(null);
  TextEditingController amountController = TextEditingController();
  RxCommandListener<OfferBuilder, double> updateOfferListener;

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    widget.offerBuilder.acceptancePolicy = OfferDto_AcceptancePolicy.allowNegotiation;

    amountController = TextEditingController(
        text: widget.offerBuilder.unlimitedAvailable
            ? ''
            : widget.offerBuilder.numberOffered != null ? widget.offerBuilder.numberOffered.toString() : '');

    var updateOfferCommand = backend<OfferManager>().updateOfferCommand;

    updateOfferListener = RxCommandListener(
      updateOfferCommand,
      onValue: (val) {
        if (val == 1.0) {
          print(val);
          InfLoader.hide();
          Navigator.of(context).pop();
        }
      },
      onIsBusy: () {
        InfLoader.show(context);
        // InfLoader.show(context, updateOfferCommand);
      },
      onNotBusy: () => InfLoader.hide(),
    );
  }

  @override
  void dispose() {
    updateOfferListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const Align(
          alignment: Alignment.bottomCenter,
          child: CustomAnimatedCurves(),
        ),
        InfPageScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
            child: Form(
              onChanged: () => _form.currentState.save(),
              key: _form,
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
                                decoration: const InputDecoration(
                                  labelText: 'OFFER START DATE',
                                ),
                                initialValue: widget.offerBuilder.startDate,
                                firstDate: now,
                                lastDate: now.add(const Duration(days: 90)),
                                validator: (date) => date == null ? 'You have to provide a date' : null,
                                onSaved: (date) => widget.offerBuilder.startDate = date,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                              child: InfTimePicker(
                                decoration: const InputDecoration(
                                  labelText: 'OFFER START TIME',
                                ),
                                initialValue: widget.offerBuilder.startTime,
                                validator: (time) => time == null ? 'You have to provide a time' : null,
                                onSaved: (time) => widget.offerBuilder.startTime = time,
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
                                decoration: const InputDecoration(
                                  labelText: 'OFFER END DATE',
                                ),
                                initialValue: widget.offerBuilder.endDate == null
                                    ? null
                                    : widget.offerBuilder.endDate.compareTo(widget.offerBuilder.startDate) < 0
                                        ? widget.offerBuilder.startDate ?? now
                                        : widget.offerBuilder.endDate,
                                firstDate: widget.offerBuilder.startDate ?? now,
                                lastDate: DateTime.now().add(const Duration(days: 90)),
                                validator: (date) => date == null ? 'You have to provide a date' : null,
                                onSaved: (date) {
                                  return widget.offerBuilder.endDate = date;
                                },
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24, bottom: 16.0),
                              child: InfTimePicker(
                                decoration: const InputDecoration(
                                  labelText: 'OFFER END TIME',
                                ),
                                initialValue: widget.offerBuilder.endTime,
                                validator: (time) => time == null ? 'You have to provide a time' : null,
                                onSaved: (time) => widget.offerBuilder.endTime = time,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  verticalMargin32,
                  InfTextFormField(
                    controller: amountController,
                    enabled: !widget.offerBuilder.unlimitedAvailable,
                    decoration: const InputDecoration(labelText: 'AMOUNT AVAILABLE'),
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    onSaved: (s) {
                      return widget.offerBuilder.numberOffered = int.tryParse(s);
                    },
                    validator: (s) =>
                        s.isEmpty && !widget.offerBuilder.unlimitedAvailable ? 'You have so provide value' : null,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  ),
                  Row(
                    children: [
                      Align(
                        widthFactor: 0.4,
                        child: Checkbox(
                          value: widget.offerBuilder.unlimitedAvailable,
                          onChanged: (isChecked) => setState(() {
                                if (isChecked) {
                                  widget.offerBuilder.numberOffered = 1;
                                  amountController.clear();
                                }
                                return widget.offerBuilder.unlimitedAvailable = isChecked;
                              }),
                          activeColor: AppTheme.lightBlue,
                        ),
                      ),
                      horizontalMargin8,
                      const Expanded(child: Text('There is no limit')),
                    ],
                  ),
                  verticalMargin16,
                  const Text(
                    'How do you like to deal with proposals?',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  /*
                  verticalMargin16,
                  InfRadioButton<OfferDto_AcceptancePolicy>(
                    value: OfferDto_AcceptancePolicy.manualReview,
                    groupValue: widget.offerBuilder.acceptancePolicy,
                    label: 'MANUALLY REVIEW PROPOSALS',
                    onChanged: (val) => setState(() => widget.offerBuilder.acceptancePolicy = val),
                  ),
                  verticalMargin8,
                  InfRadioButton<OfferDto_AcceptancePolicy>(
                    value: OfferDto_AcceptancePolicy.automaticAcceptMatching,
                    groupValue: widget.offerBuilder.acceptancePolicy,
                    label: 'ACCEPT MATCHING PROPOSALS',
                    onChanged: (val) => setState(() => widget.offerBuilder.acceptancePolicy = val),
                  ),
                  verticalMargin8,
                  InfRadioButton<OfferDto_AcceptancePolicy>(
                    value: OfferDto_AcceptancePolicy.allowNegotiation,
                    groupValue: widget.offerBuilder.acceptancePolicy,
                    label: 'ALLOW NEGOTIATION',
                    onChanged: (val) => setState(() => widget.offerBuilder.acceptancePolicy = val),
                  ),
                   */
                ],
              ),
            ),
          ), // InfBottomButton
          bottom: InfBottomButton(
            color: Colors.white,
            text: 'SAVE OFFER',
            onPressed: onSave,
          ),
        ),
      ],
    );
  }

  @override
  void onPrevPage() {
    print('onPrevPage 4');
    _form.currentState.save();
  }

  void onSave() {
    if (!_form.currentState.validate()) {
      showMessageDialog(
        context,
        'We need a bit more...',
        'Please fill out all fields',
      );
      return;
    }

    if (widget.offerBuilder.acceptancePolicy == null) {
      showMessageDialog(
        context,
        'We need a bit more...',
        'Please tell us how you want to deal with proposals',
      );
      return;
    }

    _form.currentState.save();
    // FIXME make sure end date and times cannot be before startdate
    if (widget.offerBuilder.endDate.compareTo(widget.offerBuilder.startDate) < 0) {
      showMessageDialog(
        context,
        'End date cannot be before start date',
        'Please select an end date that is after the start date.',
      );
      return;
    }
    backend<OfferManager>().updateOfferCommand(widget.offerBuilder);
  }
}
