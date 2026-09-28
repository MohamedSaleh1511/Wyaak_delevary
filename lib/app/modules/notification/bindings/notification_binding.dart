import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/notification/providers/notifications_providers.dart';

import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<NotificationsProviders>(() => NotificationsProviders());
  }
}
