// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
// import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
// import 'package:wayaak_delivery/app/data/constants/constants.dart';
// import 'package:wayaak_delivery/app/data/extensions/extensions.dart';
// import 'package:wayaak_delivery/app/routes/app_routes.dart';
// import '../controllers/payment_controller.dart';

// class PaymentView extends GetView<PaymentController> {
//   const PaymentView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const GlobalAppbar(title: 'Withdraw'),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Center(
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 15),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Constants.grey),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 width: Get.width,
//                 padding: const EdgeInsets.all(30),
//                 child: Column(
//                   children: [
//                     '12/Oct-30 Nov'.bodyMedium(color: Colors.black),
//                     const SizedBox(height: 20),
//                     '15.000 LE'.displaySmall,
//                     const SizedBox(height: 20),
//                     '52 weekly Request'.bodyMedium(),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               'Choose your Credit Card'.subtitle(),
//               const SizedBox(height: 10),
//               AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: PageView.builder(
//                   itemCount: 3,
//                   allowImplicitScrolling: true,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.asset('assets/images/Credit Card.png'),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               UnconstrainedBox(
//                 child: GlobalButton(
//                   onTap: () => Get.toNamed(Routes.addNewCard),
//                   text: 'Add',
//                   icon: 'Plus',
//                   textColor: Get.theme.primaryColor,
//                   color: Colors.transparent,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const SizedBox(height: 35),
//               GlobalButton(
//                 onTap: () {},
//                 text: 'Withdraw',
//                 width: Get.width * 0.95,
//                 height: 55,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
