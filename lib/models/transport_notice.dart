import '../core/i18n/app_language.dart';

class TransportNotice {
  const TransportNotice({
    required this.id,
    required this.titleZh,
    required this.titleEn,
    required this.categoryZh,
    required this.categoryEn,
    required this.messageZh,
    required this.messageEn,
    required this.timeLabelZh,
    required this.timeLabelEn,
    required this.severity,
  });

  final String id;
  final String titleZh;
  final String titleEn;
  final String categoryZh;
  final String categoryEn;
  final String messageZh;
  final String messageEn;
  final String timeLabelZh;
  final String timeLabelEn;
  final String severity;

  String title(AppLanguage language) => language == AppLanguage.zh ? titleZh : titleEn;
  String category(AppLanguage language) =>
      language == AppLanguage.zh ? categoryZh : categoryEn;
  String message(AppLanguage language) =>
      language == AppLanguage.zh ? messageZh : messageEn;
  String timeLabel(AppLanguage language) =>
      language == AppLanguage.zh ? timeLabelZh : timeLabelEn;
}
