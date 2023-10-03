import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.151897153481993, 7.656152925560576),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      target: LatLng(11.154893502232717, 7.6511509936398205),
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final RxSet<Marker> _makers = Set<Marker>.from({}).obs;

  @override
  void initState() {
    loadMakers();
    super.initState();
  }

  Future<Set<Marker>> loadMakers() async {
    _makers.value = {
      Marker(
        markerId: const MarkerId('BUS_C7890'),
        position: const LatLng(11.151897153481993, 7.656152925560576),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size.fromHeight(20),
              platform: TargetPlatform.android,
            ),
            'assets/bus-stop.png'),
        infoWindow: InfoWindow(
            title: "BUS_C7890",
            snippet: 'Bus 01 01025896314',
            onTap: () => animateTo(const CameraPosition(
                bearing: 192.8334901395799,
                tilt: 59.440717697143555,
                zoom: 19.151926040649414,
                target: LatLng(11.151897153481993, 7.656152925560576)))),
      ),
      Marker(
        markerId: const MarkerId('BUS_C7891'),
        position: const LatLng(11.157582681811855, 7.652751055309484),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size.fromHeight(20)),
            'assets/bus-stop.png'),
        infoWindow: InfoWindow(
            title: "BUS_C7891",
            snippet: 'Bus 02 01025896314',
            onTap: () => animateTo(const CameraPosition(
                bearing: 192.8334901395799,
                tilt: 59.440717697143555,
                zoom: 19.151926040649414,
                target: LatLng(11.157582681811855, 7.652751055309484)))),
      ),
      Marker(
        markerId: const MarkerId('BUS_C7892'),
        position: const LatLng(11.154893502232717, 7.6511509936398205),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size.fromHeight(20)),
            'assets/bus-stop.png'),
        infoWindow: InfoWindow(
            title: "BUS_C7892",
            snippet: 'Bus 03 01025896314',
            onTap: () => animateTo(const CameraPosition(
                bearing: 192.8334901395799,
                tilt: 59.440717697143555,
                zoom: 19.151926040649414,
                target: LatLng(11.154893502232717, 7.6511509936398205)))),
      ),
    };
    return _makers.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _makers.value,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    ));
  }

  Future<void> animateTo(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
