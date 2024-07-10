// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:test_ta_1/config/app_color.dart';

// import 'package:test_ta_1/controller/c_home.dart';
// import 'package:test_ta_1/page/home_page.dart';

// class PropertyAlert extends StatelessWidget {
//   final CHome cHome;
//   final String iconAsset;
//   final String noPropertyText;
//   final String findPropertyText;

//   const PropertyAlert({
//     Key? key,
//     required this.cHome,
//     required this.iconAsset,
//     required this.noPropertyText,
//     required this.findPropertyText,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         ClipRRect(
//           child: Image.asset(
//             iconAsset,
//             fit: BoxFit.cover,
//           ),
//         ),
//         const SizedBox(height: 46),
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: Align(
//             alignment: Alignment.center,
//             child: Text(
//               noPropertyText,
//               textAlign: TextAlign.center,
//               style: Theme.of(context)
//                   .textTheme
//                   .headlineMedium!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           findPropertyText,
//           textAlign: TextAlign.center,
//           style: Theme.of(context)
//               .textTheme
//               .bodyLarge!
//               .copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 30),
//         SizedBox(
//           height: 50,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: const Alignment(0, 0.7),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: AppColor.primary,
//                         offset: Offset(0, 5),
//                         blurRadius: 20,
//                       ),
//                     ],
//                   ),
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Text(
//                     'View My Maps',
//                   ),
//                 ),
//               ),
//               Align(
//                 child: Material(
//                   color: AppColor.primary,
//                   borderRadius: BorderRadius.circular(20),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(20),
//                     onTap: () {
//                       cHome.indexPage = 0;
//                       Get.offAll(() => HomePage());
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 36,
//                         vertical: 12,
//                       ),
//                       child: Text(
//                         'View My Maps',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
