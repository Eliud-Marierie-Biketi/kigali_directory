import 'package:flutter/material.dart';

import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<Listing> listings = [];

  ListingProvider() {
    _service.getListings().listen((data) {
      listings = data;
      notifyListeners();
    });
  }

  Future<void> addListing(Listing listing) async {
    await _service.addListing(listing);
  }

  Future<void> updateListing(Listing listing) async {
    await _service.updateListing(listing);
  }

  Future<void> deleteListing(String id) async {
    await _service.deleteListing(id);
  }
}