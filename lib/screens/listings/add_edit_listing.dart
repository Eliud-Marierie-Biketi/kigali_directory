import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/listing_model.dart';
import '../../providers/listing_provider.dart';

class AddEditListingScreen extends StatefulWidget {
  final Listing? listing;
  const AddEditListingScreen({super.key, this.listing});

  @override
  State<AddEditListingScreen> createState() => _AddEditListingScreenState();
}

class _AddEditListingScreenState extends State<AddEditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController, addressController, contactController, 
       descriptionController, latController, longController;
  String selectedCategory = "Restaurant";

  final categories = ["Hospital", "Police Station", "Library", "Restaurant", "Café", "Park", "Tourist Attraction"];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.listing?.name ?? "");
    addressController = TextEditingController(text: widget.listing?.address ?? "");
    contactController = TextEditingController(text: widget.listing?.contact ?? "");
    descriptionController = TextEditingController(text: widget.listing?.description ?? "");
    latController = TextEditingController(text: widget.listing?.latitude.toString() ?? "-1.9441");
    longController = TextEditingController(text: widget.listing?.longitude.toString() ?? "30.0619");
    if (widget.listing != null) selectedCategory = widget.listing!.category;
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red.shade200)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(widget.listing == null ? "New Listing" : "Update details", style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _sectionHeader("General Information"),
            TextFormField(controller: nameController, decoration: _inputStyle("Name of Place", Icons.store_rounded), validator: (v) => v!.isEmpty ? "Title required" : null),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: selectedCategory,
              decoration: _inputStyle("Category", Icons.category_rounded),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => selectedCategory = v!),
            ),
            
            const SizedBox(height: 32),
            _sectionHeader("Contact & Location"),
            TextFormField(controller: addressController, decoration: _inputStyle("Street Address", Icons.location_on_rounded)),
            const SizedBox(height: 16),
            TextFormField(controller: contactController, keyboardType: TextInputType.phone, decoration: _inputStyle("Phone Number", Icons.phone_rounded)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextFormField(controller: latController, keyboardType: TextInputType.number, decoration: _inputStyle("Lat", Icons.map_rounded))),
                const SizedBox(width: 12),
                Expanded(child: TextFormField(controller: longController, keyboardType: TextInputType.number, decoration: _inputStyle("Long", Icons.map_outlined))),
              ],
            ),
            
            const SizedBox(height: 32),
            _sectionHeader("About"),
            TextFormField(controller: descriptionController, maxLines: 4, decoration: _inputStyle("Write a short description...", Icons.description_rounded)),
            
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _handleSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Text(widget.listing == null ? "Publish Listing" : "Save Changes", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<ListingProvider>(context, listen: false);
    final listing = Listing(
      id: widget.listing?.id ?? "",
      name: nameController.text,
      category: selectedCategory,
      address: addressController.text,
      contact: contactController.text,
      description: descriptionController.text,
      latitude: double.tryParse(latController.text) ?? 0.0,
      longitude: double.tryParse(longController.text) ?? 0.0,
      createdBy: FirebaseAuth.instance.currentUser!.uid,
      timestamp: DateTime.now(),
    );
    widget.listing == null ? provider.addListing(listing) : provider.updateListing(listing);
    Navigator.pop(context);
  }
}