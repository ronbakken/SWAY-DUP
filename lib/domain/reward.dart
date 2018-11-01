import 'dart:typed_data';

import 'package:decimal/decimal.dart';

enum RewardType {barter, cash}

class Reward
{
   int id;
   String description;
   Decimal value; 

   String imageUrl;
   Uint8List imageLowRes;
}