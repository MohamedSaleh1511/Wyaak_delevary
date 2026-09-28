import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class GlobalAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const GlobalAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title.titleSmall(color: Colors.black),
      centerTitle: false,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Get.locale == const Locale('en')
            ? 'Arrow Back'.iconColored()
            : Transform.rotate(
                angle: pi,
                child: 'Arrow Back'.iconColored(),
              ),
      ),
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight + 5);
}
