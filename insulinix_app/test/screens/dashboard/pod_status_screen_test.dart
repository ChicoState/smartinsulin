import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:smart_insulin_app/controllers/bluetooth_controller.dart';
import 'package:smart_insulin_app/screens/dashboard/pod_status_screen.dart';

// Create a mock BluetoothController
class MockBluetoothController extends Mock implements BluetoothController {
  BleConnectionState _mockConnectionState = BleConnectionState.disconnected;
  Stream<List<int>> _mockReceivedDataStream = const Stream.empty();

  @override
  BleConnectionState get connectionState => _mockConnectionState;

  @override
  Stream<List<int>> get receivedDataStream => _mockReceivedDataStream;

  // Setters for tests to control behavior
  set mockConnectionState(BleConnectionState newState) {
    _mockConnectionState = newState;
  }

  set mockReceivedDataStream(Stream<List<int>> stream) {
    _mockReceivedDataStream = stream;
  }
}

void main() {
  late MockBluetoothController mockController;

  setUp(() {
    mockController = MockBluetoothController();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<BluetoothController>(
        create: (_) => mockController,
        child: const PodStatusScreen(),
      ),
    );
  }

  testWidgets('Displays "No device connected" when disconnected', (
    WidgetTester tester,
  ) async {
    mockController.mockConnectionState = BleConnectionState.disconnected;
    //when(mockController.connectionState).thenReturn(BleConnectionState.disconnected); // REMOVE THIS LINE

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('No device connected'), findsOneWidget);
  });

  testWidgets('Displays loading state initially', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;
    //when(mockController.connectionState).thenReturn(BleConnectionState.connected); // REMOVE THIS LINE

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Loading...'), findsNWidgets(2));
  });

  

  testWidgets('Displays "Stream Error" on stream error', (
    WidgetTester tester,
  ) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // Set the mock stream to throw an error
    mockController.mockReceivedDataStream = Stream.error('Test error');

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Stream Error'), findsNWidgets(2));
  });

  testWidgets('Displays "No device connected" overlay with correct style', (
    WidgetTester tester,
  ) async {
    mockController.mockConnectionState = BleConnectionState.disconnected;

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final textFinder = find.text('No device connected');
    expect(textFinder, findsOneWidget);

    final textWidget = tester.widget<Text>(textFinder);
    expect(textWidget.style?.color, Colors.white);
    expect(textWidget.style?.fontSize, 20.0);
    expect(textWidget.style?.fontWeight, FontWeight.bold);
  });

  testWidgets('Displays received data correctly', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [8, 120],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Low'), findsOneWidget);
    expect(find.text('Mid'), findsOneWidget);
  });

  testWidgets('Displays detailed pod data Low/Mid', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;
    // Simulate receiving JSON data
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [10, 120],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Low'), findsOneWidget);
    expect(find.text('Mid'), findsOneWidget);
  });

  testWidgets('Displays detailed pod data Low/High', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [10, 200],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Low'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
  });

  testWidgets('Displays detailed pod data Mid/Low', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [60, 10],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Mid'), findsOneWidget);
    expect(find.text('Low'), findsOneWidget);
  });

  testWidgets('Displays detailed pod data High/Mid', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [80, 120],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('High'), findsOneWidget);
    expect(find.text('Mid'), findsOneWidget);
  });

  testWidgets('Displays detailed pod data Mid/High', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [60, 200],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Mid'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
  });

  testWidgets('Displays detailed pod data High/High', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [100, 200],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('High'), findsNWidgets(2));
  });

  testWidgets('Displays detailed pod data Low/Low', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [10, 5],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Low'), findsNWidgets(2));
  });

  testWidgets('Displays detailed pod data Mid/Mid', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [60, 120],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Mid'), findsNWidgets(2));
  });

  testWidgets('Battery edge case set 300%', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [300, 200],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('High'), findsNWidgets(2));
  });

  testWidgets('Pods edge case set 300mil (more then max 200)', (WidgetTester tester) async {
    mockController.mockConnectionState = BleConnectionState.connected;

    // ✅ Set the mock stream directly using the custom setter
    mockController.mockReceivedDataStream = Stream.fromIterable([
      [100, 300],
    ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('High'), findsNWidgets(2));
  });
}
