import 'package:get/get.dart';
import 'package:wayaak_delivery/app/modules/chat/providers/chat_providers.dart';

import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatProvider>(() => ChatProvider());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
