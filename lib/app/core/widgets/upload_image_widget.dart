import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class UploadImageWidget extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onContainerTap;
  const UploadImageWidget({
    super.key,
    required this.onTap,
    required this.onContainerTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onContainerTap,
      child: Column(
        children: [
          'upload'.iconColored(color: Get.theme.primaryColor, size: 50),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Drop your image here, or'.tr,
                  style: Get.textTheme.bodyMedium!.merge(
                    TextStyle(
                      color: Colors.black,
                      fontFamily: (Get.locale == const Locale('ar'))
                          ? 'Tajawal'
                          : 'Poppin',
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextSpan(
                  text: 'browse'.tr,
                  style: Get.textTheme.bodyMedium!.merge(
                    TextStyle(
                      color: Get.theme.primaryColor,
                      fontFamily: (Get.locale == const Locale('ar'))
                          ? 'Tajawal'
                          : 'Poppin',
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          'JPG, PNG (Max 800x400px - 2Mo)'.bodyMedium(),
          const SizedBox(height: 12),
          UnconstrainedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1.5, color: Get.theme.primaryColor),
              ),
              child: GlobalButton(
                onTap: onTap,
                text: 'Add Photo'.tr,
                icon: 'video',
                textColor: Get.theme.primaryColor,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ).decorate(padding: 20, radius: 20),
    );
  }
}
