import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/chat/controllers/chat_controller.dart';

class MessageBox extends GetWidget<ChatController> {
  final int id;
  final String message;
  final String? attachment;
  final bool isAttachmentPath;
  final DateTime createdAt;
  const MessageBox({
    super.key,
    required this.id,
    required this.message,
    required this.isAttachmentPath,
    required this.createdAt,
    this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: Get.width * 0.65,
      child: Align(
        alignment: (id != controller.appServices.userId.value
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16).copyWith(
              topLeft: (id != controller.appServices.userId.value
                  ? const Radius.circular(0)
                  : const Radius.circular(16)),
              topRight: (id != controller.appServices.userId.value
                  ? const Radius.circular(16)
                  : const Radius.circular(0)),
            ),
            color: (id != controller.appServices.userId.value
                ? Constants.softGrey
                : Get.theme.primaryColor),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            crossAxisAlignment: id != controller.appServices.userId.value
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              message.caption(
                color: (id != controller.appServices.userId.value
                    ? Colors.black
                    : Colors.white),
                weight: FontWeight.w500,
              ),
              if (attachment != null) ...{
                const SizedBox(height: 3),
                LimitedBox(
                  maxHeight: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (isAttachmentPath)
                        ? InkWell(
                            onTap: () {
                              Get.generalDialog(
                                transitionBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  Tween<Offset> tween;
                                  if (animation.status ==
                                      AnimationStatus.reverse) {
                                    tween = Tween(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero);
                                  } else {
                                    tween = Tween(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero);
                                  }

                                  return SlideTransition(
                                    position: tween.animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.fastEaseInToSlowEaseOut)),
                                    child: child,
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 600),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        InteractiveViewer(
                                  child: Image.file(
                                    File(attachment!),
                                    errorBuilder: (context, s, v) =>
                                        Image.asset('assets/images/logo.png'),
                                  ),
                                ),
                                barrierColor: Colors.black,
                                barrierDismissible: true,
                                barrierLabel: 'image preview',
                              );
                            },
                            child: Image.file(
                              File(attachment!),
                              errorBuilder: (context, s, v) =>
                                  Image.asset('assets/images/logo.png'),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Get.generalDialog(
                                transitionBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  Tween<Offset> tween;
                                  if (animation.status ==
                                      AnimationStatus.reverse) {
                                    tween = Tween(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero);
                                  } else {
                                    tween = Tween(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero);
                                  }

                                  return SlideTransition(
                                    position: tween.animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.fastEaseInToSlowEaseOut)),
                                    child: child,
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 600),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        InteractiveViewer(
                                  child: Image.network(
                                    "${Constants.baseUrl}storage/$attachment",
                                  ),
                                ),
                                barrierColor: Colors.black,
                                barrierDismissible: true,
                                barrierLabel: 'image preview',
                              );
                            },
                            child: "${Constants.baseUrl}storage/$attachment"
                                .image(isProfile: false),
                          ),
                  ),
                ),
              },
              const SizedBox(height: 3),
              UnconstrainedBox(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    convertUtcToLocal(createdAt),
                    style: TextStyle(
                      fontSize: 8,
                      color: (id != controller.appServices.userId.value
                          ? Colors.black87
                          : Colors.white70),
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
