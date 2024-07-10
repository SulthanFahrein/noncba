// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test_ta_1/config/app_color.dart';
// import 'package:test_ta_1/config/constants.dart';
// import 'package:test_ta_1/controller/c_favorite.dart';
// import 'package:test_ta_1/controller/c_property.dart';
// import 'package:test_ta_1/controller/sessionProvider.dart';
// import 'package:test_ta_1/model/property.dart' as PropertyModel;
// import 'package:test_ta_1/page/detail_page.dart';
// import 'package:test_ta_1/widget/short_address.dart';

// class MapContent extends StatefulWidget {
//   int? markerId;
//   late double latitude;
//   late double longitude;

//   MapContent({Key? key, this.markerId, this.latitude = -6.37426, this.longitude = 106.8337}) : super(key: key);

//   @override
//   _MapContentState createState() => _MapContentState();
// }

// class _MapContentState extends State<MapContent> {
//   late Future<List<PropertyModel.Datum>> _propertiesFuture;
//   PropertyModel.Datum? _selectedProperty;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _propertiesFuture = fetchProperties();
//   }

//   void _selectNextProperty(List<PropertyModel.Datum> properties) {
//     setState(() {
//       _selectedIndex = (_selectedIndex + 1) % properties.length;
//       _selectedProperty = properties[_selectedIndex];
//       _updateMapPosition(_selectedProperty!.latitude, _selectedProperty!.longitude);
//     });
//   }

//   void _selectPreviousProperty(List<PropertyModel.Datum> properties) {
//     setState(() {
//       _selectedIndex = (_selectedIndex - 1 + properties.length) % properties.length;
//       _selectedProperty = properties[_selectedIndex];
//       _updateMapPosition(_selectedProperty!.latitude, _selectedProperty!.longitude);
//     });
//   }

//   void _updateMapPosition(double latitude, double longitude) {
//     setState(() {
//       widget.latitude = latitude;
//       widget.longitude = longitude;
//     });
//   }

//   void _closePropertyCard() {
//     setState(() {
//       _selectedProperty = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final LatLng initialCenter = LatLng(widget.latitude, widget.longitude);
//     return GestureDetector(
//       onTap: () {
//         if (_selectedProperty != null) {
//           _closePropertyCard();
//         }
//       },
//       child: SizedBox(
//         height: screenHeight,
//         child: FutureBuilder<List<PropertyModel.Datum>>(
//           future: _propertiesFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               final List<PropertyModel.Datum> properties = snapshot.data ?? [];
//               return Stack(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       if (_selectedProperty != null) {
//                         _closePropertyCard();
//                       }
//                     },
//                     child: FlutterMap(
//                       options: MapOptions(
//                         center: initialCenter,
//                         zoom: 11,
//                         interactionOptions: const InteractionOptions(
//                           flags: ~InteractiveFlag.doubleTapZoom,
//                         ),
//                       ),
//                       children: [
//                         TileLayer(
//                           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                           userAgentPackageName: 'dev.fleaflet.flutter_map.example',
//                         ),
//                         MarkerLayer(
//                           markers: [
//                             if (widget.markerId != null)
//                               Marker(
//                                 width: 60,
//                                 height: 60,
//                                 point: LatLng(widget.latitude, widget.longitude),
//                                 child: const Icon(
//                                   Icons.location_pin,
//                                   size: 50,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ...properties.asMap().entries.map((entry) {
//                               final int index = entry.key;
//                               final PropertyModel.Datum property = entry.value;
//                               return Marker(
//                                 width: _selectedProperty != null && _selectedProperty!.id == property.id ? 80 : 60,
//                                 height: _selectedProperty != null && _selectedProperty!.id == property.id ? 80 : 60,
//                                 point: LatLng(property.latitude, property.longitude),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectedProperty = property;
//                                       _selectedIndex = index;
//                                     });
//                                   },
//                                   child: Icon(
//                                     Icons.location_pin,
//                                     size: _selectedProperty != null && _selectedProperty!.id == property.id ? 70 : 50,
//                                     color: AppColor.primary,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (_selectedProperty != null)
//                     AnimatedPositioned(
//                       duration: const Duration(milliseconds: 300),
//                       left: 0,
//                       right: 0,
//                       bottom: screenHeight * 0.21, // Adjust based on screen height
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: GestureDetector(
//                           onHorizontalDragEnd: (details) {
//                             if (details.velocity.pixelsPerSecond.dx > 0) {
//                               _selectPreviousProperty(properties);
//                             } else if (details.velocity.pixelsPerSecond.dx < 0) {
//                               _selectNextProperty(properties);
//                             }
//                           },
//                           child: Dismissible(
//                             key: ValueKey(_selectedProperty!.id),
//                             direction: DismissDirection.down,
//                             onDismissed: (direction) {
//                               _closePropertyCard();
//                             },
//                             child: PropertyCard(property: _selectedProperty!),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

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
// String shortenAddress(String fullAddress) {
//   if (fullAddress.contains('Jakarta Selatan')) {
//     return 'Jakarta Selatan, Jakarta';
//   } else if (fullAddress.contains('Jakarta Barat')) {
//     return 'Jakarta Barat, Jakarta';
//   } else if (fullAddress.contains('Jakarta Timur')) {
//     return 'Jakarta Timur, Jakarta';
//   } else if (fullAddress.contains('Jakarta Utara')) {
//     return 'Jakarta Utara, Jakarta';
//   }
//   else {
//     return 'Jakarta';
//   }
// }
