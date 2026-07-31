import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../../../../core/widget/primary_button.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(-6.200000, 106.816666); // Default Jakarta
  bool _isLoading = true;
  bool _isGettingAddress = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Gagal Lokasi', 'Layanan lokasi dinonaktifkan.');
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Gagal Lokasi', 'Izin lokasi ditolak.');
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Gagal Lokasi', 'Izin lokasi ditolak secara permanen.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
      );
      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _mapController.move(_currentCenter, 15.0);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectLocation() async {
    setState(() => _isGettingAddress = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentCenter.latitude,
        _currentCenter.longitude,
      );

      String address = '';
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
          place.postalCode
        ].where((p) => p != null && p.isNotEmpty).toList();
        
        address = parts.join(', ');
      }
      
      Get.back(result: {
        'latitude': _currentCenter.latitude,
        'longitude': _currentCenter.longitude,
        'address': address.isEmpty ? 'Lokasi Tidak Diketahui' : address,
      });
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal mengambil alamat. Silakan coba lagi.');
    } finally {
      if (mounted) setState(() => _isGettingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 15.0,
              onPositionChanged: (position, hasGesture) {
                _currentCenter = position.center;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.bakery.ecommerce',
              ),
            ],
          ),
          
          // Center Marker
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0), // Offset to point to exact center
              child: Icon(
                Icons.location_on,
                size: 40.0,
                color: const Color(0xFFFF9800),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9800)),
            ),
            
          // Floating Action Button to re-center
          Positioned(
            right: 16,
            bottom: 180, // Above the bottom panel
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFF9800),
              onPressed: () {
                setState(() => _isLoading = true);
                _checkPermissionAndGetLocation();
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
            
          // Bottom panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 24, 
                left: 24, 
                right: 24, 
                bottom: 24 + MediaQuery.of(context).padding.bottom
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Geser peta untuk menentukan lokasi yang tepat',
                    style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  _isGettingAddress 
                      ? const CircularProgressIndicator(color: Color(0xFFFF9800))
                      : PrimaryButton(
                          text: 'Konfirmasi Lokasi',
                          onPressed: _selectLocation,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
