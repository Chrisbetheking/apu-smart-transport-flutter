import '../core/i18n/app_language.dart';
import 'shuttle_route.dart';

class DriverTrip {
  const DriverTrip({
    required this.id,
    required this.route,
    required this.pickupWindow,
    required this.passengerCount,
    required this.capacity,
    required this.status,
    required this.checkpointsZh,
    required this.checkpointsEn,
  });

  final String id;
  final ShuttleRoute route;
  final String pickupWindow;
  final int passengerCount;
  final int capacity;
  final RouteStatus status;
  final List<String> checkpointsZh;
  final List<String> checkpointsEn;

  List<String> checkpoints(AppLanguage language) =>
      language == AppLanguage.zh ? checkpointsZh : checkpointsEn;
}
