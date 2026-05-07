import 'package:flutter/material.dart';

export 'app_language.dart';

import 'app_language.dart';

import '../../models/booking.dart';
import '../../models/parking_zone.dart';
import '../../models/shuttle_route.dart';

class LanguageService extends ChangeNotifier {
  AppLanguage _language = AppLanguage.zh;

  AppLanguage get language => _language;
  AppStrings get strings => AppStrings(_language);

  void toggle() {
    _language = _language == AppLanguage.zh ? AppLanguage.en : AppLanguage.zh;
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }
}

class AppLanguageScope extends InheritedNotifier<LanguageService> {
  const AppLanguageScope({
    super.key,
    required LanguageService notifier,
    required super.child,
  }) : super(notifier: notifier);

  static LanguageService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    assert(scope != null, 'AppLanguageScope was not found above this context.');
    return scope!.notifier!;
  }

  static AppLanguage languageOf(BuildContext context) => of(context).language;

  static AppStrings stringsOf(BuildContext context) => of(context).strings;
}

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get isZh => language == AppLanguage.zh;

  String text(String zh, String en) => isZh ? zh : en;

  String get appTitle => 'Flutter-Campus-Shuttle-App';
  String get appShortTitle => 'Campus Shuttle';
  String get loginSubtitle => text(
        '一个校园交通 Demo，用来展示校车路线、停车位和预约管理。',
        'A campus transport demo for shuttle routes, parking, and bookings.',
      );
  String get demoNote => text(
        '当前为演示模式，数据来自本地示例，地图路线按平均车速回放。',
        'Demo mode only. This app uses local data and route playback based on average speed.',
      );
  String get chooseRole => text('选择一个角色进入', 'Choose a role to continue');
  String get studentRole => text('学生端', 'Student');
  String get driverRole => text('司机端', 'Driver');
  String get adminRole => text('管理端', 'Admin');
  String get continueAsStudent => text('以学生身份进入', 'Continue as Student');
  String get continueAsDriver => text('以司机身份进入', 'Continue as Driver');
  String get continueAsAdmin => text('以管理员身份进入', 'Continue as Admin');
  String get studentRoleDesc => text(
        '查看校车路线、预约座位、查看停车位，并管理自己的交通预约。',
        'Browse shuttle routes, book seats, reserve parking, and manage bookings.',
      );
  String get driverRoleDesc => text(
        '查看分配路线、乘客列表，并操作模拟校车轨迹。',
        'View assigned routes, passenger lists, and simulated shuttle tracking.',
      );
  String get adminRoleDesc => text(
        '查看交通总览、预约状态、停车占用和路线运行情况。',
        'Review routes, bookings, parking occupancy, and transport status.',
      );

  String get dashboard => text('控制台', 'Dashboard');
  String get studentDashboard => text('学生端', 'Student Dashboard');
  String get driverDashboard => text('司机端', 'Driver Dashboard');
  String get adminDashboard => text('管理端', 'Admin Dashboard');
  String get welcomeBack => text('欢迎回来', 'Welcome back');
  String get todayOverview => text('今日交通概览', 'Today’s transport overview');
  String get quickAccess => text('快速入口', 'Quick access');
  String get switchRole => text('切换角色', 'Switch role');

  String get shuttleRoutes => text('校车路线', 'Shuttle Routes');
  String get routeDetail => text('路线详情', 'Route Detail');
  String get parkingZones => text('停车区域', 'Parking Zones');
  String get myBookings => text('我的预约', 'My Bookings');
  String get transportNotices => text('交通通知', 'Transport Notices');
  String get mapTracking => text('校车路线回放', 'Shuttle Route Playback');
  String get assignedRoute => text('分配路线', 'Assigned Route');
  String get passengerList => text('乘客列表', 'Passenger List');
  String get transportOverview => text('交通总览', 'Transport Overview');
  String get routesOverview => text('路线总览', 'Routes Overview');
  String get bookingsOverview => text('预约总览', 'Bookings Overview');
  String get parkingOverview => text('停车总览', 'Parking Overview');

  String get viewMap => text('查看地图轨迹', 'View Map Tracking');
  String get bookSeat => text('预约座位', 'Book Seat');
  String get cancelBooking => text('取消预约', 'Cancel Booking');
  String get reserveSlot => text('预约车位', 'Reserve Slot');
  String get viewBookings => text('查看我的预约', 'View My Bookings');
  String get keepBooking => text('保留预约', 'Keep Booking');
  String get confirm => text('确认', 'Confirm');
  String get close => text('关闭', 'Close');
  String get continueText => text('继续', 'Continue');
  String get startSimulation => text('开始运行', 'Start Route');
  String get pause => text('暂停', 'Pause');
  String get reset => text('重置', 'Reset');
  String get markArrived => text('标记为已到达', 'Mark as Arrived');
  String get checkIn => text('签到', 'Check In');
  String get markCompleted => text('标记完成', 'Mark Completed');

  String get totalRoutes => text('路线数量', 'Total Routes');
  String get activeBookings => text('当前预约', 'Active Bookings');
  String get parkingOccupancy => text('停车占用情况', 'Parking Occupancy');
  String get delayedShuttles => text('延误校车', 'Delayed Shuttles');
  String get todayPassengers => text('今日乘客', 'Today’s Passengers');
  String get availableSeats => text('余座', 'Available Seats');
  String get availableSlots => text('余位', 'Available Slots');
  String get nextDeparture => text('下一班', 'Next Departure');
  String get estimatedDuration => text('预计用时', 'Estimated Duration');
  String get stops => text('站点', 'Stops');
  String get currentStop => text('当前站点', 'Current Stop');
  String get nextStop => text('下一站', 'Next Stop');
  String get eta => text('预计到达', 'ETA');
  String get routeStatus => text('路线状态', 'Route Status');
  String get bus => text('车辆', 'Bus');
  String get direction => text('方向', 'Direction');
  String get distance => text('距离', 'Distance');
  String get averageSpeed => text('平均车速', 'Average Speed');
  String get beijingTime => text('北京时间', 'Beijing Time');
  String get routeFilter => text('筛选路线', 'Filter Routes');
  String get allRoutes => text('全部路线', 'All Routes');
  String get selectRoute => text('选择路线', 'Select Route');
  String get playbackSpeedNote => text('按平均校车车速运行，时间不压缩。', 'Runs at average shuttle speed without time compression.');
  String get selectedSlot => text('已选车位', 'Selected Slot');
  String get chooseSlot => text('请选择车位', 'Choose a slot');
  String get occupied => text('已占用', 'Occupied');
  String get free => text('空位', 'Free');
  String get sharedStateNote => text('学生端创建的预约会同步显示在司机端和管理端。', 'Bookings created by students are visible in the driver and admin views.');
  String get bookingId => text('预约编号', 'Booking ID');
  String get createdAt => text('创建时间', 'Created');
  String get status => text('状态', 'Status');
  String get passenger => text('乘客', 'Passenger');
  String get type => text('类型', 'Type');

  String get studentHeroText => text(
        '查看下一班校车，预约车位，并把校车和停车预约放在同一个页面管理。',
        'Check the next shuttle, reserve parking, and manage transport bookings in one place.',
      );
  String get driverHeroText => text(
        '这里展示今日分配路线、乘客签到和模拟行驶状态，方便说明司机端的基本工作流。',
        'This view shows assigned routes, passenger check-in, and simulated driving status.',
      );
  String get adminHeroText => text(
        '这里用本地示例数据汇总路线、预约、停车和通知状态，展示一个轻量管理端视角。',
        'This view summarizes routes, bookings, parking, and notices with local demo data.',
      );
  String get mapNote => text(
        '路线基于本地示例坐标和平均车速回放，不是真实 GPS 追踪。',
        'The route is replayed from local sample coordinates and average shuttle speed, not real GPS tracking.',
      );
  String get emptyBookings => text('还没有预约', 'No bookings yet');
  String get emptyBookingsDesc => text(
        '预约校车座位或停车位后，记录会显示在这里。取消后不会删除，只会变成已取消。',
        'Book a shuttle seat or parking slot to see it here. Cancelled items remain visible.',
      );
  String get bookingConfirmed => text('预约成功', 'Booking Confirmed');
  String get parkingReserved => text('车位已预约', 'Parking Reserved');
  String get cancelBookingTitle => text('取消这个预约？', 'Cancel this booking?');
  String get cancelBookingMessage => text(
        '取消后状态会变成已取消，记录仍会保留在我的预约中。',
        'The status will change to Cancelled and the record will remain visible.',
      );
  String get noSeats => text('这条路线暂时没有余座。', 'No seats are available for this route right now.');
  String get noSlots => text('这个区域暂时没有可预约车位。', 'No parking slots are available for this zone right now.');
  String get checkInDone => text('乘客已签到。', 'Passenger checked in.');
  String get completedDone => text('预约已标记为完成。', 'Booking marked as completed.');
  String get arrivedDone => text('路线已标记为已到达。', 'Route marked as arrived.');

  String get localDataExplanation => text(
        '页面数据来自本地示例，用来展示移动端流程和状态变化。',
        'Data comes from local examples to show mobile flow and state changes.',
      );
  String get routeBrowsingDesc => text(
        '查看示例校车路线、下一班时间、余座和状态。',
        'Browse sample shuttle routes, next departures, seats, and status.',
      );
  String get parkingDesc => text(
        '查看每个停车区域的余位、总车位和位置说明。',
        'Check available slots, total capacity, and location notes by zone.',
      );
  String get noticesDesc => text(
        '这些是示例交通通知，不是官方真实通知。',
        'These are sample transport notices, not official announcements.',
      );
  String get passengerListDesc => text(
        '司机可以把已预约的校车乘客标记为已签到。',
        'Drivers can mark reserved shuttle passengers as checked in.',
      );
  String get assignedRouteDesc => text(
        '展示司机今日需要处理的示例路线和检查点。',
        'Shows sample assigned routes and checkpoints for the driver role.',
      );

  String bookingStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.reserved:
        return text('已预约', 'Reserved');
      case BookingStatus.checkedIn:
        return text('已签到', 'Checked In');
      case BookingStatus.completed:
        return text('已完成', 'Completed');
      case BookingStatus.cancelled:
        return text('已取消', 'Cancelled');
    }
  }

  String bookingType(BookingType type) {
    switch (type) {
      case BookingType.shuttle:
        return text('校车座位', 'Shuttle Seat');
      case BookingType.parking:
        return text('停车位', 'Parking Slot');
    }
  }

  String routeStatusLabel(RouteStatus status) {
    switch (status) {
      case RouteStatus.onTime:
        return text('准点', 'On Time');
      case RouteStatus.limitedSeats:
        return text('余座较少', 'Limited Seats');
      case RouteStatus.delayed:
        return text('延误', 'Delayed');
      case RouteStatus.arrived:
        return text('已到达', 'Arrived');
    }
  }

  String parkingStatus(ParkingStatus status) {
    switch (status) {
      case ParkingStatus.available:
        return text('可预约', 'Available');
      case ParkingStatus.limited:
        return text('余位较少', 'Limited');
      case ParkingStatus.full:
        return text('已满', 'Full');
    }
  }

  String get simulated => text('模拟', 'Simulated');
  String get onRoute => text('行驶中', 'On Route');
  String get paused => text('已暂停', 'Paused');
  String get arrived => text('已到达', 'Arrived');
  String get notStarted => text('未开始', 'Not Started');
}
