import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_campus_shuttle_app/main.dart';

void main() {
  testWidgets('App loads role entry screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterCampusShuttleApp());
    expect(find.text('Flutter Campus Shuttle App'), findsOneWidget);
    expect(find.text('以学生身份进入'), findsOneWidget);
    expect(find.text('以司机身份进入'), findsOneWidget);
    expect(find.text('以管理员身份进入'), findsOneWidget);
  });
}
