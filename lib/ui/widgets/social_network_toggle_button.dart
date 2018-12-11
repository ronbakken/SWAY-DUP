import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';

class SocialNetworkToggleButton extends StatelessWidget {
  final SocialNetworkProvider provider;
  final VoidCallback onTap;
  final bool isSelected;
  final double radius;

  const SocialNetworkToggleButton({
    Key key,
    @required this.radius,
    @required this.provider,
    @required this.onTap,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var logoStack = <Widget>[];

    if (provider.logoBackgroundData != null) {
      logoStack.add(InfMemoryImage(
          provider.logoBackgroundData,
          fit: BoxFit.fill,
        ));
    } else {
      logoStack.add(Container(
        color: Color(provider.logoBackGroundColor),
      ));
    }
    logoStack.add(
      Center(
        child: SizedBox(
          height: 2*radius * 0.8,
          child: InfMemoryImage(
            provider.logoMonochromeData,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    if (!isSelected) {
      logoStack.add(Container(
        color: Colors.black54,
      ));
    }

    return InkResponse(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 2*radius,
          height: 2*radius,
          child: ClipOval(
            child: Stack(
              overflow: Overflow.clip,
                fit: StackFit.passthrough,
                alignment: Alignment.center,
                children: logoStack,
              ),
          ),
        ),
      ),
    );
  }

}
