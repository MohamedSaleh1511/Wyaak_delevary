import 'package:get/get.dart';
import 'package:wayaak_delivery/app/data/models/no_data_response_model.dart';
import 'package:wayaak_delivery/app/data/models/reviews_model/reviews_model.dart';
import 'package:wayaak_delivery/app/data/providers/api_provider.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';

class ReviewsProviders extends ApiProvider {
  // NOTE :- Get Profile
  Future<Map<String, dynamic>?> getReviews() async {
    Response res = await get('driver/reviews', headers: {
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
            : ReviewsModel.fromJson(res.body),
      };
    }
  }
}
