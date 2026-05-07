import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/i18n/app_strings.dart';

class LiveTimeChip extends StatefulWidget {
  const LiveTimeChip({super.key, this.compact = false});

  final bool compact;

  @override
  State<LiveTimeChip> createState() => _LiveTimeChipState();
}

class _LiveTimeChipState extends State<LiveTimeChip> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now().toUtc().add(const Duration(hours: 8));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now().toUtc().add(const Duration(hours: 8)));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final value = '${_two(_now.hour)}:${_two(_now.minute)}:${_two(_now.second)}';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 10 : 14,
        vertical: widget.compact ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            widget.compact ? value : '${t.beijingTime} $value',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
