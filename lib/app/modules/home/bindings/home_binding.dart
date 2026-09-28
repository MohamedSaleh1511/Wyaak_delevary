import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/home/providers/home_providers.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeProviders>(() => HomeProviders());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
