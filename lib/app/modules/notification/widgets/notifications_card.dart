import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/notifications_model/notification.dart';

class NotificationsCard extends StatelessWidget {
  final NotificationData notification;
  const NotificationsCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.3),
          child: 'order'.iconColored(),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '${Get.locale == const Locale('ar') ? notification.message!.ar : notification.message!.en}'
                  .bodyMedium(weight: FontWeight.w500, color: Colors.black),
            ],
          ),
        ),
        const SizedBox(width: 6),
        (Get.locale == const Locale('en'))
            ? 'arrow-right'.iconColored(color: Constants.grey)
            : Transform.flip(
                flipX: true,
                child: 'arrow-right'.iconColored(color: Constants.grey),
              ),
      ],
    ).decorate(padding: 16);
  }
}
