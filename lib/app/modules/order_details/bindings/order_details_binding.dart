import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:wayaak_delivery/app/modules/order_details/providers/order_details_provider.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsProvider>(() => OrderDetailsProvider());
    Get.lazyPut<OrderDetailsController>(() => OrderDetailsController());
  }
}
