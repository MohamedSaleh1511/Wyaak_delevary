import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? name;
  final String? avatar;
  const ChatAppbar({super.key, this.avatar, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 5),
            IconButton(
              onPressed: () => Get.back(),
              icon: Transform.flip(
                flipX: Get.locale == const Locale('ar'),
                child: 'Arrow Back'.iconColored(),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                        width: 35,
                        height: 35,
                        child:
                            "${Constants.baseUrl}storage/$avatar".profileImage),
                  ),
                  const SizedBox(width: 10),
                  '$name'.body(
                    color: Colors.black,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight + 5);
}
