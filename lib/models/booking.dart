import '../core/i18n/app_language.dart';

enum BookingType { shuttle, parking }

enum BookingStatus { reserved, checkedIn, completed, cancelled }

class Booking {
  const Booking({
    required this.id,
    required this.type,
    required this.titleZh,
    required this.titleEn,
    required this.timeZh,
    required this.timeEn,
    required this.status,
    required this.createdAt,
    required this.detailsZh,
    required this.detailsEn,
    required this.passengerName,
    required this.isMine,
  });

  final String id;
  final BookingType type;
  final String titleZh;
  final String titleEn;
  final String timeZh;
  final String timeEn;
  final BookingStatus status;
  final DateTime createdAt;
  final String detailsZh;
  final String detailsEn;
  final String passengerName;
  final bool isMine;

  String title(AppLanguage language) => language == AppLanguage.zh ? titleZh : titleEn;
  String details(AppLanguage language) =>
      language == AppLanguage.zh ? detailsZh : detailsEn;

  String time(AppLanguage language) => language == AppLanguage.zh ? timeZh : timeEn;

  Booking copyWith({
    String? id,
    BookingType? type,
    String? titleZh,
    String? titleEn,
    String? timeZh,
    String? timeEn,
    BookingStatus? status,
    DateTime? createdAt,
    String? detailsZh,
    String? detailsEn,
    String? passengerName,
    bool? isMine,
  }) {
    return Booking(
      id: id ?? this.id,
      type: type ?? this.type,
      titleZh: titleZh ?? this.titleZh,
      titleEn: titleEn ?? this.titleEn,
      timeZh: timeZh ?? this.timeZh,
      timeEn: timeEn ?? this.timeEn,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      detailsZh: detailsZh ?? this.detailsZh,
      detailsEn: detailsEn ?? this.detailsEn,
      passengerName: passengerName ?? this.passengerName,
      isMine: isMine ?? this.isMine,
    );
  }
}
