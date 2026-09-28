import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/notifications_model/notification.dart';
import 'package:wayaak_delivery/app/data/models/notifications_model/notifications_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/data/services/socket_service.dart';
import 'package:wayaak_delivery/app/modules/home/controllers/home_controller.dart';
import 'package:wayaak_delivery/app/modules/notification/providers/notifications_providers.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:wayaak_delivery/app/modules/support/controllers/support_controller.dart';

class NotificationController extends GetxController {
  final NotificationsProviders provider = Get.find<NotificationsProviders>();
  final AppServices appServices = Get.find<AppServices>();
  final SocketServices socketServices = Get.find<SocketServices>();
  final OrderDetailsController orderDetailsController =
      Get.find<OrderDetailsController>();
  final HomeController homeController = Get.find<HomeController>();
  final SupportController supportController = Get.find<SupportController>();

  RxBool isNotificationsLoading = false.obs;
  RxList<NotificationData> notificationsList = <NotificationData>[].obs;
  getNotifications() async {
    isNotificationsLoading.value = true;
    Map<String, dynamic>? data = await provider.getNotifications();
    isNotificationsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          notificationsList.value =
              (data['data'] as NotificationsModel).data!.notifications!;
        } else {
          GlobalResponseModel model = (data['data'] as GlobalResponseModel);
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'error occured');
    }
  }

  clearNotifications() async {
    Ui.loadingDialog();
    Map<String, dynamic>? data = await provider.clearNotifications();
    Get.back();
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          notificationsList.value = [];
        } else {
          GlobalResponseModel model = (data['data'] as GlobalResponseModel);
          Ui.errorGetBar(message: model.message!);
        }
      }
    } else {
      Ui.errorGetBar(message: 'Internal Server Error'.tr);
    }
  }

  @override
  void onReady() {
    super.onReady();
    getNotifications();
  }
}
