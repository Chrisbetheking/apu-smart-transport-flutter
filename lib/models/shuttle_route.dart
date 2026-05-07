import '../core/i18n/app_language.dart';

enum RouteStatus { onTime, limitedSeats, delayed, arrived }

class RoutePoint {
  const RoutePoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class ShuttleRoute {
  const ShuttleRoute({
    required this.id,
    required this.routeGroupId,
    required this.routeGroupZh,
    required this.routeGroupEn,
    required this.directionZh,
    required this.directionEn,
    required this.busCode,
    required this.routeNameZh,
    required this.routeNameEn,
    required this.startPointZh,
    required this.startPointEn,
    required this.destinationZh,
    required this.destinationEn,
    required this.nextDepartureTime,
    required this.estimatedDurationZh,
    required this.estimatedDurationEn,
    required this.availableSeats,
    required this.status,
    required this.stopsZh,
    required this.stopsEn,
    required this.noteZh,
    required this.noteEn,
    required this.path,
    required this.distanceKm,
    required this.averageSpeedKmh,
  });

  final String id;
  final String routeGroupId;
  final String routeGroupZh;
  final String routeGroupEn;
  final String directionZh;
  final String directionEn;
  final String busCode;
  final String routeNameZh;
  final String routeNameEn;
  final String startPointZh;
  final String startPointEn;
  final String destinationZh;
  final String destinationEn;
  final String nextDepartureTime;
  final String estimatedDurationZh;
  final String estimatedDurationEn;
  final int availableSeats;
  final RouteStatus status;
  final List<String> stopsZh;
  final List<String> stopsEn;
  final String noteZh;
  final String noteEn;
  final List<RoutePoint> path;
  final double distanceKm;
  final double averageSpeedKmh;

  String routeGroup(AppLanguage language) =>
      language == AppLanguage.zh ? routeGroupZh : routeGroupEn;

  String direction(AppLanguage language) =>
      language == AppLanguage.zh ? directionZh : directionEn;

  String routeName(AppLanguage language) =>
      language == AppLanguage.zh ? routeNameZh : routeNameEn;

  String startPoint(AppLanguage language) =>
      language == AppLanguage.zh ? startPointZh : startPointEn;

  String destination(AppLanguage language) =>
      language == AppLanguage.zh ? destinationZh : destinationEn;

  String estimatedDuration(AppLanguage language) =>
      language == AppLanguage.zh ? estimatedDurationZh : estimatedDurationEn;

  String note(AppLanguage language) => language == AppLanguage.zh ? noteZh : noteEn;

  List<String> stops(AppLanguage language) =>
      language == AppLanguage.zh ? stopsZh : stopsEn;
}
