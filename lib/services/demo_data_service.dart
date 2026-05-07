import '../models/driver_trip.dart';
import '../models/parking_zone.dart';
import '../models/shuttle_route.dart';
import '../models/transport_notice.dart';

class DemoDataService {
  DemoDataService._();

  static const List<RoutePoint> bukitToStellarPath = [
    RoutePoint(3.058140, 101.692210),
    RoutePoint(3.058700, 101.693260),
    RoutePoint(3.060050, 101.694380),
    RoutePoint(3.062180, 101.695800),
    RoutePoint(3.064650, 101.697160),
    RoutePoint(3.067250, 101.698500),
    RoutePoint(3.069880, 101.699880),
    RoutePoint(3.071500, 101.700860),
    RoutePoint(3.072676, 101.701597),
  ];

  static const List<RoutePoint> stellarToBukitPath = [
    RoutePoint(3.072676, 101.701597),
    RoutePoint(3.071250, 101.700680),
    RoutePoint(3.069350, 101.699480),
    RoutePoint(3.066800, 101.698150),
    RoutePoint(3.064100, 101.696780),
    RoutePoint(3.061600, 101.695380),
    RoutePoint(3.059350, 101.693850),
    RoutePoint(3.058140, 101.692210),
  ];

  static const List<RoutePoint> mrtToStellarPath = [
    RoutePoint(3.077397, 101.699672),
    RoutePoint(3.076680, 101.699940),
    RoutePoint(3.075600, 101.700280),
    RoutePoint(3.074320, 101.700760),
    RoutePoint(3.073420, 101.701200),
    RoutePoint(3.072676, 101.701597),
  ];

  static const List<RoutePoint> stellarToMrtPath = [
    RoutePoint(3.072676, 101.701597),
    RoutePoint(3.073600, 101.701170),
    RoutePoint(3.074650, 101.700650),
    RoutePoint(3.075820, 101.700220),
    RoutePoint(3.076720, 101.699910),
    RoutePoint(3.077397, 101.699672),
  ];

  static const List<RoutePoint> bukitToMrtPath = [
    RoutePoint(3.058140, 101.692210),
    RoutePoint(3.059650, 101.693700),
    RoutePoint(3.062100, 101.695550),
    RoutePoint(3.065100, 101.697400),
    RoutePoint(3.068250, 101.699000),
    RoutePoint(3.071000, 101.700300),
    RoutePoint(3.072676, 101.701597),
    RoutePoint(3.074400, 101.700900),
    RoutePoint(3.076100, 101.700100),
    RoutePoint(3.077397, 101.699672),
  ];

  static const List<RoutePoint> mrtToBukitPath = [
    RoutePoint(3.077397, 101.699672),
    RoutePoint(3.076050, 101.700120),
    RoutePoint(3.074200, 101.700980),
    RoutePoint(3.072676, 101.701597),
    RoutePoint(3.070650, 101.700120),
    RoutePoint(3.067850, 101.698720),
    RoutePoint(3.064750, 101.697180),
    RoutePoint(3.061900, 101.695450),
    RoutePoint(3.059500, 101.693800),
    RoutePoint(3.058140, 101.692210),
  ];

