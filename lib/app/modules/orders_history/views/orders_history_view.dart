import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/orders_history/controllers/orders_history_controller.dart';
import 'package:wayaak_delivery/app/modules/orders_history/widgets/goodealz_orders_part.dart';
import 'package:wayaak_delivery/app/modules/orders_history/widgets/wayaak_orders_part.dart';

class OrdersHistoryView extends GetView<OrdersHistoryController> {
  const OrdersHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: 'Orders History'.tr.titleSmall(color: Colors.black),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Get.locale == const Locale('en')
                ? 'Arrow Back'.iconColored()
                : Transform.rotate(
                    angle: pi,
                    child: 'Arrow Back'.iconColored(),
                  ),
          ),
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: false,
            dividerHeight: 0.0,
            labelStyle: Get.textTheme.bodyMedium!.merge(
              TextStyle(
                color: Get.theme.primaryColor,
                fontFamily:
                    (Get.locale == const Locale('en')) ? 'Poppin' : 'Almarai',
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            unselectedLabelStyle: Get.textTheme.bodyMedium!.merge(
              TextStyle(
                color: Constants.grey,
                fontFamily:
                    (Get.locale == const Locale('ar')) ? 'Almarai' : 'Poppin',
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            tabs: [
              Tab(text: 'Wayaak Orders'.tr),
              Tab(text: 'Goodealz Orders'.tr),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 5),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: WayaakOrdersPart(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: GoodealzOrdersPart(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
