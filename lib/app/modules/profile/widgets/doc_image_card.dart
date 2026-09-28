import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/auth/controllers/auth_controller.dart';

class DocImageCard extends GetWidget<AuthController> {
  final bool isLink;
  final String imagePath;
  final String imageName;
  final VoidCallback onEditTap;
  const DocImageCard({
    super.key,
    required this.isLink,
    required this.imagePath,
    required this.imageName,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Get.generalDialog(
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              Tween<Offset> tween;
              if (animation.status == AnimationStatus.reverse) {
                tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
              } else {
                tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
              }

              return SlideTransition(
                position: tween.animate(CurvedAnimation(
                    parent: animation, curve: Curves.fastEaseInToSlowEaseOut)),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                InteractiveViewer(
              child: SizedBox(
                width: Get.width,
                child: isLink
                    ? '${Constants.baseUrl}storage/$imagePath'
                        .image(isProfile: false, isTap: true)
                    : Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        width: Get.width,
                      ),
              ),
            ),
            barrierColor: Colors.black,
            barrierDismissible: true,
            barrierLabel: 'image preview',
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: 45,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Get.theme.colorScheme.secondary,
              ),
              child: isLink
                  ? '${Constants.baseUrl}storage/$imagePath'
                      .image(isProfile: false, isTap: true)
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageName.bodyMedium(
                    color: Colors.black,
                    maxLines: 1,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  imagePath
                      .split('/')
                      .last
                      .caption(color: Colors.black, maxLines: 1),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: onEditTap,
              icon: 'edit'.iconColored(color: Colors.white),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ).decorate(padding: 10),
    );
  }
}
