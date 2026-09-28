import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/support/providers/support_providers.dart';

import '../controllers/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(() => SupportController());
    Get.lazyPut<SupportProviders>(() => SupportProviders());
  }
}
