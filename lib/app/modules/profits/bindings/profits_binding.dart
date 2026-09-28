import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/profits/providers/profits_provider.dart';

import '../controllers/profits_controller.dart';

class ProfitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfitsProviders>(() => ProfitsProviders());
    Get.lazyPut<ProfitsController>(() => ProfitsController());
  }
}
