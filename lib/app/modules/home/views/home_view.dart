import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/custom_tabbar.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/global_drawer.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/goodealz_requests_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/google_map_part.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/home_appbar.dart';
import 'package:wayaak_delivery/app/modules/home/widgets/wayaak_requests_part.dart';
import 'package:wayaak_delivery/app/routes/app_routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late bool notifiableVal;
  final HomeController controller = Get.find<HomeController>();
  final AppServices appServices = Get.find<AppServices>();

  @override
  void initState() {
    super.initState();
    notifiableVal = appServices.userNotifiable.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      extendBody: true,
      drawer: const GlobalDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight + 5),
        child: HomeAppbar(
          scaffoldKey: controller.scaffoldKey,
          onSwitchChanged: (val) async {
            setState(() {
              notifiableVal = val;
            });
            controller.switchNotification(val);
            if (val) {
              await controller.requestsController.getWayaakRequests();
              await controller.requestsController.getGoodeelzRequests();
            }
          },
          switchValue: notifiableVal,
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            const AspectRatio(
              aspectRatio: 9 / 13,
              child: GoogleMapPart(),
            ),
            DraggableScrollableSheet(
              shouldCloseOnMinExtent: false,
              minChildSize: 0.4,
              maxChildSize: 1.0,
              initialChildSize: 0.4,
              snap: true,
              builder: (context, scrollController) => NestedScrollView(
                // controller: scrollController,
                physics: const NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, isScrolled) {
                  return [
                    const SliverPadding(padding: EdgeInsets.all(4)),
                    SliverPersistentHeader(
                      delegate: CustomDelegate(
                        Obx(() {
                          return SocialTabbar(
                            condition: (controller.requestType.value ==
                                RequestType.wayaak),
                            tabsCallback: [
                              () {
                                controller.requestType.value =
                                    RequestType.wayaak;
                                controller.homePageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              () {
                                controller.requestType.value =
                                    RequestType.goodealz;
                                controller.homePageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ],
                          );
                        }),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: controller.homePageController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              'New Requests'.tr.subtitle(),
                              InkWell(
                                onTap: () => Get.toNamed(Routes.newRequests,
                                    arguments: 0),
                                child: 'View All'
                                    .tr
                                    .caption(color: Get.theme.primaryColor),
                              ),
                            ],
                          ),
                          Expanded(
                            child: WayaakRequestsPart(
                              scrollController: scrollController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              'New Requests'.tr.subtitle(),
                              InkWell(
                                onTap: () => Get.toNamed(Routes.newRequests,
                                    arguments: 1),
                                child: 'View All'
                                    .tr
                                    .caption(color: Get.theme.primaryColor),
                              ),
                            ],
                          ),
                          Expanded(
                            child: GoodealzRequestsPart(
                              scrollController: scrollController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // itemCount: 2,
                  onPageChanged: (val) {
                    if (val == 0) {
                      controller.requestType.value = RequestType.wayaak;
                    } else {
                      controller.requestType.value = RequestType.goodealz;
                    }
                  },
                ),
              ).decorate(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  CustomDelegate(this.tabBar);
  final Widget tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabBar;
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
