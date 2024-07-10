// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test_ta_1/config/constants.dart';
// import 'package:test_ta_1/controller/c_favorite.dart';
// import 'package:test_ta_1/controller/sessionProvider.dart';
// import 'package:test_ta_1/model/property.dart' as PropertyModel;
// import 'package:test_ta_1/page/detail_page.dart';
// import 'package:test_ta_1/widget/short_address.dart';

// class PropertyCard extends StatelessWidget {
//   final PropertyModel.Datum property;

//   const PropertyCard({Key? key, required this.property}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Color statusColor;
//     switch (property.status) {
//       case 'ready':
//         statusColor = Colors.green;
//         break;
//       case 'sold':
//         statusColor = Colors.red;
//         break;
//       case 'pending':
//         statusColor = Colors.grey;
//         break;
//       default:
//         statusColor = Colors.black;
//     }

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailPage(property: property),
//           ),
//         );
//       },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: AspectRatio(
//                       aspectRatio: 16 / 9,
//                       child: Image.network(
//                         '$baseUrll/storage/images_property/${property.images[0].image}',
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Center(child: Text('Image not available'));
//                         },
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 10,
//                     right: 10,
//                     child: FavoriteButton(property: property),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 5),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             property.name,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(fontWeight: FontWeight.bold),
//                             softWrap: true,
//                           ),
//                         ),
//                         Text(
//                           'Rp ${property.price}',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.map,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           shortenAddress(property.address),
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                           softWrap: true,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: statusColor,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Text(
//                           property.status,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       _buildFeatureText('${property.sqft} sqft'),
//                       _buildFeatureText('${property.bed} bed'),
//                       _buildFeatureText('${property.bath} bath'),
//                       _buildFeatureText('${property.garage} garage'),
//                       _buildFeatureText('${property.floor} floor'),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeatureText(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: text.split(' ')[0] + ' ',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             TextSpan(
//               text: text.split(' ')[1],
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FavoriteButton extends StatefulWidget {
//   final PropertyModel.Datum property;

//   const FavoriteButton({Key? key, required this.property}) : super(key: key);

//   @override
//   _FavoriteButtonState createState() => _FavoriteButtonState();
// }

// class _FavoriteButtonState extends State<FavoriteButton> {
//   late bool isFavorite;

//   @override
//   void initState() {
//     super.initState();
//     isFavorite = false;
//     loadFavoriteStatus();
//   }

//   Future<void> loadFavoriteStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isFavorite = prefs.getBool('favorite_${widget.property.id}') ?? false;
//     });
//   }

//   void _handleFavorite() async {
//     final sessionProvider =
//         Provider.of<SessionProvider>(context, listen: false);
//     final user = sessionProvider.user;

//     if (user == null) {
//       print('User is not logged in');
//       return;
//     }

//     final controller = FavoriteController();
//     try {
//       if (isFavorite) {
//         final favorites =
//             await controller.getFavorite(user.idUser ?? 0);
//         final favoriteToDelete = favorites.firstWhere(
//           (favorite) => favorite['id_properti'] == widget.property.id,
//           orElse: () => null,
//         );

//         if (favoriteToDelete != null) {
//           await controller.deleteFavorite(
//               favoriteToDelete['id_favorite']);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('Removed from favorites')),
//           );
//         } else {
//           print('Favorite not found');
//         }
//       } else {
//         await controller.postFavorite(
//           idPengguna: user.idUser ?? 0,
//           idProperti: widget.property.id,
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Added to favorites')),
//         );
//       }

//       // Save favorite status to shared preferences
//       SharedPreferences prefs =
//           await SharedPreferences.getInstance();
//       await prefs.setBool(
//           'favorite_${widget.property.id}', !isFavorite);

//       setState(() {
//         isFavorite = !isFavorite;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update favorite: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: _handleFavorite,
//       icon: Icon(
//         Icons.favorite,
//         size: 45,
//         color: isFavorite
//             ? Theme.of(context).primaryColor
//             : Colors.grey,
//       ),
//       iconSize: 30,
//     );
//   }
// }
