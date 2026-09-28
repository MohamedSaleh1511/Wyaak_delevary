import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/global_response_model.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/wallet_model/wallet_model.dart';
import 'package:wayaak_delivery/app/data/models/withdraw_model/withdraw_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class ProfitsProviders extends ApiProvider {
  // NOTE :- Post Update Profile
  Future<Map<String, dynamic>?> getWallet() async {
    Response res = await get('driver/wallet', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode != 200)
            ? GlobalResponseModel.fromJson(res.body)
            : WalletModel.fromJson(res.body),
      };
    }
  }

  // NOTE :- Post Change Language
  Future<Map<String, dynamic>?> postWithdraw(
      String? amount, String? subject) async {
    Response res = await post('driver/withdraw', {
      'subject': subject,
      'amount': amount,
    }, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AppServices>().accessToken.value}',
    });
    if (res.status.isServerError) {
      return null;
    } else if (res.status.connectionError) {
      return {'error': true};
    } else {
      Get.log(res.statusCode.toString());
      return {
        'code': res.statusCode!,
        'data': (res.statusCode != 200)
            ? NoDataResponseModel.fromJson(res.body)
            : WithdrawModel.fromJson(res.body),
      };
    }
  }
}
