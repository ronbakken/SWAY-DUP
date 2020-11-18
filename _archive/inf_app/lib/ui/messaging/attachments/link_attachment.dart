import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class LinkAttachment extends StatelessWidget {
  const LinkAttachment({
    Key key,
    @required this.link,
  }) : super(key: key);

  final AttachmentLink link;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => _openLink(context),
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 8.0),
          child: Text(
            link.value,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  void _openLink(BuildContext context) async {
    if (await url_launcher.canLaunch(link.value)) {
      unawaited(url_launcher.launch(link.value));
    } else {
      showMessageDialog(context, 'Error', 'Sorry, don\'t know how to open that link.');
    }
  }
}
