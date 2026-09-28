import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final void Function(bool)? onSwitchChanged;
  final bool? switchValue;
  final String? userName;
  const HomeAppbar({
    super.key,
    this.scaffoldKey,
    this.onSwitchChanged,
    this.switchValue,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: scaffoldKey == null
          ? const SizedBox()
          : IconButton(
              onPressed: () => scaffoldKey!.currentState!.openDrawer(),
              icon: 'menu'.iconColored(color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
      centerTitle: true,
      title: scaffoldKey == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                'Good Morning'.tr.caption(color: Colors.black54),
                userName!.subtitle(
                  color: Colors.black,
                  weight: FontWeight.w600,
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                scaffoldKey == null
                    ? const SizedBox()
                    : Switch(
                        value: switchValue!,
                        onChanged: onSwitchChanged,
                        trackOutlineColor: const WidgetStatePropertyAll<Color>(
                            Colors.transparent),
                        activeColor: Constants.green,
                        inactiveTrackColor: Constants.grey.withOpacity(0.4),
                        inactiveThumbColor: Constants.accent,
                      ),
                const SizedBox(width: 5),
                scaffoldKey == null
                    ? const SizedBox()
                    : (switchValue! ? 'Online'.tr : "Offline".tr)
                        .caption(color: Colors.black),
              ],
            ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(Routes.notification),
          icon: 'notification'.iconColored(color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight + 5);
}