  static const ShuttleRoute bukitToStellar = ShuttleRoute(
    id: 'lrt-bukit-stellar-out',
    routeGroupId: 'bukit-stellar',
    routeGroupZh: 'Bukit Jalil LRT ↔ 8th & Stellar',
    routeGroupEn: 'Bukit Jalil LRT ↔ 8th & Stellar',
    directionZh: '去程',
    directionEn: 'Outbound',
    busCode: 'BJ-01',
    routeNameZh: 'Bukit Jalil LRT 至 8th & Stellar',
    routeNameEn: 'Bukit Jalil LRT to 8th & Stellar',
    startPointZh: 'LRT Bukit Jalil 站',
    startPointEn: 'Bukit Jalil LRT Station',
    destinationZh: '8th & Stellar @ Sri Petaling',
    destinationEn: '8th & Stellar @ Sri Petaling',
    nextDepartureTime: '08:10',
    estimatedDurationZh: '约 7 分钟',
    estimatedDurationEn: 'About 7 min',
    availableSeats: 18,
    status: RouteStatus.onTime,
    stopsZh: ['LRT Bukit Jalil 站', 'Sri Petaling 商圈', '8th & Stellar'],
    stopsEn: ['Bukit Jalil LRT Station', 'Sri Petaling Shops', '8th & Stellar'],
    noteZh: '路线点位按公开地图位置手动整理，行驶回放按平均校车车速计算。',
    noteEn: 'The route path is hand-mapped from public map locations and replayed using average shuttle speed.',
    path: bukitToStellarPath,
    distanceKm: 2.55,
    averageSpeedKmh: 22,
  );

  static const ShuttleRoute stellarToBukit = ShuttleRoute(
    id: 'lrt-bukit-stellar-return',
    routeGroupId: 'bukit-stellar',
    routeGroupZh: 'Bukit Jalil LRT ↔ 8th & Stellar',
    routeGroupEn: 'Bukit Jalil LRT ↔ 8th & Stellar',
    directionZh: '返程',
    directionEn: 'Return',
    busCode: 'BJ-02',
    routeNameZh: '8th & Stellar 至 Bukit Jalil LRT',
    routeNameEn: '8th & Stellar to Bukit Jalil LRT',
    startPointZh: '8th & Stellar @ Sri Petaling',
    startPointEn: '8th & Stellar @ Sri Petaling',
    destinationZh: 'LRT Bukit Jalil 站',
    destinationEn: 'Bukit Jalil LRT Station',
    nextDepartureTime: '08:25',
    estimatedDurationZh: '约 7 分钟',
    estimatedDurationEn: 'About 7 min',
    availableSeats: 16,
    status: RouteStatus.onTime,
    stopsZh: ['8th & Stellar', 'Sri Petaling 商圈', 'LRT Bukit Jalil 站'],
    stopsEn: ['8th & Stellar', 'Sri Petaling Shops', 'Bukit Jalil LRT Station'],
    noteZh: '与去程配对，方便在学生端、司机端和管理端查看双向班车。',
    noteEn: 'Paired with the outbound trip so each corridor has one outbound and one return shuttle.',
    path: stellarToBukitPath,
    distanceKm: 2.55,
    averageSpeedKmh: 22,
  );

  static const ShuttleRoute mrtToStellar = ShuttleRoute(
    id: 'mrt-naga-stellar-out',
    routeGroupId: 'mrt-stellar',
    routeGroupZh: 'Taman Naga Emas MRT ↔ 8th & Stellar',
    routeGroupEn: 'Taman Naga Emas MRT ↔ 8th & Stellar',
    directionZh: '去程',
    directionEn: 'Outbound',
    busCode: 'TN-01',
    routeNameZh: 'Taman Naga Emas MRT 至 8th & Stellar',
    routeNameEn: 'Taman Naga Emas MRT to 8th & Stellar',
    startPointZh: 'MRT Taman Naga Emas 站',
    startPointEn: 'Taman Naga Emas MRT Station',
    destinationZh: '8th & Stellar @ Sri Petaling',
    destinationEn: '8th & Stellar @ Sri Petaling',
    nextDepartureTime: '09:00',
    estimatedDurationZh: '约 4 分钟',
    estimatedDurationEn: 'About 4 min',
    availableSeats: 11,
    status: RouteStatus.limitedSeats,
    stopsZh: ['MRT Taman Naga Emas 站', 'Jalan Naga Emas', '8th & Stellar'],
    stopsEn: ['Taman Naga Emas MRT Station', 'Jalan Naga Emas', '8th & Stellar'],
    noteZh: '短距离接驳线，适合展示余座较少和快速预约。',
    noteEn: 'A short connector route for showing limited seats and quick booking.',
    path: mrtToStellarPath,
    distanceKm: 0.86,
    averageSpeedKmh: 18,
  );

