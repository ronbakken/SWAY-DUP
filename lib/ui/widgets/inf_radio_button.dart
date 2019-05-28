import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class InfRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T> onChanged;
  final VoidCallback onHelpButtonTapped;

  const InfRadioButton({Key key, this.value, this.groupValue, this.label, this.onChanged, this.onHelpButtonTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        decoration: BoxDecoration(
          color: value == groupValue ? AppTheme.radioButtonBgSelected : AppTheme.radioButtonBgUnselected,
          borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
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
                child: value == groupValue ? const InfIcon(AppIcons.check, size: 16) : emptyWidget,
              ),
              Expanded(
                  child: Text(
                label,
                textAlign: TextAlign.center,
              )),
              if (onHelpButtonTapped != null)
                HelpButton(
                  onTap: onHelpButtonTapped,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
