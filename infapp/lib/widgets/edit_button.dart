import 'package:flutter/material.dart';

import '../network/config_manager.dart';
import '../profile/profile_edit.dart';

class EditButton extends StatelessWidget {

  // Constructor
  EditButton({
    Key key,
  }) : super(key: key);
	
  // TODO: Refactor
  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(Icons.edit),
      onPressed: () { 
        Navigator.push( 
          context,
          new MaterialPageRoute( 
            builder: (context) {
              assert(ConfigManager.of(context) != null);
              return new ProfileEdit();
            },
          ), 
        );
      }
    );
  }
}
