import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialTabbar extends StatelessWidget {
  final bool condition;
  final List<VoidCallback>? tabsCallback;
  const SocialTabbar({super.key, this.tabsCallback, required this.condition});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            width: Get.width,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Colors.white,
            ),
            child: AnimatedAlign(
              curve: Curves.easeInOut,
              alignment: condition
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: context.width * 0.5 - 25,
                height: 60,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: tabsCallback![0],
                child: AnimatedDefaultTextStyle(
                  curve: Curves.easeOutBack,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: condition ? FontWeight.bold : FontWeight.normal,
                    color: condition ? Colors.white : Colors.grey.shade500,
                    fontFamily: (Get.locale == const Locale('ar'))
                        ? 'Almarai'
                        : 'Poppin',
                  ),
                  duration: const Duration(milliseconds: 500),
                  child: Text('Wayaak Requests'.tr),
                ),
              ),
              TextButton(
                onPressed: tabsCallback![1],
                child: AnimatedDefaultTextStyle(
                  curve: Curves.easeOutBack,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: (Get.locale == const Locale('ar'))
                        ? 'Almarai'
                        : 'Poppin',
                    fontWeight: condition ? FontWeight.normal : FontWeight.bold,
                    color: condition ? Colors.grey.shade500 : Colors.white,
                  ),
                  duration: const Duration(milliseconds: 500),
                  child: Text('Goodealz Requests'.tr),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