  static const ShuttleRoute stellarToMrt = ShuttleRoute(
    id: 'mrt-naga-stellar-return',
    routeGroupId: 'mrt-stellar',
    routeGroupZh: 'Taman Naga Emas MRT ↔ 8th & Stellar',
    routeGroupEn: 'Taman Naga Emas MRT ↔ 8th & Stellar',
    directionZh: '返程',
    directionEn: 'Return',
    busCode: 'TN-02',
    routeNameZh: '8th & Stellar 至 Taman Naga Emas MRT',
    routeNameEn: '8th & Stellar to Taman Naga Emas MRT',
    startPointZh: '8th & Stellar @ Sri Petaling',
    startPointEn: '8th & Stellar @ Sri Petaling',
    destinationZh: 'MRT Taman Naga Emas 站',
    destinationEn: 'Taman Naga Emas MRT Station',
    nextDepartureTime: '09:15',
    estimatedDurationZh: '约 4 分钟',
    estimatedDurationEn: 'About 4 min',
    availableSeats: 13,
    status: RouteStatus.onTime,
    stopsZh: ['8th & Stellar', 'Jalan Naga Emas', 'MRT Taman Naga Emas 站'],
    stopsEn: ['8th & Stellar', 'Jalan Naga Emas', 'Taman Naga Emas MRT Station'],
    noteZh: '短距离返程班车，地图回放使用同一段道路的反向路线。',
    noteEn: 'Return shuttle on the same local corridor using the reverse path.',
    path: stellarToMrtPath,
    distanceKm: 0.86,
    averageSpeedKmh: 18,
  );

  static const ShuttleRoute bukitToMrt = ShuttleRoute(
    id: 'bukit-mrt-out',
    routeGroupId: 'bukit-mrt',
    routeGroupZh: 'Bukit Jalil LRT ↔ Taman Naga Emas MRT',
    routeGroupEn: 'Bukit Jalil LRT ↔ Taman Naga Emas MRT',
    directionZh: '去程',
    directionEn: 'Outbound',
    busCode: 'BM-01',
    routeNameZh: 'Bukit Jalil LRT 至 Taman Naga Emas MRT',
    routeNameEn: 'Bukit Jalil LRT to Taman Naga Emas MRT',
    startPointZh: 'LRT Bukit Jalil 站',
    startPointEn: 'Bukit Jalil LRT Station',
    destinationZh: 'MRT Taman Naga Emas 站',
    destinationEn: 'Taman Naga Emas MRT Station',
    nextDepartureTime: '10:20',
    estimatedDurationZh: '约 10 分钟',
    estimatedDurationEn: 'About 10 min',
    availableSeats: 20,
    status: RouteStatus.onTime,
    stopsZh: ['LRT Bukit Jalil 站', '8th & Stellar', 'MRT Taman Naga Emas 站'],
    stopsEn: ['Bukit Jalil LRT Station', '8th & Stellar', 'Taman Naga Emas MRT Station'],
    noteZh: '连接两侧轨道站点，中途经过 Sri Petaling 的 8th & Stellar。',
    noteEn: 'Connects the two rail stations with a mid-stop at 8th & Stellar.',
    path: bukitToMrtPath,
    distanceKm: 3.30,
    averageSpeedKmh: 23,
  );

