import 'dart:convert';
import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/enums/enums.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/chat_messages_model/message.dart';
import 'package:wayaak_delivery/app/data/models/chat_messages_model/messages.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/goodealz_requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/models/requests_model/datum.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketServices extends ApiProvider {
  WebSocketChannel? channel;
  RxString socketId = ''.obs;
  RxString broadcastAuth = ''.obs;
  RxString chatChannelName = ''.obs;
  RxList<Messages> messages = <Messages>[].obs;
  RxList<RequestsDatum> wayaakRequests = <RequestsDatum>[].obs;
  RxList<GoodealzDatum> godeelzRequests = <GoodealzDatum>[].obs;

  RxBool isChatsMessagesLoading = false.obs;

  RxDouble driverLatitude = 0.0.obs;
  RxDouble driverLongitude = 0.0.obs;

  /*
  
  {
    "event": "new-order",
    "data": "{
      "type":"local",
      "order":{
        "id":630,
        "vehicle_category":{
          "id":1,
          "name":"\\u0633\\u064a\\u0627\\u0631\\u0627\\u062a\",
          "image":"vehicle_categories\\/1BW0Xi0vKp8C8jGeOpWVTTn2kVRMWPPDaMKeSL3B.png"
        },
        "order_num":"2505217739",
        "title":"Last Order99",
        "description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        "discount_amount":0,
        "discounted_price":0,
        "shipping_cost":0,
        "total_price":0,
        "order_status":"Pending",
        "urgent":"No",
        "user":{
          "id":21,
          "name":"Wayak Test User",
          "email":"wayak_user@gmail.com",
          "phone":"+201234567891",
          "gender":"female",
          "birth_date":"2001-01-01",
          "language":"en",
          "avatar":"users\\/ww2kWBoBHlS4SWA75DeAiVDDN4RgeEKfQCEyyh0J.png\",
          "fcm_token":"eiscFmFvT8SZCiZrpSbx-Z:APA91bHnDS_vPGShwNeQ0KCJlFT4xPhcQocF4PYO-QguPjxrnUA6EN1dQehl-X3bnWevLNyKtpr8vELjAzPlbFJg1Qnz0sxxSnGstQKoRxJSzlvI2LbjbeQ",
          "type":"User",
          "store_data":null
        },
        "driver":null,
        "product_images":[
          {
            "id":678,
            "image":"orders\\\/zKSrjUiqRys4N96qEEwL8wTuUiKWHLEwSNPkV9y8.png"
          }
        ],
        "country":"Egypt",
        "current_location":{
          "id":18,
          "title":"14 st warshet elnegara",
          "latitude":"30.1434",
          "longitude":"31.2827"
        },
        "destination_location":{
          "id":17,
          "title":"9 salama afify street elzawya elhamra cairo",
          "latitude":"30.078106067012893",
          "longitude":"31.277270503342148"
        },
        "payment_method":"Cash",
        "payment_status":0,
        "created_at":"2025-05-21T11:25:48.000000Z",
        "updated_at":"2025-05-21T11:25:48.000000Z"
      }
    }",
    "channel": "private-new-order.34"
}
  
   */

  requestSocketConnection(int userId) async {
    final wsUrl = Uri.parse(
        'wss://wyaak.com/ws/app/on3fzocg9ie7o3qoa1ug?protocol=7&client=js&version=4.3.1&flash=false');
    channel = WebSocketChannel.connect(wsUrl);

    await channel!.ready;
    channel!.stream.listen((message) {
      Get.log("message :: $message");
      Map<String, dynamic> outerJson = jsonDecode(message);
      String dataJsonString =
          outerJson.containsKey('data') ? outerJson['data'] : "";
      Map<String, dynamic> nestedJson = dataJsonString.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(dataJsonString);
      switch (outerJson['event']) {
        case 'pusher:connection_established':
          String id = nestedJson['socket_id'];
          socketId.value = id;
          Get.log('Socket ID: $socketId');
          break;
        case 'new-message':
          if (outerJson['channel'] == chatChannelName.value) {
            Get.log('new message: $nestedJson');
            ChatMessage bew = ChatMessage.fromJson(nestedJson['message']);
            if (bew.sender!.id! != userId) {
              messages.add(
                Messages(
                  status: MesssageStatus.sent,
                  isAttachmentPath: false,
                  message: bew,
                ),
              );
            }
          }
          break;
        case 'new-order':
          Get.log('new order came: $nestedJson');
          if (nestedJson['type'] == 'local') {
            wayaakRequests.insert(
                0, RequestsDatum.fromJson(nestedJson['order']));
          } else {
            godeelzRequests.insert(
                0, GoodealzDatum.fromJson(nestedJson['order']));
          }
          break;
        case "pusher:ping":
          Get.log('message :: Pusher Ping');
          channel!.sink.add(jsonEncode({"event": "pusher:pong"}));
          break;
        default:
      }
    }, onDone: () {
      requestSocketConnection(userId);
    }, onError: (error) {
      requestSocketConnection(userId);
    });
  }

  // NOTE :- CHECK BROADCAST AUTH
  Future<Map<String, dynamic>?> getCheckBroadcastAuth(
      {required String socketId, required String channelName}) async {
    Response res = await post('driver/broadcasting/auth', {
      "socket_id": socketId,
      "channel_name": channelName,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${Get.put<AppServices>(AppServices()).accessToken.value}',
    });
    if (res.status.isServerError || res.status.connectionError) {
      return null;
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': res.body,
      };
    }
  }

  RxBool broadcastAuthLoading = false.obs;
  subscribe(String channelName) async {
    broadcastAuthLoading.value = true;
    Map<String, dynamic>? data = await getCheckBroadcastAuth(
        socketId: socketId.value, channelName: channelName);
    broadcastAuthLoading.value = false;
    if (data != null) {
      if (data['code'] == 200) {
        Get.log(data['data']['auth']);
        channel!.sink.add(jsonEncode({
          "event": "pusher:subscribe",
          "data": {
            "channel": channelName,
            "auth": data['data']['auth'],
          }
        }));
      } else if (data['code'] == 403) {
        Ui.errorGetBar(message: (data['data'] as GlobalResponseModel).message!);
      } else {
        Ui.errorGetBar(message: 'error occured for broadcast');
      }
    } else {
      Get.log('Internal Server Error'.tr);
    }
  }

  unsubscribeChannel(String channelName) async {
    channel!.sink.add(jsonEncode({
      "event": "pusher:unsubscribe",
      "data": {"channel": channelName}
    }));
  }
}
