import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flserial/flserial.dart';

class ArduinoConnectionScreen extends StatefulWidget {
  const ArduinoConnectionScreen({super.key});

  @override
  State<ArduinoConnectionScreen> createState() =>
      _ArduinoConnectionScreenState();
}

class _ArduinoConnectionScreenState
    extends State<ArduinoConnectionScreen> {
  final FlSerial _serial = FlSerial();

  List<String> _ports = [];
  String? _selectedPort;
  bool _connected = false;
  String _status = 'Not connected';
  final List<String> _receivedData = [];

  @override
  void initState() {
    super.initState();
    _listenForSerialEvents();
    _scanPorts();
  }

  void _listenForSerialEvents() {
    _serial.events.listen((event) {
      if (!mounted) return;

      switch (event.type) {
        case SerialEventType.connected:
          setState(() {
            _connected = true;
            _status = 'Arduino connected';
          });
          break;

        case SerialEventType.data:
          final data = String.fromCharCodes(
            event.data as List<int>,
          );

          setState(() {
            _receivedData.add(data);
          });
          break;

        case SerialEventType.disconnected:
          setState(() {
            _connected = false;
            _status = 'Arduino disconnected';
          });
          break;

        case SerialEventType.error:
          setState(() {
            _status = 'Serial error: ${event.data}';
          });
          break;

        case SerialEventType.lineStatusChanged:
          break;
      }
    });
  }

  Future<void> _scanPorts() async {
    try {
      final ports = await FlSerial.availablePorts();

      setState(() {
        _ports = ports.map((port) => port.path.toString()).toList();

        if (_ports.isNotEmpty) {
          _selectedPort = _ports.first;
          _status = '${_ports.length} port(s) found';
        } else {
          _selectedPort = null;
          _status = 'No Arduino/serial ports found';
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Scan error: $e';
      });
    }
  }

  Future<void> _connect() async {
    if (_selectedPort == null) {
      setState(() {
        _status = 'Select a port first';
      });
      return;
    }

    final config = SerialConfig(
      baudRate: 115200,
      dataBits: 8,
      stopBits: 1,
      parity: 0,
      flowControl: 0,
    );

    try {
      final success = await _serial.open(
        _selectedPort!,
        config,
      );

      if (!success && mounted) {
        setState(() {
          _status = 'Failed to connect';
          _connected = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'Connection error: $e';
          _connected = false;
        });
      }
    }
  }

  Future<void> _disconnect() async {
    await _serial.close();

    if (!mounted) return;

    setState(() {
      _connected = false;
      _status = 'Disconnected';
    });
  }

  void _sendTestCommand() {
    if (!_connected) {
      setState(() {
        _status = 'Connect Arduino first';
      });
      return;
    }

    const command = 'PING\n';

    _serial.write(
  Uint8List.fromList(command.codeUnits),
);

    setState(() {
      _status = 'Sent: PING';
    });
  }

  @override
  void dispose() {
    _serial.close();
    _serial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ARDUINO CONNECTION',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              _connected
                  ? Icons.usb
                  : Icons.usb_off,
              size: 90,
              color: _connected
                  ? Colors.green
                  : Colors.grey,
            ),

            const SizedBox(height: 15),

            Text(
              _connected
                  ? 'ARDUINO CONNECTED'
                  : 'ARDUINO NOT CONNECTED',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _connected
                    ? Colors.green
                    : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              _status,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'SERIAL PORT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _selectedPort,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Arduino Port',
                      ),
                      hint: const Text(
                        'Select Arduino port',
                      ),
                      items: _ports
                          .map(
                            (port) =>
                                DropdownMenuItem<String>(
                              value: port,
                              child: Text(port),
                            ),
                          )
                          .toList(),
                      onChanged: _connected
                          ? null
                          : (value) {
                              setState(() {
                                _selectedPort = value;
                              });
                            },
                    ),

                    const SizedBox(height: 15),

                    OutlinedButton.icon(
                      onPressed: _connected
                          ? null
                          : _scanPorts,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'SCAN FOR ARDUINO',
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _connected
                            ? _disconnect
                            : _connect,
                        icon: Icon(
                          _connected
                              ? Icons.link_off
                              : Icons.link,
                        ),
                        label: Text(
                          _connected
                              ? 'DISCONNECT ARDUINO'
                              : 'CONNECT ARDUINO',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'COMMUNICATION TEST',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: _connected
                          ? _sendTestCommand
                          : null,
                      icon: const Icon(Icons.send),
                      label: const Text(
                        'SEND PING',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ARDUINO RESPONSE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (_receivedData.isEmpty)
                      const Text(
                        'No data received yet.',
                      )
                    else
                      ..._receivedData.map(
                        (data) => Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 6,
                          ),
                          child: Text(data),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}