  static const ShuttleRoute mrtToBukit = ShuttleRoute(
    id: 'bukit-mrt-return',
    routeGroupId: 'bukit-mrt',
    routeGroupZh: 'Bukit Jalil LRT ↔ Taman Naga Emas MRT',
    routeGroupEn: 'Bukit Jalil LRT ↔ Taman Naga Emas MRT',
    directionZh: '返程',
    directionEn: 'Return',
    busCode: 'BM-02',
    routeNameZh: 'Taman Naga Emas MRT 至 Bukit Jalil LRT',
    routeNameEn: 'Taman Naga Emas MRT to Bukit Jalil LRT',
    startPointZh: 'MRT Taman Naga Emas 站',
    startPointEn: 'Taman Naga Emas MRT Station',
    destinationZh: 'LRT Bukit Jalil 站',
    destinationEn: 'Bukit Jalil LRT Station',
    nextDepartureTime: '10:40',
    estimatedDurationZh: '约 10 分钟',
    estimatedDurationEn: 'About 10 min',
    availableSeats: 17,
    status: RouteStatus.delayed,
    stopsZh: ['MRT Taman Naga Emas 站', '8th & Stellar', 'LRT Bukit Jalil 站'],
    stopsEn: ['Taman Naga Emas MRT Station', '8th & Stellar', 'Bukit Jalil LRT Station'],
    noteZh: '用于展示延误状态和管理端路线监控。',
    noteEn: 'Used to show delayed route status and admin monitoring.',
    path: mrtToBukitPath,
    distanceKm: 3.30,
    averageSpeedKmh: 23,
  );

  // Backwards-compatible names used by older screens and seed data.
  static const ShuttleRoute mainGateRoute = bukitToStellar;
  static const ShuttleRoute libraryRoute = mrtToStellar;
  static const ShuttleRoute parkingRoute = bukitToMrt;
  static const ShuttleRoute sportsRoute = mrtToBukit;

  static const List<ShuttleRoute> shuttleRoutes = [
    bukitToStellar,
    stellarToBukit,
    mrtToStellar,
    stellarToMrt,
    bukitToMrt,
    mrtToBukit,
  ];

  static const List<ParkingZone> parkingZones = [
    ParkingZone(
      id: 'zone-a',
      zoneNameZh: 'A 区 - 8th & Stellar 访客区',
      zoneNameEn: 'Zone A - 8th & Stellar Visitors',
      availableSlots: 8,
      totalSlots: 24,
      distanceZh: '步行 2 分钟',
      distanceEn: '2 min walk',
      locationZh: '靠近 8th & Stellar 入口',
      locationEn: 'Near the 8th & Stellar entrance',
      slotPrefix: 'A',
    ),
    ParkingZone(
      id: 'zone-b',
      zoneNameZh: 'B 区 - Sri Petaling 商圈侧',
      zoneNameEn: 'Zone B - Sri Petaling Shops',
      availableSlots: 5,
      totalSlots: 18,
      distanceZh: '步行 4 分钟',
      distanceEn: '4 min walk',
      locationZh: '靠近 Jalan Naga Emas',
      locationEn: 'Near Jalan Naga Emas',
      slotPrefix: 'B',
    ),
    ParkingZone(
      id: 'zone-c',
      zoneNameZh: 'C 区 - LRT Bukit Jalil 接驳区',
      zoneNameEn: 'Zone C - Bukit Jalil LRT Connector',
      availableSlots: 3,
      totalSlots: 15,
      distanceZh: '步行 6 分钟',
      distanceEn: '6 min walk',
      locationZh: '适合换乘 LRT 的学生',
      locationEn: 'Useful for students transferring from LRT',
      slotPrefix: 'C',
    ),
    ParkingZone(
      id: 'zone-d',
      zoneNameZh: 'D 区 - Taman Naga Emas 备用区',
      zoneNameEn: 'Zone D - Taman Naga Emas Backup',
      availableSlots: 0,
      totalSlots: 12,
      distanceZh: '步行 7 分钟',
      distanceEn: '7 min walk',
      locationZh: '当前没有可预约车位',
      locationEn: 'No available slots at the moment',
      slotPrefix: 'D',
    ),
  ];

