import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/inf_bottom_button.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_text_form_field.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class AddMediaSheet extends StatefulWidget {
  static Route<MessageAttachment> route() {
    return InfBottomSheet.route<MessageAttachment>(
      title: 'Add media',
      child: AddMediaSheet(),
    );
  }

  @override
  _AddMediaSheetState createState() => _AddMediaSheetState();
}

class _AddMediaSheetState extends State<AddMediaSheet> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(
            opacity: _loading ? 0.3 : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfBottomButton(
                  text: 'CAMERA',
                  icon: const Icon(Icons.camera_alt),
                  color: AppTheme.charcoalGrey,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => onSelectImage(context, useCamera: true),
                ),
                InfBottomButton(
                  text: 'PHOTO & VIDEO LIBRARY',
                  icon: const Icon(Icons.photo),
                  color: AppTheme.charcoalGrey,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => onSelectImage(context, useCamera: false),
                ),
                InfBottomButton(
                  text: 'LINK',
                  icon: const Icon(Icons.attach_file),
                  color: AppTheme.charcoalGrey,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => onSelectLink(context),
                ),
                verticalMargin32,
              ],
            ),
          ),
          if (_loading) loadingWidget,
        ],
      ),
    );
  }

  void onSelectImage(BuildContext context, {bool useCamera = false}) async {
    File selectedImageFile;
    if (useCamera) {
      selectedImageFile = await backend<ImageService>().takePicture();
    } else {
      selectedImageFile = await backend<ImageService>().pickImage();
    }
    if (selectedImageFile != null) {
      setState(() => _loading = true);

      final uploadedImage = await backend<ImageService>().uploadImageReference(
        fileNameTrunc: 'message_attachment_media',
        imageReference: ImageReference(imageFile: selectedImageFile),
        imageWidth: 2048,
        lowResWidth: 640,
      );

      Navigator.of(context).pop<MessageAttachment>(MessageAttachment.forObject(uploadedImage));
    }
  }

  void onSelectLink(BuildContext context) async {
    final url = await Navigator.of(context).push<AttachmentLink>(_LinkInputSheet.route());
    if (url != null) {
      Navigator.of(context).pop<MessageAttachment>(MessageAttachment.forObject(url));
    }
  }
}

class _LinkInputSheet extends StatefulWidget {
  static Route<AttachmentLink> route() {
    return InfBottomSheet.route<AttachmentLink>(
      title: 'Add link',
      child: _LinkInputSheet(),
    );
  }

  @override
  _LinkInputSheetState createState() => _LinkInputSheetState();
}

class _LinkInputSheetState extends State<_LinkInputSheet> {
  final _form = GlobalKey<FormState>();

  String _url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InfTextFormField.url(
              labelText: 'URL',
              onSaved: (value) => _url = value,
            ),
            InfBottomButton(
              text: 'SUBMIT',
              onPressed: onSubmit,
            )
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Navigator.of(context).pop<AttachmentLink>(AttachmentLink(value: _url));
    }
  }
}
