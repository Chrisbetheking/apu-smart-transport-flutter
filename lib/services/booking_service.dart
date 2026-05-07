import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../models/parking_zone.dart';
import '../models/shuttle_route.dart';
import 'demo_data_service.dart';

class BookingService extends ChangeNotifier {
  BookingService() {
    _bookings.addAll(_seedBookings);
    _parkingAvailabilityOverrides['zone-b'] = 4;
    _reservedParkingSlots['zone-b'] = {'B03'};
  }

  final List<Booking> _bookings = [];
  final Map<String, int> _routeSeatAdjustments = {};
  final Map<String, int> _parkingAvailabilityOverrides = {};
  final Map<String, Set<String>> _reservedParkingSlots = {};
  int _serial = 1000;

  List<Booking> get bookings => List.unmodifiable(_bookings);

  List<Booking> get myBookings => _bookings
      .where((booking) => booking.isMine)
      .toList(growable: false);

  List<Booking> get shuttleBookings => _bookings
      .where((booking) => booking.type == BookingType.shuttle)
      .toList(growable: false);

  List<Booking> get activeBookings => _bookings
      .where((booking) => booking.status == BookingStatus.reserved || booking.status == BookingStatus.checkedIn)
      .toList(growable: false);

  int get activeBookingCount => activeBookings.length;

  int get todayPassengerCount => shuttleBookings
      .where((booking) => booking.status != BookingStatus.cancelled)
      .length;

  int get unreadNoticeCount => DemoDataService.notices.length;

  int seatsForRoute(ShuttleRoute route) {
    final adjustment = _routeSeatAdjustments[route.id] ?? 0;
    return (route.availableSeats - adjustment)
        .clamp(0, route.availableSeats)
        .toInt();
  }

  int availableSlotsForZone(ParkingZone zone) {
    return _parkingAvailabilityOverrides[zone.id] ?? zone.availableSlots;
  }

  Set<String> reservedSlotLabelsForZone(ParkingZone zone) {
    return Set.unmodifiable(_reservedParkingSlots[zone.id] ?? <String>{});
  }

  String? firstAvailableSlotForZone(ParkingZone zone) {
    final reserved = _reservedParkingSlots[zone.id] ?? <String>{};
    for (final label in zone.visibleSlotLabels) {
      if (!reserved.contains(label)) return label;
    }
    return null;
  }

  int get totalAvailableParkingSlots {
    return DemoDataService.parkingZones.fold<int>(
      0,
      (total, zone) => total + availableSlotsForZone(zone),
    );
  }

