# Driver CarPool App

CarPool is a Flutter application for ride-sharing and managing trips. It provides a convenient platform for drivers and passengers to connect for shared transportation.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)


## Features

- Driver Authentication and Authorization
- Driver Dashboard with Quick Actions
- Driver Profile Management
- Trip Requests and Management
- Responsive UI Design

## Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/CarPool.git
    cd CarPool
    ```

2. **Install dependencies:**

    ```bash
    flutter pub get
    ```

3. **Run the app:**

    ```bash
    flutter run
    ```

## Usage

1. **Driver Login:**
   - Launch the app and log in using your driver credentials.

2. **Driver Dashboard:**
   - Access the driver dashboard to perform various actions, such as adding trips, managing profile, viewing trip requests, and checking completed trips.

3. **Driver Profile:**
   - View and update your driver profile information.

4. **Trip Requests:**
   - Navigate to the "Trip Requests" section to manage incoming requests from passengers.

5. **Done Trips:**
   - Check completed trips and their details.

## Project Structure

- `lib/`
  - `controllers/`: Contains controllers for different screens and functionalities.
  - `models/`: Defines data models used in the app.
  - `views/`: Contains the UI pages/screens.
  - `main. dart`: Entry point of the application.

## Dependencies

- `flutter/material.dart`: Core Flutter framework for building UI.
- `cloud_firestore`: Firebase Firestore for database interactions.
- - `cloud_firestore: ^4.13.5`
- `firebase_auth: ^4.15.2`
- `firebase_core: ^2.24.2`
- `firebase_messaging: ^14.7.8`
- `firebase_storage: ^11.5.5`
- `google_sign_in: ^6.2.0`
- `flutter: sdk: flutter`
- `flutter_svg: ^2.0.9`
- `sqflite: ^2.3.0`
- `connectivity: ^3.0.6`

Ensure that you have Flutter and Dart installed on your machine. For more details, refer to the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).


