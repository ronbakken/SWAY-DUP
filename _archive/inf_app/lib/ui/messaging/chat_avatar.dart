import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/user_profile/view_profile_page.dart';
import 'package:inf/ui/widgets/inf_image.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: CircleBorder(side: BorderSide(color: AppTheme.charcoalGrey, width: 1.5)),
      ),
      child: ClipOval(
        child: SizedBox(
          width: 38.0,
          height: 38.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              InfImage.fromProvider(
                user.avatarThumbnail,
                fit: BoxFit.cover,
              ),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(ViewProfilePage.route(user)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
