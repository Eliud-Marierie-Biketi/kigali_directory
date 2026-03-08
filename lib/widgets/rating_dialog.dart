import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/listing_model.dart';
import '../providers/listing_provider.dart';

Future<void> showRatingDialog(
  BuildContext context,
  Listing listing,
) async {
  double rating = listing.rating;

  final reviewController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {

          Widget buildStar(int index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
              onPressed: () {
                setState(() {
                  rating = index + 1;
                });
              },
            );
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            title: const Text("Rate this place"),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// STARS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => buildStar(index),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  rating == 0
                      ? "Tap a star to rate"
                      : "$rating / 5",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                /// REVIEW
                TextField(
                  controller: reviewController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Write a review (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            actions: [

              /// CANCEL
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),

              /// SUBMIT
              ElevatedButton(
                onPressed: rating == 0
                    ? null
                    : () async {

                        final provider = Provider.of<ListingProvider>(
                          context,
                          listen: false,
                        );

                        /// create updated listing
                        final updatedListing = listing.copyWith(
                          rating: rating,
                          description: reviewController.text,
                        );

                        await provider.updateListing(updatedListing);

                        Navigator.pop(context);
                      },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      );
    },
  );
}