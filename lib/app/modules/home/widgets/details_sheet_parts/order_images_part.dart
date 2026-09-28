import 'package:flutter/material.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class OrderImagesPart extends StatelessWidget {
  final int imagesLength;
  final List<String> images;

  const OrderImagesPart({
    super.key,
    required this.images,
    required this.imagesLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.grey),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: AspectRatio(
          aspectRatio: 16 / 8,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: "${Constants.baseUrl}storage/${images[index]}"
                  .image(isProfile: false),
            ).decorate(padding: 8),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: imagesLength,
          ),
        ),
      ),
    );
  }
}
