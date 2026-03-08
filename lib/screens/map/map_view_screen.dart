import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/listing_provider.dart';
import '../../models/listing_model.dart';
import '../listings/listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  Listing? _selectedListing;
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final listings = Provider.of<ListingProvider>(context).listings;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Kigali Map", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white.withAlpha(230),
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-1.9441, 30.0619),
              initialZoom: 13,
              onTap: (_, _) => setState(() => _selectedListing = null),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.kigali_directory",
              ),
              MarkerLayer(
                markers: listings.map((l) => _buildMarker(l)).toList(),
              ),
            ],
          ),
          if (_selectedListing != null) _buildSelectedListingCard(_selectedListing!),
        ],
      ),
    );
  }

  Marker _buildMarker(Listing listing) {
    final isSelected = _selectedListing?.id == listing.id;
    return Marker(
      width: 60,
      height: 60,
      point: LatLng(listing.latitude, listing.longitude),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedListing = listing);
          _mapController.move(LatLng(listing.latitude, listing.longitude), 15);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(66), blurRadius: 10, offset: const Offset(0, 4))],
            border: Border.all(color: isSelected ? Colors.white : Colors.blue, width: 3),
          ),
          child: Icon(
            _getCategoryIcon(listing.category),
            color: isSelected ? Colors.white : Colors.blue,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedListingCard(Listing listing) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ListingDetailScreen(listing: listing))),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(color: Colors.blue.withAlpha(26), borderRadius: BorderRadius.circular(12)),
                child: Icon(_getCategoryIcon(listing.category), color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(listing.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(listing.address, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Hospital": return Icons.local_hospital_rounded;
      case "Restaurant": return Icons.restaurant_rounded;
      case "Café": return Icons.coffee_rounded;
      case "Park": return Icons.forest_rounded;
      default: return Icons.place_rounded;
    }
  }
}