import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/orders_history/controllers/orders_history_controller.dart';
import 'package:wayaak_delivery/app/modules/orders_history/providers/orders_history_provider.dart';

class OrdersHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersHistoryProvider>(() => OrdersHistoryProvider());
    Get.lazyPut<OrdersHistoryController>(() => OrdersHistoryController());
  }
}
