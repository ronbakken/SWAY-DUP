import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';

class SocialNetworkToggleButton extends StatelessWidget {
  final SocialNetworkProvider provider;
  final VoidCallback onTap;
  final bool isSelected;

  const SocialNetworkToggleButton({
    Key key,
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
          height: 60.0,
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
      child: ClipOval(
        child: Stack(
          children: logoStack,
        ),
      ),
    );
  }

}
