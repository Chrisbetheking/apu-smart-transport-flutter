import '../core/i18n/app_language.dart';

enum ParkingStatus { available, limited, full }

class ParkingZone {
  const ParkingZone({
    required this.id,
    required this.zoneNameZh,
    required this.zoneNameEn,
    required this.availableSlots,
    required this.totalSlots,
    required this.distanceZh,
    required this.distanceEn,
    required this.locationZh,
    required this.locationEn,
    required this.slotPrefix,
    this.mapRows = 3,
    this.mapColumns = 4,
  });

  final String id;
  final String zoneNameZh;
  final String zoneNameEn;
  final int availableSlots;
  final int totalSlots;
  final String distanceZh;
  final String distanceEn;
  final String locationZh;
  final String locationEn;
  final String slotPrefix;
  final int mapRows;
  final int mapColumns;

  String zoneName(AppLanguage language) =>
      language == AppLanguage.zh ? zoneNameZh : zoneNameEn;

  String distance(AppLanguage language) =>
      language == AppLanguage.zh ? distanceZh : distanceEn;

  String location(AppLanguage language) =>
      language == AppLanguage.zh ? locationZh : locationEn;

  List<String> get visibleSlotLabels {
    return List.generate(mapRows * mapColumns, (index) {
      final number = index + 1;
      return '$slotPrefix${number.toString().padLeft(2, '0')}';
    });
  }

  ParkingStatus statusFor(int available) {
    if (available <= 0) return ParkingStatus.full;
    if (available <= 3) return ParkingStatus.limited;
    return ParkingStatus.available;
  }
}
