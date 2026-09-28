import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class WelcomeController extends GetxController {
  final AppServices appServices = AppServices();

  RxBool localeEn = true.obs;
}