  static const List<TransportNotice> notices = [
    TransportNotice(
      id: 'notice-01',
      titleZh: 'Taman Naga Emas 返程线有轻微延误',
      titleEn: 'Taman Naga Emas return route is slightly delayed',
      categoryZh: '校车',
      categoryEn: 'Shuttle',
      messageZh: '示例通知：BM-02 可能比计划时间晚几分钟，用于展示延误提示。',
      messageEn: 'Sample notice: BM-02 may run a few minutes later than planned.',
      timeLabelZh: '今天 08:10',
      timeLabelEn: 'Today 08:10',
      severity: 'warning',
    ),
    TransportNotice(
      id: 'notice-02',
      titleZh: 'Sri Petaling 商圈侧停车位余量偏少',
      titleEn: 'Sri Petaling shop-side parking is getting limited',
      categoryZh: '停车',
      categoryEn: 'Parking',
      messageZh: '示例通知：B 区余位较少，可以优先查看 A 区或 C 区。',
      messageEn: 'Sample notice: Zone B has fewer available slots. Zone A or C may be better choices.',
      timeLabelZh: '今天 09:20',
      timeLabelEn: 'Today 09:20',
      severity: 'available',
    ),
    TransportNotice(
      id: 'notice-03',
      titleZh: '晚间班次预览',
      titleEn: 'Evening schedule preview',
      categoryZh: '班次',
      categoryEn: 'Schedule',
      messageZh: '示例通知：这里可以展示晚间或假期期间的班次变化。',
      messageEn: 'Sample notice: evening or holiday shuttle changes could be displayed here.',
      timeLabelZh: '示例',
      timeLabelEn: 'Preview',
      severity: 'notice',
    ),
    TransportNotice(
      id: 'notice-04',
      titleZh: '路线维护提示',
      titleEn: 'Route maintenance notice',
      categoryZh: '维护',
      categoryEn: 'Maintenance',
      messageZh: '示例通知：部分路线可以在管理端标记为维护或延误。',
      messageEn: 'Sample notice: selected routes can be marked as maintenance or delayed in a future version.',
      timeLabelZh: '本地示例',
      timeLabelEn: 'Local sample',
      severity: 'notice',
    ),
  ];

  static const List<DriverTrip> driverTrips = [
    DriverTrip(
      id: 'trip-01',
      route: bukitToStellar,
      pickupWindow: '08:05 - 08:15',
      passengerCount: 16,
      capacity: 20,
      status: RouteStatus.onTime,
      checkpointsZh: ['车辆检查', 'LRT Bukit Jalil 上车', '8th & Stellar 下车'],
      checkpointsEn: ['Vehicle check', 'Pickup at Bukit Jalil LRT', 'Drop-off at 8th & Stellar'],
    ),
    DriverTrip(
      id: 'trip-02',
      route: mrtToStellar,
      pickupWindow: '08:55 - 09:05',
      passengerCount: 11,
      capacity: 18,
      status: RouteStatus.limitedSeats,
      checkpointsZh: ['开放上车', 'Taman Naga Emas 上车', '8th & Stellar 到达'],
      checkpointsEn: ['Open boarding', 'Pickup at Taman Naga Emas', 'Arrive at 8th & Stellar'],
    ),
    DriverTrip(
      id: 'trip-03',
      route: mrtToBukit,
      pickupWindow: '10:35 - 10:45',
      passengerCount: 9,
      capacity: 16,
      status: RouteStatus.delayed,
      checkpointsZh: ['车辆检查', 'Taman Naga Emas 上车', 'Bukit Jalil LRT 下车'],
      checkpointsEn: ['Vehicle check', 'Pickup at Taman Naga Emas', 'Drop-off at Bukit Jalil LRT'],
    ),
  ];

  static int get totalAvailableParkingSlots => parkingZones.fold<int>(
        0,
        (total, zone) => total + zone.availableSlots,
      );

  static int get totalParkingCapacity => parkingZones.fold<int>(
        0,
        (total, zone) => total + zone.totalSlots,
      );

  static int get delayedRouteCount => shuttleRoutes
      .where((route) => route.status == RouteStatus.delayed)
      .length;
}
