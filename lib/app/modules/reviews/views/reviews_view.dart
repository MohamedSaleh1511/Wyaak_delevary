import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
import 'package:wayaak_delivery/app/core/widgets/shimmers/all_reviews_card_shimmer.dart';
import 'package:wayaak_delivery/app/core/widgets/shimmers/review_card_shimmer.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
import 'package:wayaak_delivery/app/modules/reviews/widgets/all_reviews_card.dart';

import '../controllers/reviews_controller.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppbar(title: 'Reviews'.tr),
      body: Obx(() {
        if (controller.isReviewsLoading.value) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                children: [
                  const AllReviewsCardShimmer(),
                  const SizedBox(height: 15),
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    itemBuilder: (context, index) => const ReviewCardShimmer(),
                  ),
                ],
              ),
            ),
          );
        } else {
          if (controller.reviewsModel.value.data == null ||
              controller.reviewsModel.value.data!.reviews == null) {
            return Center(
                child:
                    "No Reviews Available for you".tr.bodyMedium(center: true));
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: Column(
                  children: [
                    AllReviewsCard(
                      totalReviews: double.parse(
                          controller.reviewsModel.value.data!.myTotalStars!),
                      reviewsCount:
                          controller.reviewsModel.value.data!.reviews!.length,
                      rate1Count:
                          controller.reviewsModel.value.data!.usersGive5Stars!,
                      rate2Count:
                          controller.reviewsModel.value.data!.usersGive4Stars!,
                      rate3Count:
                          controller.reviewsModel.value.data!.usersGive3Stars!,
                      rate4Count:
                          controller.reviewsModel.value.data!.usersGive2Stars!,
                      rate5Count:
                          controller.reviewsModel.value.data!.usersGive1Star!,
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => controller.reviewsModel
                                  .value.data!.reviews![index].comment ==
                              null
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipOval(
                                      child:
                                          "${Constants.baseUrl}storage/${controller.reviewsModel.value.data!.reviews![index].image}"
                                              .image(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  '${controller.reviewsModel.value.data!.reviews![index].user}'
                                                      .subtitle(),
                                                  RatingBarIndicator(
                                                    itemCount: 5,
                                                    rating: double.parse(
                                                        controller
                                                            .reviewsModel
                                                            .value
                                                            .data!
                                                            .reviews![index]
                                                            .rate!),
                                                    itemSize: 16,
                                                    unratedColor:
                                                        Constants.hintText,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            'star'.iconColored(
                                                      color: Get
                                                          .theme
                                                          .colorScheme
                                                          .secondary,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            DateFormat("dd/mm/yyyy")
                                                .format(controller
                                                    .reviewsModel
                                                    .value
                                                    .data!
                                                    .reviews![index]
                                                    .createdAt!)
                                                .caption(),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  end: 10),
                                          child:
                                              '${controller.reviewsModel.value.data!.reviews![index].comment}'
                                                  .bodyMedium(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      itemCount: controller.reviewsModel.value.data!.reviews!
                          .where((e) => e.comment != null)
                          .length,
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }),
    );
  }
}
