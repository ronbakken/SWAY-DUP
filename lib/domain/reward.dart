import 'dart:typed_data';

import 'package:decimal/decimal.dart';

enum RewardType {barter, cash}

class Reward
{
   final int id;
   final String description;
   final Decimal value;
   final RewardType type; 

   final String imageUrl;
   final Uint8List imageLowRes;

  Reward( {this.id, this.type, this.description, this.value, this.imageUrl, this.imageLowRes});
}