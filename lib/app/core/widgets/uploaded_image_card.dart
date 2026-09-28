import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class UploadedImageCard extends GetWidget {
  final String imagePath;
  final VoidCallback onDeleteTap;
  const UploadedImageCard({
    super.key,
    required this.imagePath,
    required this.onDeleteTap,
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
              child: Image.file(
                File(imagePath),
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
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imagePath
                      .split('/')
                      .last
                      .bodyMedium(color: Colors.black, maxLines: 2),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: onDeleteTap,
              icon: 'trash'.iconColored(color: Colors.white),
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
