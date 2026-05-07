import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/i18n/app_strings.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/bookings_overview_screen.dart';
import 'screens/admin/parking_overview_screen.dart';
import 'screens/admin/routes_overview_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/driver/assigned_route_screen.dart';
import 'screens/driver/driver_dashboard.dart';
import 'screens/driver/passenger_list_screen.dart';
import 'screens/map/tracking_screen.dart';
import 'screens/student/my_bookings_screen.dart';
import 'screens/student/notices_screen.dart';
import 'screens/student/parking_zones_screen.dart';
import 'screens/student/shuttle_routes_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'services/booking_service.dart';

void main() {
  runApp(const FlutterCampusShuttleApp());
}

class FlutterCampusShuttleApp extends StatefulWidget {
  const FlutterCampusShuttleApp({super.key});

  @override
  State<FlutterCampusShuttleApp> createState() => _FlutterCampusShuttleAppState();
}

class _FlutterCampusShuttleAppState extends State<FlutterCampusShuttleApp> {
  late final BookingService _bookingService;
  late final LanguageService _languageService;

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService();
    _languageService = LanguageService();
  }

  @override
  void dispose() {
    _bookingService.dispose();
    _languageService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLanguageScope(
      notifier: _languageService,
      child: BookingScope(
        notifier: _bookingService,
        child: AnimatedBuilder(
          animation: _languageService,
          builder: (context, _) {
            return MaterialApp(
              title: 'Flutter-Campus-Shuttle-App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                  primary: AppColors.primary,
                  secondary: AppColors.accent,
                  surface: AppColors.card,
                ),
                scaffoldBackgroundColor: AppColors.background,
                appBarTheme: const AppBarTheme(
                  backgroundColor: AppColors.background,
                  centerTitle: false,
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              initialRoute: '/',
              routes: {
                '/': (_) => const LoginScreen(),
                '/student-dashboard': (_) => const StudentDashboard(),
                '/driver-dashboard': (_) => const DriverDashboard(),
                '/admin-dashboard': (_) => const AdminDashboard(),
                '/routes': (_) => const ShuttleRoutesScreen(),
                '/parking': (_) => const ParkingZonesScreen(),
                '/bookings': (_) => const MyBookingsScreen(),
                '/notices': (_) => const NoticesScreen(),
                '/tracking': (_) => const TrackingScreen(),
                '/assigned-route': (_) => const AssignedRouteScreen(),
                '/passengers': (_) => const PassengerListScreen(),
                '/admin-routes': (_) => const RoutesOverviewScreen(),
                '/admin-bookings': (_) => const BookingsOverviewScreen(),
                '/admin-parking': (_) => const ParkingOverviewScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
