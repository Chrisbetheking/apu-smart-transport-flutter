import 'package:flutter/material.dart';

import '../core/i18n/app_strings.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AppLanguageScope.of(context);
    final isZh = service.language == AppLanguage.zh;

    return TextButton.icon(
      onPressed: service.toggle,
      icon: const Icon(Icons.language_rounded),
      label: Text(isZh ? '中文 / EN' : '中文 / EN'),
    );
  }
}
