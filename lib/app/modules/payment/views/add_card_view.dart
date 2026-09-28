// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wayaak_delivery/app/core/widgets/global_appbar.dart';
// import 'package:wayaak_delivery/app/core/widgets/global_button.dart';
// import 'package:wayaak_delivery/app/core/widgets/global_textfield.dart';
// import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

// class AddCardView extends StatelessWidget {
//   const AddCardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const GlobalAppbar(title: 'Add New Card'),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         physics: const BouncingScrollPhysics(),
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 15),
//               const GlobalTextField(
//                 hintText: 'Full Name',
//                 prefixIcon: 'person',
//                 inputType: TextInputType.name,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 8),
//               const GlobalTextField(
//                 hintText: 'Street address',
//                 prefixIcon: 'location',
//                 inputType: TextInputType.name,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 8),
//               const GlobalTextField(
//                 hintText: 'State',
//                 prefixIcon: 'location',
//                 inputType: TextInputType.name,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 8),
//               const GlobalTextField(
//                 hintText: 'City',
//                 prefixIcon: 'location',
//                 inputType: TextInputType.name,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 8),
//               const GlobalTextField(
//                 hintText: 'Postal Code',
//                 prefixIcon: 'location',
//                 inputType: TextInputType.name,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: 8),
//               SwitchListTile.adaptive(
//                 value: true,
//                 onChanged: (val) {},
//                 title: 'Set As Default'.tr.body(color: Colors.black),
//                 controlAffinity: ListTileControlAffinity.leading,
//               ),
//               const SizedBox(height: 50),
//               GlobalButton(
//                 onTap: () {
//                   Get.generalDialog(
//                     transitionDuration: const Duration(milliseconds: 700),
//                     transitionBuilder:
//                         (context, animation, secondaryAnimation, child) =>
//                             child.dialogTransition(animation),
//                     pageBuilder: (context, animation, secondaryAnimation) =>
//                         UnconstrainedBox(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const SizedBox(height: 30),
//                           'successfully'.iconColored(size: Get.width * 0.7),
//                           const SizedBox(height: 15),
//                           'Payment successfully'
//                               .tr
//                               .subtitle(color: Colors.black),
//                           const SizedBox(height: 15),
//                           GlobalButton(
//                             onTap: () {
//                               Get.back();
//                               Get.back();
//                             },
//                             text: 'Continue'.tr,
//                             width: Get.width * 0.75,
//                           ),
//                           const SizedBox(height: 30),
//                         ],
//                       ).decorate(width: Get.width * 0.9),
//                     ),
//                   );
//                 },
//                 text: 'Save',
//                 width: double.infinity,
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Get.theme.primaryColor),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: GlobalButton(
//                   onTap: () => Get.back(),
//                   text: 'Cancel'.tr,
//                   width: double.infinity,
//                   textColor: Get.theme.primaryColor,
//                   color: Colors.transparent,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
