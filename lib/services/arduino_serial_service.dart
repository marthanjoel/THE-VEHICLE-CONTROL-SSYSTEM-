import 'dart:async';
import 'dart:typed_data';

import 'package:flserial/flserial.dart';

class ArduinoSerialService {
  ArduinoSerialService._();

  static final ArduinoSerialService instance =
      ArduinoSerialService._();

  final FlSerial _serial = FlSerial();

  StreamSubscription<SerialEvent>? _subscription;

  final StreamController<String> _dataController =
      StreamController<String>.broadcast();

  Stream<String> get receivedData => _dataController.stream;

  bool _connected = false;
  String? _connectedPort;

  bool get isConnected => _connected;
  String? get connectedPort => _connectedPort;

  Future<List<String>> scanPorts() async {
    final ports = await FlSerial.availablePorts();

    return ports.map((port) => port.path.toString()).toList();
  }

  Future<bool> connect(
    String portPath, {
    int baudRate = 115200,
  }) async {
    await _subscription?.cancel();

    _subscription = _serial.events.listen((event) {
      switch (event.type) {
        case SerialEventType.connected:
          _connected = true;
          _connectedPort = portPath;
          break;

        case SerialEventType.data:
          final data = event.data;

          if (data is Uint8List) {
            _dataController.add(
              String.fromCharCodes(data),
            );
          } else if (data != null) {
            _dataController.add(data.toString());
          }
          break;

        case SerialEventType.disconnected:
          _connected = false;
          _connectedPort = null;
          break;

        case SerialEventType.error:
          _dataController.add(
            'ERROR: ${event.data}',
          );
          break;

        default:
          break;
      }
    });

    final config = SerialConfig(
      baudRate: baudRate,
      dataBits: 8,
      stopBits: 1,
      parity: 0,
      flowControl: 0,
    );

    final success = await _serial.open(
      portPath,
      config,
    );

    if (success) {
      _connected = true;
      _connectedPort = portPath;
    }

    return success;
  }

  void send(String command) {
    if (!_connected) {
      return;
    }

    final message = '$command\n';

    _serial.write(
      Uint8List.fromList(
        message.codeUnits,
      ),
    );
  }

  void sendSystemCommand(
    String system,
    String action,
  ) {
    send('$system:$action');
  }

  Future<void> disconnect() async {
    await _serial.close();

    _connected = false;
    _connectedPort = null;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _serial.close();
    await _serial.dispose();
    await _dataController.close();
  }
}