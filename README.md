# Flutter-Campus-Shuttle-App

A Flutter-based campus mobility prototype featuring role-based interfaces, OpenStreetMap route visualization, route playback based on average shuttle speed, parking slot selection, and transport booking management. The project uses local demo data and focuses on mobile UI design, navigation flow, shared in-memory state, and practical campus transport scenarios.

> Important: this is a portfolio prototype. It does not use real GPS, official APU transport data, a production backend, or a live transport API. Map routes are based on local sample coordinates and the moving shuttle marker is calculated from route distance and average speed.

## Features

- Chinese-first app UI with English language toggle
- Three role entry: Student, Driver, and Admin
- OpenStreetMap route visualization with shuttle marker playback
- Realistic route timing based on distance and configured average speed
- Route filtering by corridor
- Two active trips per corridor: outbound and return
- Student shuttle seat booking
- Parking zone availability and mini slot-map selection
- Shared booking state across Student, Driver, and Admin views
- Booking lifecycle: Reserved, Checked In, Completed, Cancelled
- Driver passenger check-in and completion actions
- Admin overview for routes, bookings, parking, delays, and passengers
- Live Beijing time display on the tracking page
- GitHub Pages workflow for web demo deployment

## Role-based user flow

### Student

1. Enter as Student.
2. Review the dashboard summary.
3. Filter shuttle routes and open a route detail page.
4. View the OpenStreetMap route playback.
5. Book a shuttle seat.
6. Select a parking zone and choose a parking slot from the mini map.
7. View and cancel bookings in My Bookings.

### Driver

1. Enter as Driver.
2. View assigned routes and passenger load.
3. Open the route playback screen.
4. Start, pause, reset, or mark the trip as arrived.
5. Open the passenger list and check in reserved shuttle passengers.
6. Completed passenger status is reflected in admin and booking views.

### Admin

1. Enter as Admin.
2. Review total routes, active bookings, parking occupancy, delayed shuttles, and passenger count.
3. Open routes, bookings, and parking overview pages.
4. See bookings created from the student side and status changes made by the driver.

## OpenStreetMap route playback

The app uses `flutter_map` with OpenStreetMap tiles. Each shuttle route has a local list of coordinates. The shuttle marker moves along the route using:

- local route coordinates
- route distance
- configured average shuttle speed
- elapsed time from the Start Route action

This is not live GPS tracking. It is designed to make the portfolio demo feel closer to a real route experience while keeping the implementation local and transparent.

## Sample route corridors

- Bukit Jalil LRT Station ↔ 8th & Stellar @ Sri Petaling
- Taman Naga Emas MRT Station ↔ 8th & Stellar @ Sri Petaling
- Bukit Jalil LRT Station ↔ Taman Naga Emas MRT Station

Each corridor includes one outbound and one return shuttle.

## Booking lifecycle

```text
Reserved → Checked In → Completed
Reserved → Cancelled
```

- Students can cancel their own bookings.
- Drivers can check in shuttle passengers.
- Admin can view all booking statuses.
- Cancelled bookings remain visible instead of being deleted.

## Tech stack

- Flutter
- Dart
- Material 3
- flutter_map
- OpenStreetMap tiles
- latlong2
- Local in-memory state
- GitHub Pages deployment workflow

## Project structure

```text
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   └── i18n/
│       ├── app_language.dart
│       └── app_strings.dart
├── models/
│   ├── booking.dart
│   ├── driver_trip.dart
│   ├── parking_zone.dart
│   ├── shuttle_route.dart
│   ├── transport_notice.dart
│   └── user_role.dart
├── services/
│   ├── booking_service.dart
│   └── demo_data_service.dart
├── screens/
│   ├── auth/
│   ├── student/
│   ├── driver/
│   ├── admin/
│   └── map/
└── widgets/
```

## Screenshots

Add screenshots to:

```text
docs/screenshots/
```

Suggested screenshots:

- Role selection page
- Student dashboard
- Shuttle route filter
- Route playback map
- Parking slot selection
- Driver passenger list
- Admin dashboard

## How to run locally

```bash
flutter pub get
flutter run -d chrome
```

## Build web demo

```bash
flutter build web --release --base-href /Flutter-Campus-Shuttle-App/
```

## GitHub Pages

This project includes a GitHub Actions workflow:

```text
.github/workflows/deploy_github_pages.yml
```

After pushing to `main`, enable GitHub Pages with GitHub Actions as the source.

Expected demo URL:

```text
https://chrisbetheking.github.io/Flutter-Campus-Shuttle-App/
```

## What I learned

- Structuring a Flutter app with multiple user roles
- Creating reusable Material 3 UI components
- Managing shared in-memory state across different role views
- Building a shuttle booking and parking reservation flow
- Displaying OpenStreetMap in Flutter with a moving route marker
- Keeping portfolio wording honest without claiming real GPS or backend functionality
- Preparing a Flutter web build for GitHub Pages

## Future improvements

- Add persistent local storage for bookings
- Add a mock REST API layer
- Add better route geometry from a routing service
- Add more detailed driver trip controls
- Add route search by station or destination
- Add screenshots and short demo video for the portfolio website

## Author

Chris / Kevin  
Undergraduate Software Development / AI Application / Front-end Internship Portfolio Project
