# Kigali City Services & Places Directory (Flutter + Firebase)

## Overview

The **Kigali City Services & Places Directory** is a mobile application built using **Flutter** and **Firebase** that helps users discover important services and locations within Kigali. The application allows users to browse public services and lifestyle locations such as hospitals, police stations, libraries, restaurants, cafés, parks, and tourist attractions.

This project demonstrates the integration of **Firebase Authentication**, **Cloud Firestore**, **Google Maps**, and **state management using Provider** to create a fully functional backend-connected Flutter application.

The application supports **real-time data updates**, **location-based navigation**, and **user-generated listings**.

---

# Features

## User Authentication

The app uses **Firebase Authentication** to manage secure user access.

Users can:

- Create an account using **email and password**
- Log in to their existing account
- Verify their email address before accessing the application
- Log out securely

Each authenticated user has a corresponding **user profile stored in Firestore**.

---

## Directory Listings (CRUD Operations)

Users can manage listings representing different services or locations.

### Supported operations

- Create a new listing
- View all listings in the shared directory
- Edit listings created by the user
- Delete listings created by the user

### Each listing includes

- Place / Service Name
- Category
- Address
- Contact Number
- Description
- Geographic Coordinates (Latitude & Longitude)
- Creator User ID
- Timestamp

All listing updates are reflected **in real-time using Firestore streams**.

---

## Search and Filtering

Users can easily locate services using:

- **Search by name**
- **Filter listings by category**

### Example categories

- Hospital
- Police Station
- Library
- Restaurant
- Café
- Park
- Tourist Attraction

Results update dynamically when data changes in Firestore.

---

## Listing Detail Page

When a user selects a listing, they are taken to a **detail page** displaying full information about that location.

The detail page includes:

- Name of the place
- Category
- Description
- Address
- Contact number
- Map location

---

## Google Maps Integration

Each listing displays its location using an **embedded Google Map**.

Features include:

- Map marker showing the location
- Ability to view the exact coordinates
- Launching **Google Maps navigation** for directions to the selected location

---

## Bottom Navigation

The application uses a **BottomNavigationBar** for easy navigation between main sections:

- **Directory** – browse all listings  
- **My Listings** – view listings created by the current user  
- **Map View** – view locations on a map  
- **Settings** – view user profile and preferences  

---

# State Management

The application uses **Provider** for state management.

Provider is responsible for:

- Managing Firestore read and write operations
- Handling loading and error states
- Updating the UI automatically when Firestore data changes

Firestore interactions are **not performed directly inside UI widgets**.  
Instead, they are handled through a **service layer**, which improves separation of concerns and maintainability.

---

# Project Architecture

The project follows a **clean and organized structure**:
lib/
│
├── models/
│ └── listing_model.dart
│
├── providers/
│ ├── auth_provider.dart
│ └── listing_provider.dart
│
├── services/
│ ├── auth_service.dart
│ └── firestore_service.dart
│
├── screens/
│ ├── auth/
│ ├── directory/
│ ├── listings/
│ ├── map/
│ └── settings/
│
├── widgets/
│
└── main.dart


This separation improves **scalability, readability, and maintainability**.

---

# Firestore Database Structure

## users collection

Stores information about registered users.

### Example document
users
└── userId
email: user@email.com

createdAt: timestamp


---

## listings collection

Stores all service/location listings.

### Example document


listings
└── listingId
name: Kigali Central Hospital
category: Hospital
address: Kigali City
contactNumber: +250 123456789
description: Public healthcare facility
latitude: -1.9441
longitude: 30.0619
createdBy: userUID
timestamp: serverTimestamp
