import 'package:flutter/material.dart';

class EnvironmentDashboard extends StatefulWidget {
  const EnvironmentDashboard({super.key});

  @override
  State<EnvironmentDashboard> createState() =>
      _EnvironmentDashboardState();
}

class _EnvironmentDashboardState
    extends State<EnvironmentDashboard> {
  double temperature = 28;
  double humidity = 65;

  bool flameDetected = false;
  bool hvacOn = false;
  bool buzzerOn = false;

  String get flameStatus {
    return flameDetected ? 'DANGER' : 'SAFE';
  }

  Color get flameColor {
    return flameDetected ? Colors.red : Colors.green;
  }

  void toggleHvac() {
    setState(() {
      hvacOn = !hvacOn;
    });
  }

  void toggleFlame() {
    setState(() {
      flameDetected = !flameDetected;
      buzzerOn = flameDetected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'VEHICLE ENVIRONMENT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.directions_car,
              size: 90,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            const Text(
              'ENVIRONMENT CONTROL SYSTEM',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: _sensorCard(
                    Icons.thermostat,
                    'TEMPERATURE',
                    '${temperature.toStringAsFixed(1)} °C',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _sensorCard(
                    Icons.water_drop,
                    'HUMIDITY',
                    '${humidity.toStringAsFixed(0)} %',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _statusCard(
              Icons.local_fire_department,
              'FLAME DETECTION',
              flameStatus,
              flameColor,
            ),

            const SizedBox(height: 15),

            _statusCard(
              Icons.ac_unit,
              'HVAC / RELAY',
              hvacOn ? 'ON' : 'OFF',
              hvacOn ? Colors.blue : Colors.grey,
            ),

            const SizedBox(height: 15),

            _statusCard(
              Icons.volume_up,
              'BUZZER',
              buzzerOn ? 'ON' : 'OFF',
              buzzerOn ? Colors.red : Colors.green,
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SYSTEM CONTROL',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: toggleHvac,
              icon: Icon(
                hvacOn
                    ? Icons.power_off
                    : Icons.ac_unit,
              ),
              label: Text(
                hvacOn
                    ? 'TURN HVAC OFF'
                    : 'TURN HVAC ON',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 55),
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: toggleFlame,
              icon: const Icon(
                Icons.local_fire_department,
              ),
              label: Text(
                flameDetected
                    ? 'CLEAR FLAME ALERT'
                    : 'SIMULATE FLAME ALERT',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 55),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'SENSOR SIMULATION',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Temperature: ${temperature.toStringAsFixed(1)} °C',
                    ),

                    Slider(
                      min: 15,
                      max: 45,
                      value: temperature,
                      onChanged: (value) {
                        setState(() {
                          temperature = value;
                        });
                      },
                    ),

                    Text(
                      'Humidity: ${humidity.toStringAsFixed(0)} %',
                    ),

                    Slider(
                      min: 0,
                      max: 100,
                      value: humidity,
                      onChanged: (value) {
                        setState(() {
                          humidity = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      flameDetected
                          ? Icons.error
                          : Icons.check_circle,
                      color: flameDetected
                          ? Colors.red
                          : Colors.green,
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      'SYSTEM STATUS: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      flameDetected
                          ? 'ALERT'
                          : 'NORMAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: flameDetected
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sensorCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusCard(
    IconData icon,
    String title,
    String status,
    Color color,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          size: 36,
          color: color,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        trailing: Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}