  Booking reserveShuttle(ShuttleRoute route) {
    final remainingSeats = seatsForRoute(route);
    if (remainingSeats <= 0) {
      throw StateError('No seats are available for this route right now.');
    }

    _routeSeatAdjustments[route.id] =
        (_routeSeatAdjustments[route.id] ?? 0) + 1;

    final booking = Booking(
      id: _nextId('SH'),
      type: BookingType.shuttle,
      titleZh: route.routeNameZh,
      titleEn: route.routeNameEn,
      timeZh: route.nextDepartureTime,
      timeEn: route.nextDepartureTime,
      status: BookingStatus.reserved,
      createdAt: DateTime.now(),
      detailsZh: '${route.startPointZh} → ${route.destinationZh}',
      detailsEn: '${route.startPointEn} → ${route.destinationEn}',
      passengerName: 'Kevin Tan',
      isMine: true,
    );

    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  Booking reserveParking(ParkingZone zone, {String? slotLabel}) {
    final remainingSlots = availableSlotsForZone(zone);
    if (remainingSlots <= 0) {
      throw StateError('No parking slots are available for this zone right now.');
    }

    final selectedSlot = slotLabel ?? firstAvailableSlotForZone(zone);
    if (selectedSlot == null || (_reservedParkingSlots[zone.id] ?? <String>{}).contains(selectedSlot)) {
      throw StateError('The selected parking slot is not available.');
    }

    _parkingAvailabilityOverrides[zone.id] = remainingSlots - 1;
    _reservedParkingSlots.putIfAbsent(zone.id, () => <String>{}).add(selectedSlot);

    final booking = Booking(
      id: _nextId('PK'),
      type: BookingType.parking,
      titleZh: zone.zoneNameZh,
      titleEn: zone.zoneNameEn,
      timeZh: '今天',
      timeEn: 'Today',
      status: BookingStatus.reserved,
      createdAt: DateTime.now(),
      detailsZh: '${zone.distanceZh} • ${zone.locationZh} • 车位 $selectedSlot',
      detailsEn: '${zone.distanceEn} • ${zone.locationEn} • Slot $selectedSlot',
      passengerName: 'Kevin Tan',
      isMine: true,
    );

    _bookings.insert(0, booking);
    notifyListeners();
    return booking;
  }

  void cancelBooking(String bookingId) {
    _updateStatus(bookingId, BookingStatus.cancelled);
  }

  void checkInPassenger(String bookingId) {
    _updateStatus(bookingId, BookingStatus.checkedIn);
  }

  void completeBooking(String bookingId) {
    _updateStatus(bookingId, BookingStatus.completed);
  }

  void _updateStatus(String bookingId, BookingStatus status) {
    final index = _bookings.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    _bookings[index] = _bookings[index].copyWith(status: status);
    notifyListeners();
  }

  String _nextId(String prefix) {
    _serial += 1;
    return '$prefix-${DateTime.now().millisecondsSinceEpoch}-${_serial}';
  }

  List<Booking> get _seedBookings => [
        Booking(
          id: 'SH-LOCAL-1001',
          type: BookingType.shuttle,
          titleZh: DemoDataService.mainGateRoute.routeNameZh,
          titleEn: DemoDataService.mainGateRoute.routeNameEn,
          timeZh: DemoDataService.mainGateRoute.nextDepartureTime,
          timeEn: DemoDataService.mainGateRoute.nextDepartureTime,
          status: BookingStatus.reserved,
          createdAt: DateTime.now().subtract(const Duration(minutes: 24)),
          detailsZh: '${DemoDataService.mainGateRoute.startPointZh} → ${DemoDataService.mainGateRoute.destinationZh}',
          detailsEn: '${DemoDataService.mainGateRoute.startPointEn} → ${DemoDataService.mainGateRoute.destinationEn}',
          passengerName: 'Kevin Tan',
          isMine: true,
        ),
        Booking(
          id: 'SH-LOCAL-1002',
          type: BookingType.shuttle,
          titleZh: DemoDataService.libraryRoute.routeNameZh,
          titleEn: DemoDataService.libraryRoute.routeNameEn,
          timeZh: DemoDataService.libraryRoute.nextDepartureTime,
          timeEn: DemoDataService.libraryRoute.nextDepartureTime,
          status: BookingStatus.checkedIn,
          createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
          detailsZh: '${DemoDataService.libraryRoute.startPointZh} → ${DemoDataService.libraryRoute.destinationZh}',
          detailsEn: '${DemoDataService.libraryRoute.startPointEn} → ${DemoDataService.libraryRoute.destinationEn}',
          passengerName: 'Aina Rahman',
          isMine: false,
        ),
        Booking(
          id: 'SH-LOCAL-1003',
          type: BookingType.shuttle,
          titleZh: DemoDataService.parkingRoute.routeNameZh,
          titleEn: DemoDataService.parkingRoute.routeNameEn,
          timeZh: DemoDataService.parkingRoute.nextDepartureTime,
          timeEn: DemoDataService.parkingRoute.nextDepartureTime,
          status: BookingStatus.reserved,
          createdAt: DateTime.now().subtract(const Duration(minutes: 16)),
          detailsZh: '${DemoDataService.parkingRoute.startPointZh} → ${DemoDataService.parkingRoute.destinationZh}',
          detailsEn: '${DemoDataService.parkingRoute.startPointEn} → ${DemoDataService.parkingRoute.destinationEn}',
          passengerName: 'Daniel Lee',
          isMine: false,
        ),
        Booking(
          id: 'PK-LOCAL-1004',
          type: BookingType.parking,
          titleZh: DemoDataService.parkingZones[1].zoneNameZh,
          titleEn: DemoDataService.parkingZones[1].zoneNameEn,
          timeZh: '今天',
      timeEn: 'Today',
          status: BookingStatus.reserved,
          createdAt: DateTime.now().subtract(const Duration(minutes: 9)),
          detailsZh: '${DemoDataService.parkingZones[1].distanceZh} • ${DemoDataService.parkingZones[1].locationZh} • 车位 B03',
          detailsEn: '${DemoDataService.parkingZones[1].distanceEn} • ${DemoDataService.parkingZones[1].locationEn} • Slot B03',
          passengerName: 'Kevin Tan',
          isMine: true,
        ),
      ];
}

class BookingScope extends InheritedNotifier<BookingService> {
  const BookingScope({
    super.key,
    required BookingService notifier,
    required super.child,
  }) : super(notifier: notifier);

  static BookingService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BookingScope>();
    assert(scope != null, 'BookingScope was not found above this context.');
    return scope!.notifier!;
  }
}
