import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/helpers/helpers.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/user.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class UserDataPart extends GetView<OrderDetailsController> {
  final WayaakUser user;
  const UserDataPart({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: '${Constants.baseUrl}storage/${user.avatar ?? ''}'.image(),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '${user.name}'.subtitle(),
              const SizedBox(height: 3),
              '${user.phone}'.bodyMedium(),
            ],
          ),
          const Spacer(),
          IconButton.filled(
            onPressed: () {
              launch(Uri(scheme: 'tel', path: user.phone));
            },
            icon: 'phone'.iconColored(color: Colors.white),
          ),
          const SizedBox(width: 3),
          IconButton.filled(
            onPressed: () {
              controller.getChatMessages(user.id!).then((val) {
                controller.socketServices.chatChannelName.value =
                    "private-chat.${controller.chatId.value}";
                controller.socketServices
                    .subscribe("private-chat.${controller.chatId.value}");
              });

              Get.toNamed(
                Routes.chatMessages,
                arguments: [
                  user.avatar ?? '',
                  user.name!,
                  user.id!,
                  controller.chatId.value,
                ],
              );
            },
            icon: 'message-text'.iconColored(color: Colors.white),
          ),
        ],
      ).decorate(padding: 12),
    );
  }
}
