import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/search_card.dart';
import 'package:wayaak_delivery/app/core/widgets/shimmers/chat_card_shimmer.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Chats'.tr),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),
              SearchCard(
                text: 'Search'.tr,
                icon: 'mic',
                hint: 'Search'.tr,
                onChanged: (val) {
                  if (val!.isEmpty) {
                    controller.chatsDatumList.value = controller.chatsList;
                  } else {
                    controller.chatsDatumList.value = controller.chatsList
                        .where((e) => e.receiver != null)
                        .toList()
                        .where(
                            (v) => v.receiver!.name!.camelCase!.contains(val))
                        .toList();
                  }
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: 'All messages'.tr.subtitle(),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.isChatsLoading.value) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => const ChatCardShimmer(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: 5,
                  );
                } else {
                  if (controller.chatsDatumList.isEmpty) {
                    return Center(child: 'No data found'.tr.body());
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: controller.chatsDatumList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          controller.socketServices.chatChannelName.value =
                              "private-chat.${controller.chatsDatumList[index].id}";
                          controller.socketServices.subscribe(
                              "private-chat.${controller.chatsDatumList[index].id}");
                          controller.getChatMessages(
                              controller.chatsDatumList[index].id!);
                          Get.toNamed(Routes.chatMessages, arguments: [
                            controller.chatsDatumList[index].receiver!.avatar,
                            controller.chatsDatumList[index].receiver!.name,
                            controller.chatsDatumList[index].receiver!.id,
                            controller.chatsDatumList[index].id,
                          ]);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Constants.softGrey,
                              radius: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox(
                                  height: 55,
                                  width: 55,
                                  child:
                                      "${Constants.baseUrl}storage/${controller.chatsDatumList[index].receiver!.avatar}"
                                          .profileImage,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  '${controller.chatsDatumList[index].receiver!.name}'
                                      .titleSmall(
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 4),
                                  '${controller.chatsDatumList[index].latestMessage!.message}'
                                      .caption(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // convertUtcToLocal(
                            //         controller.chatsDatumList[index].updatedAt!)
                            //     .caption(),
                          ],
                        ).decorate(padding: 15),
                      ),
                    );
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
