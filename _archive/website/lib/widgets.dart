import 'dart:convert' show utf8;

import 'package:flutter_markdown_web/flutter_markdown.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class MarkdownAsset extends StatelessWidget {
  const MarkdownAsset({
    Key key,
    @required this.assetName,
  }) : super(key: key);

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData>(
      future: rootBundle.load(assetName),
      builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
        if (snapshot.hasData) {
          return MarkdownBody(data: utf8.decode(snapshot.data.buffer.asUint8List()));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
