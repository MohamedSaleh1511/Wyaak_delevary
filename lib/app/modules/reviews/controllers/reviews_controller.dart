import 'package:get/get.dart';
import 'package:wayaak_delivery/app/core/theme/theme.dart';
import 'package:wayaak_delivery/app/data/models/reviews_model/reviews_model.dart';
import 'package:wayaak_delivery/app/data/services/app_services.dart';
import 'package:wayaak_delivery/app/modules/reviews/providers/reviews_provider.dart';

class ReviewsController extends GetxController {
  final AppServices appServices = Get.find<AppServices>();
  final ReviewsProviders provider = Get.find<ReviewsProviders>();

  RxBool isReviewsLoading = false.obs;
  Rx<ReviewsModel> reviewsModel = ReviewsModel().obs;
  getReviews() async {
    isReviewsLoading.value = true;
    Map<String, dynamic>? data = await provider.getReviews();
    isReviewsLoading.value = false;
    if (data != null) {
      if (data.containsKey('error')) {
        Ui.errorGetBar(
            message: 'Connection Error, Check your network please'.tr);
      } else {
        if (data['code'] == 200) {
          reviewsModel.value = data['data'] as ReviewsModel;
          if (reviewsModel.value.data == null) {
            Ui.errorGetBar(message: reviewsModel.value.message!);
          }
        }
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    getReviews();
  }
}
