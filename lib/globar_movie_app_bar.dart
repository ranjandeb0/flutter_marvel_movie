// import 'dart:html';

import 'package:flutter/material.dart';

class MovieAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MovieAppBar({
    super.key,
  });

  final double _height = 90.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
      toolbarHeight: 90.0,
      title: Image.asset('assets/images/Marvel-Logo.jpg', height: 45.0),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(
            'assets/images/Profile-ring-small.png',
            height: 70,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_height);
}
