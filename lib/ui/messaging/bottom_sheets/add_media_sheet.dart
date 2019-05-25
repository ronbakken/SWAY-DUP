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
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        left: 25.0,
        right: 25.0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(
            opacity: loading ? 0.3 : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfBottomButton(
                  text: "CAMERA",
                  icon: Icon(Icons.camera_alt),
                  color: AppTheme.charcoalGrey,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => onSelectImage(context, useCamera: true),
                ),
                InfBottomButton(
                  text: "PHOTO & VIDEO LIBRARY",
                  icon: Icon(Icons.photo),
                  color: AppTheme.charcoalGrey,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => onSelectImage(context, useCamera: false),
                ),
                InfBottomButton(
                  text: "LINK",
                  icon: Icon(Icons.attach_file),
                  color: AppTheme.charcoalGrey,
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () => onSelectLink(context),
                ),
                verticalMargin32,
              ],
            ),
          ),
          if (loading) loadingWidget,
        ],
      ),
    );
  }

  void startLoading() => setState(() => loading = true);

  void onSelectImage(BuildContext context, {bool useCamera = false}) async {
    final selectedImageFile =
        useCamera ? await backend<ImageService>().takePicture() : await backend<ImageService>().pickImage();

    if (selectedImageFile == null) return;

    startLoading();

    final uploadedImage = await backend<ImageService>().uploadImageReference(
      fileNameTrunc: 'message_attachment_media',
      imageReference: ImageReference(imageFile: selectedImageFile),
      imageWidth: 500,
      lowResWidth: 100,
    );

    Navigator.of(context).pop<MessageAttachment>(MessageAttachment.forObject(uploadedImage));
  }

  void onSelectLink(BuildContext context) async {
    final url = await Navigator.of(context).push<AttachmentLink>(_LinkInputSheet.route());
    if (url == null) return;

    Navigator.of(context).pop<MessageAttachment>(MessageAttachment.forObject(url));
  }
}

class _LinkInputSheet extends StatelessWidget {
  static Route<AttachmentLink> route() {
    return InfBottomSheet.route<AttachmentLink>(
      title: 'Add link',
      child: _LinkInputSheet(),
    );
  }

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30,
        left: 25.0,
        right: 25.0,
      ),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InfTextFormField.url(
              labelText: "URL",
              onSaved: (s) => Navigator.of(context).pop<AttachmentLink>(AttachmentLink(value: s)),
            ),
            InfBottomButton(
              text: "SUBMIT",
              onPressed: onSubmit,
            )
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    if (!_form.currentState.validate()) return;

    _form.currentState.save();
  }
}
