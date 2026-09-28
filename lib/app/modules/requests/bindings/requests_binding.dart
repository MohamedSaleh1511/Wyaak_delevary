import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/requests/controllers/requests_controller.dart';
import 'package:wayaak_delivery/app/modules/requests/providers/requests_provider.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestsProviders>(() => RequestsProviders());
    Get.lazyPut<RequestsController>(() => RequestsController());
  }
}
