import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../models/shuttle_route.dart';
import '../../services/demo_data_service.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/live_time_chip.dart';
import '../../widgets/status_badge.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({
    super.key,
    this.route,
  });

  final ShuttleRoute? route;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final MapController _mapController = MapController();
  final Distance _distance = const Distance();

  Timer? _timer;
  late ShuttleRoute _route;
  Duration _elapsedBeforePause = Duration.zero;
  DateTime? _startedAt;
  bool _running = false;
  bool _arrived = false;

  @override
  void initState() {
    super.initState();
    _route = widget.route ?? DemoDataService.shuttleRoutes.first;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<LatLng> get _points => _route.path
      .map((point) => LatLng(point.latitude, point.longitude))
      .toList(growable: false);

  double get _totalMeters {
    final points = _points;
    double total = 0;
    for (var i = 0; i < points.length - 1; i += 1) {
      total += _distance.as(LengthUnit.Meter, points[i], points[i + 1]);
    }
    return total == 0 ? _route.distanceKm * 1000 : total;
  }

  Duration get _routeDuration {
    final seconds = ((_route.distanceKm / _route.averageSpeedKmh) * 3600).round();
    return Duration(seconds: seconds.clamp(30, 3600).toInt());
  }

  Duration get _elapsed {
    if (_arrived) return _routeDuration;
    if (_running && _startedAt != null) {
      return _elapsedBeforePause + DateTime.now().difference(_startedAt!);
    }
    return _elapsedBeforePause;
  }

  double get _progress {
    final durationMs = _routeDuration.inMilliseconds;
    if (durationMs == 0) return 1;
    return (_elapsed.inMilliseconds / durationMs).clamp(0.0, 1.0);
  }

  LatLng get _currentPoint => _pointAtProgress(_progress);

  void _tick() {
    if (!mounted) return;
    if (_running && _elapsed >= _routeDuration) {
      _markArrived(showMessage: false);
      return;
    }
    setState(() {});
    if (_running) {
      _mapController.move(_currentPoint, 15.4);
    }
  }

  void _start() {
    if (_running || _arrived) return;
    setState(() {
      _running = true;
      _startedAt = DateTime.now();
    });
  }

  void _pause() {
    if (!_running) return;
    setState(() {
      _elapsedBeforePause = _elapsed;
      _startedAt = null;
      _running = false;
    });
  }

  void _reset() {
    setState(() {
      _elapsedBeforePause = Duration.zero;
      _startedAt = null;
      _running = false;
      _arrived = false;
    });
    _mapController.move(_points.first, 15.2);
  }

  void _markArrived({bool showMessage = true}) {
    setState(() {
      _elapsedBeforePause = _routeDuration;
      _startedAt = null;
      _running = false;
      _arrived = true;
    });
    _mapController.move(_points.last, 15.4);
    if (showMessage) {
      final t = AppLanguageScope.stringsOf(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.arrivedDone)),
      );
    }
  }

  void _selectRoute(ShuttleRoute route) {
    setState(() {
      _route = route;
      _elapsedBeforePause = Duration.zero;
      _startedAt = null;
      _running = false;
      _arrived = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(_points.first, 15.2);
    });
  }

  LatLng _pointAtProgress(double progress) {
    final points = _points;
    if (points.length == 1 || progress <= 0) return points.first;
    if (progress >= 1) return points.last;

    final targetMeters = _totalMeters * progress;
    double travelled = 0;

    for (var i = 0; i < points.length - 1; i += 1) {
      final start = points[i];
      final end = points[i + 1];
      final segment = _distance.as(LengthUnit.Meter, start, end);
      if (travelled + segment >= targetMeters) {
        final localRatio = segment == 0 ? 0 : (targetMeters - travelled) / segment;
        return LatLng(
          start.latitude + (end.latitude - start.latitude) * localRatio,
          start.longitude + (end.longitude - start.longitude) * localRatio,
        );
      }
      travelled += segment;
    }
    return points.last;
  }

  String _formatDuration(Duration duration, AppStrings t) {
    if (duration.inSeconds <= 0) return '0 min';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    if (t.isZh) {
      return minutes <= 0 ? '$seconds 秒' : '$minutes 分 ${seconds.toString().padLeft(2, '0')} 秒';
    }
    return minutes <= 0 ? '${seconds}s' : '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final lang = AppLanguageScope.languageOf(context);
    final points = _points;
    final current = _currentPoint;
    final stops = _route.stops(lang);
    final stopIndex = (_progress * (stops.length - 1)).floor().clamp(0, stops.length - 1).toInt();
    final currentStop = stops[stopIndex];
    final nextStop = _arrived
        ? t.arrived
        : stops[(stopIndex + 1).clamp(0, stops.length - 1).toInt()];
    final statusLabel = _arrived
        ? t.arrived
        : _running
            ? t.onRoute
            : _elapsed == Duration.zero
                ? t.notStarted
                : t.paused;
    final remaining = _routeDuration - _elapsed;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.mapTracking),
        actions: const [LanguageToggle()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.alpha(Colors.black, 0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _route.routeName(lang),
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${t.mapNote} ${t.playbackSpeedNote}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusBadge(label: statusLabel),
                              const SizedBox(height: 10),
                              const LiveTimeChip(compact: true),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _RouteSelector(
                        selectedRoute: _route,
                        onRouteSelected: _selectRoute,
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: SizedBox(
                          height: 430,
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: points.first,
                              initialZoom: 15.2,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.chrisbetheking.flutter_campus_shuttle_app',
                              ),
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: points,
                                    color: AppColors.accent,
                                    strokeWidth: 5,
                                  ),
                                ],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: points.first,
                                    width: 42,
                                    height: 42,
                                    child: const Icon(
                                      Icons.location_on_rounded,
                                      color: AppColors.success,
                                      size: 36,
                                    ),
                                  ),
                                  Marker(
                                    point: points.last,
                                    width: 42,
                                    height: 42,
                                    child: const Icon(
                                      Icons.flag_rounded,
                                      color: AppColors.danger,
                                      size: 34,
                                    ),
                                  ),
                                  Marker(
                                    point: current,
                                    width: 58,
                                    height: 58,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(999),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.alpha(Colors.black, 0.18),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.directions_bus_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 760 ? 4 : 2;
                          return GridView.count(
                            crossAxisCount: columns,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: columns == 4 ? 2.1 : 2.4,
                            children: [
                              _MapMetric(label: t.currentStop, value: currentStop),
                              _MapMetric(label: t.nextStop, value: nextStop),
                              _MapMetric(label: t.eta, value: _arrived ? '0 min' : _formatDuration(remaining, t)),
                              _MapMetric(label: t.routeStatus, value: statusLabel),
                              _MapMetric(label: t.distance, value: '${_route.distanceKm.toStringAsFixed(1)} km'),
                              _MapMetric(label: t.averageSpeed, value: '${_route.averageSpeedKmh.toStringAsFixed(0)} km/h'),
                              _MapMetric(label: t.direction, value: _route.direction(lang)),
                              _MapMetric(label: t.bus, value: _route.busCode),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          FilledButton.icon(
                            onPressed: _running ? null : _start,
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: Text(t.startSimulation),
                          ),
                          OutlinedButton.icon(
                            onPressed: _running ? _pause : null,
                            icon: const Icon(Icons.pause_rounded),
                            label: Text(t.pause),
                          ),
                          OutlinedButton.icon(
                            onPressed: _reset,
                            icon: const Icon(Icons.restart_alt_rounded),
                            label: Text(t.reset),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _arrived ? null : () => _markArrived(),
                            icon: const Icon(Icons.flag_rounded),
                            label: Text(t.markArrived),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteSelector extends StatelessWidget {
  const _RouteSelector({required this.selectedRoute, required this.onRouteSelected});

  final ShuttleRoute selectedRoute;
  final ValueChanged<ShuttleRoute> onRouteSelected;

  @override
  Widget build(BuildContext context) {
    final t = AppLanguageScope.stringsOf(context);
    final lang = AppLanguageScope.languageOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ShuttleRoute>(
          value: selectedRoute,
          isExpanded: true,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: DemoDataService.shuttleRoutes.map((route) {
            return DropdownMenuItem<ShuttleRoute>(
              value: route,
              child: Text('${route.busCode} · ${route.routeName(lang)} · ${route.direction(lang)}'),
            );
          }).toList(),
          onChanged: (route) {
            if (route != null) onRouteSelected(route);
          },
          hint: Text(t.selectRoute),
        ),
      ),
    );
  }
}

class _MapMetric extends StatelessWidget {
  const _MapMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}
