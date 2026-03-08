import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String collection = "listings";

  Stream<List<Listing>> getListings() {
    return _db.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Listing.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addListing(Listing listing) async {
    await _db.collection(collection).add(listing.toMap());
  }

  Future<void> updateListing(Listing listing) async {
    await _db.collection(collection).doc(listing.id).update(listing.toMap());
  }

  Future<void> deleteListing(String id) async {
    await _db.collection(collection).doc(id).delete();
  }
}