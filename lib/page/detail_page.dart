import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/config/constants.dart';
import 'package:test_ta_1/controller/c_favorite.dart';
import 'package:test_ta_1/controller/c_property.dart';
import 'package:test_ta_1/controller/sessionProvider.dart';
import 'package:test_ta_1/model/property.dart' as PropertyModel;

import 'package:test_ta_1/model/property.dart';
import 'package:test_ta_1/page/schedule_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailPage extends StatefulWidget {
  final PropertyModel.Datum property;

  const DetailPage({Key? key, required this.property}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late PropertyModel.Datum propertyData;
  bool isFavorite = false;
  List<Map<String, dynamic>> facilities = [];

  @override
  void initState() {
    super.initState();
    propertyData = widget.property;
    facilities = [
      {
        'icon': AppAsset.iconHome,
        'label': '${propertyData.sqft} sqft',
      },
      {
        'icon': AppAsset.iconGarage,
        'label': '${propertyData.garage} Garage',
      },
      {
        'icon': AppAsset.iconBed,
        'label': '${propertyData.bed} Bed',
      },
      {
        'icon': AppAsset.iconBath,
        'label': '${propertyData.bath} Bath',
      },
      {
        'icon': AppAsset.iconFloor,
        'label': '${propertyData.floor} Floor',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Property Detail",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: buildBottomNavigationBar(propertyData, context),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            images(),
            const SizedBox(height: 16),
            statHarga(context),
            const SizedBox(height: 5),
            nameLok(context),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                propertyData.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Facilities',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            gridfacilities(),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Maps',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            maps(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Padding maps() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        height: 250,
        child: MapContentDetail(
          markerId: propertyData.id,
          latitude: propertyData.latitude,
          longitude: propertyData.longitude,
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar(
      PropertyModel.Datum property, BuildContext context) {
    if (propertyData.status == 'pending' || propertyData.status == 'sold') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[100]!, width: 1.5),
          ),
        ),
        height: 80,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Center(
          child: Text(
            'The Property is Not Available',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[100]!, width: 1.5),
          ),
        ),
        height: 80,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: SizedBox(
          height: 50,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, 0.7),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.primary,
                        offset: Offset(0, 5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  width : double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Set Schedule',
                  ),
                ),
              ),
              Align(
                child: Material(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Schedule(property: propertyData),
                        ),
                      );
                    },
                    child: Container(
                      width : double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 12,
                      ),
                      child: Text(
                        'Set Schedule',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  GridView gridfacilities() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      itemCount: facilities.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 3,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 162, 162, 162)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(AssetImage(facilities[index]['icon'])),
              const SizedBox(height: 4),
              Text(
                facilities[index]['label'],
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  Padding statHarga(BuildContext context) {
    Color statusColor;
    switch (propertyData.status) {
      case 'ready':
        statusColor = Colors.green;
        break;
      case 'sold':
        statusColor = Colors.red;
        break;
      case 'pending':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    propertyData.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rp.${propertyData.price}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: FavoriteButton(property: propertyData),
          ),
        ],
      ),
    );
  }

  Padding nameLok(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Name
          Text(
            propertyData.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
              height: 3), // Spacing between property name and address
          // Address Row
          Text(
            propertyData.address,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ],
      ),
    );
  }

  SizedBox images() {
    
    return SizedBox(
      height: 180,
      child: propertyData.images.isNotEmpty
          ? ListView.builder(
              itemCount: propertyData.images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    index == 0 ? 16 : 8,
                    0,
                    index == propertyData.images.length - 1 ? 16 : 8,
                    0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // child: Image.network(
                    //   '$baseUrll/storage/images_property/${propertyData.images[index].image}',
                    //   fit: BoxFit.cover,
                    //   height: 180,
                    //   width: 240,
                    // ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'No images available',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final PropertyModel.Datum property;

  const FavoriteButton({Key? key, required this.property}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = false;
    loadFavoriteStatus();
  }

  Future<void> loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('favorite_${widget.property.id}') ?? false;
    });
  }

  void _handleFavorite() async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;

    if (user == null) {
      print('User is not logged in');
      return;
    }

    final controller = FavoriteController();
    try {
      if (isFavorite) {
        final favorites =
            await controller.getFavorite(user.idUser ?? 0);
        final favoriteToDelete = favorites.firstWhere(
          (favorite) => favorite['id_properti'] == widget.property.id,
          orElse: () => null,
        );

        if (favoriteToDelete != null) {
          await controller.deleteFavorite(
              favoriteToDelete['id_favorite']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Removed from favorites')),
          );
        } else {
          print('Favorite not found');
        }
      } else {
        await controller.postFavorite(
          idPengguna: user.idUser ?? 0,
          idProperti: widget.property.id,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }

      // Save favorite status to shared preferences
      SharedPreferences prefs =
          await SharedPreferences.getInstance();
      await prefs.setBool(
          'favorite_${widget.property.id}', !isFavorite);

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleFavorite,
      icon: Icon(
        Icons.favorite,
        size: 45,
        color: isFavorite
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
      iconSize: 30,
    );
  }
}

class MapContentDetail extends StatefulWidget {
  final int? markerId;
  final double? latitude;
  final double? longitude;

  const MapContentDetail({Key? key, this.markerId, this.latitude, this.longitude}) : super(key: key);

  @override
  _MapContentDetailState createState() => _MapContentDetailState();
}

class _MapContentDetailState extends State<MapContentDetail> {
  late Future<List<Datum>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final LatLng initialCenter = widget.latitude != null && widget.longitude != null
        ? LatLng(widget.latitude!, widget.longitude!)
        : const LatLng(-6.37426, 106.8337);

    return SizedBox(
      height: screenHeight,
      child: FutureBuilder<List<Datum>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Datum> properties = snapshot.data ?? [];
            return FlutterMap(
              options: MapOptions(
                // ignore: deprecated_member_use
                center: initialCenter,
                // ignore: deprecated_member_use
                zoom: 14,
                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: [
                    if (widget.markerId != null)
                      ...properties.where((property) => property.id == widget.markerId).map((property) {
                        return Marker(
                          width: 60,
                          height: 60,
                          point: LatLng(property.latitude, property.longitude),
                          child: const Icon(
                            Icons.location_pin,
                            size: 50,
                            color: AppColor.primary, // Customize marker color here
                          ),
                        );
                      })
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
