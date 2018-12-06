import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';

class SocialNetworkToggleButton extends StatefulWidget {
  final SocialNetworkProvider provider;
  final ValueChanged<bool> onChange;
  final bool isSelected;

  const SocialNetworkToggleButton({Key key, this.provider, this.onChange, this.isSelected}) : super(key: key);

  @override
  _SocialNetworkToggleButtonState createState() => _SocialNetworkToggleButtonState();
}

class _SocialNetworkToggleButtonState extends State<SocialNetworkToggleButton> {
  bool _isSelected;

  @override
    void initState() {
      _isSelected = widget.isSelected;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    var logoStack = <Widget>[];

    if (widget.provider.logoBackgroundData != null) {
      logoStack.add(InfMemoryImage(
        widget.provider.logoBackgroundData,
        fit: BoxFit.fill,
      ));
    } else {
      logoStack.add(Container(
        color: Color(widget.provider.logoBackGroundColor),
      ));
    }
    logoStack.add(
      Center(
        child: SizedBox(
          height: 60.0,
          child: InfMemoryImage(
            widget.provider.logoMonochromeData,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    if (!_isSelected)
    {
       logoStack.add(Container(color: Colors.black54,)); 
    }

    return InkResponse(
          onTap: onTap,
          child: ClipOval(
        child: Stack(
          children: logoStack,
        ),
      ),
    );
  }

  void onTap()
  {
    setState(() {
        _isSelected = !_isSelected;      
    });
  }

}
