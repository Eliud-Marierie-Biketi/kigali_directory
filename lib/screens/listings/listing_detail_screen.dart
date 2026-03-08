import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kigali_directory/widgets/rating_dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/listing_model.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing listing;
  const ListingDetailScreen({super.key, required this.listing});

  void openNavigation() async {
    final url = "https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(listing.category.toUpperCase(), 
              style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12)),
            const SizedBox(height: 8),
            Text(listing.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 12),
            
            // Rating Row
            Row(
              children: [
                _buildRatingBadge(listing.rating),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () => showRatingDialog(context, listing),
                  icon: const Icon(Icons.star_outline, size: 18),
                  label: const Text("Rate place"),
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                )
              ],
            ),
            
            const Divider(height: 40),

            // Info Section
            _buildSectionTitle("Contact Information"),
            _buildDetailTile(Icons.location_on_rounded, "Address", listing.address, Colors.redAccent),
            _buildDetailTile(Icons.phone_rounded, "Phone", listing.contact, Colors.green),
            
            const SizedBox(height: 24),

            // Description Section
            _buildSectionTitle("About"),
            Text(
              listing.description,
              style: TextStyle(fontSize: 15, height: 1.6, color: Colors.blueGrey[800]),
            ),

            const SizedBox(height: 32),

            // Map Section
            _buildSectionTitle("Location"),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(26), blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FlutterMap(
  options: MapOptions(
    initialCenter: LatLng(listing.latitude, listing.longitude),
    initialZoom: 15,
  ),
  children: [
    TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: 'com.example.kigali_directory',
    ),

    MarkerLayer(
      markers: [
        Marker(
          point: LatLng(listing.latitude, listing.longitude),
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ),
      ],
    ),

    RichAttributionWidget(
      attributions: [
        TextSourceAttribution(
          '© OpenStreetMap contributors',
          onTap: () => launchUrl(
            Uri.parse('https://www.openstreetmap.org/copyright'),
          ),
        ),
      ],
    ),
  ],
)
              ),
            ),
            
            const SizedBox(height: 32),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: openNavigation,
                icon: const Icon(Icons.directions_rounded),
                label: const Text("GET DIRECTIONS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.amber[400], borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            rating == 0 ? "NEW" : rating.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}