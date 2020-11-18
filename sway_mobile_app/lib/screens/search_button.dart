/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/material.dart';

// Widget for editing a page
class SearchButton extends StatelessWidget {
  // Constructor
  const SearchButton({
    Key key,
    this.onSearchPressed,
  }) : super(key: key);

  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: onSearchPressed,
    );
  }
}

/* end of file */
