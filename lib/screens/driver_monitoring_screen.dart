import 'package:flutter/material.dart';

class DriverMonitoringHomePage extends StatefulWidget {
  const DriverMonitoringHomePage({super.key});

  @override
  State<DriverMonitoringHomePage> createState() =>
      _DriverMonitoringHomePageState();
}

class _DriverMonitoringHomePageState
    extends State<DriverMonitoringHomePage> {
  bool isMonitoring = false;

  int heartRate = 80;
  double temperature = 36.5;
  bool headTiltDetected = false;

  bool get heartRateNormal {
    return heartRate >= 50 && heartRate <= 120;
  }

  bool get temperatureNormal {
    return temperature <= 38.0;
  }

  bool get driverSafe {
    return isMonitoring &&
        heartRateNormal &&
        temperatureNormal &&
        !headTiltDetected;
  }

  String get driverStatus {
    if (!isMonitoring) {
      return 'MONITORING OFF';
    }

    if (driverSafe) {
      return 'DRIVER SAFE';
    }

    return 'DRIVER ALERT!';
  }

  Color get driverStatusColor {
    if (!isMonitoring) {
      return Colors.grey;
    }

    if (driverSafe) {
      return Colors.green;
    }

    return Colors.red;
  }

  IconData get driverStatusIcon {
    if (!isMonitoring) {
      return Icons.monitor_heart_outlined;
    }

    if (driverSafe) {
      return Icons.verified_user;
    }

    return Icons.warning_amber_rounded;
  }

  String get heartRateStatus {
    if (!isMonitoring) {
      return 'NOT MONITORED';
    }

    return heartRateNormal
        ? 'NORMAL'
        : 'ABNORMAL';
  }

  String get temperatureStatus {
    if (!isMonitoring) {
      return 'NOT MONITORED';
    }

    return temperatureNormal
        ? 'NORMAL'
        : 'HIGH';
  }

  String get headPositionStatus {
    if (!isMonitoring) {
      return 'NOT MONITORED';
    }

    return headTiltDetected
        ? 'HEAD TILT DETECTED'
        : 'NORMAL';
  }

  String get alertStatus {
    if (!isMonitoring) {
      return 'SYSTEM IS OFF';
    }

    if (driverSafe) {
      return 'NO ALERT';
    }

    return 'DRIVER ATTENTION REQUIRED!';
  }

  void toggleMonitoring() {
    setState(() {
      isMonitoring = !isMonitoring;

      if (!isMonitoring) {
        heartRate = 0;
        temperature = 0;
        headTiltDetected = false;
      } else {
        heartRate = 80;
        temperature = 36.5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'DRIVER MONITORING',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.directions_car,
                size: 90,
                color: Colors.blue,
              ),

              const SizedBox(height: 10),

              const Text(
                'DRIVER MONITORING & ALERT SYSTEM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset:
                          const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'DRIVER STATUS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: driverStatusColor
                            .withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        driverStatusIcon,
                        size: 45,
                        color: driverStatusColor,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      driverStatus,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: driverStatusColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              MonitoringCard(
                icon: Icons.favorite,
                title: 'HEART RATE',
                value: isMonitoring
                    ? '$heartRate BPM'
                    : '-- BPM',
                status: heartRateStatus,
                color: !isMonitoring
                    ? Colors.grey
                    : heartRateNormal
                        ? Colors.green
                        : Colors.red,
              ),

              const SizedBox(height: 15),

              MonitoringCard(
                icon: Icons.thermostat,
                title: 'BODY TEMPERATURE',
                value: isMonitoring
                    ? '${temperature.toStringAsFixed(1)} °C'
                    : '-- °C',
                status: temperatureStatus,
                color: !isMonitoring
                    ? Colors.grey
                    : temperatureNormal
                        ? Colors.green
                        : Colors.red,
              ),

              const SizedBox(height: 15),

              MonitoringCard(
                icon: Icons.person,
                title: 'HEAD POSITION',
                value: isMonitoring
                    ? headTiltDetected
                        ? 'TILTED'
                        : 'NORMAL'
                    : '--',
                status: headPositionStatus,
                color: !isMonitoring
                    ? Colors.grey
                    : headTiltDetected
                        ? Colors.red
                        : Colors.green,
              ),

              const SizedBox(height: 15),

              MonitoringCard(
                icon: Icons.warning_amber_rounded,
                title: 'ALERT STATUS',
                value: alertStatus,
                status: isMonitoring
                    ? driverSafe
                        ? 'SAFE'
                        : 'ALERT'
                    : 'OFF',
                color: driverStatusColor,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: toggleMonitoring,
                  icon: Icon(
                    isMonitoring
                        ? Icons.monitor_heart
                        : Icons.power_settings_new,
                    size: 27,
                  ),
                  label: Text(
                    isMonitoring
                        ? 'MONITORING ON'
                        : 'MONITORING OFF',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isMonitoring
                        ? Colors.green
                        : Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              if (isMonitoring)
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      headTiltDetected =
                          !headTiltDetected;
                    });
                  },
                  icon: const Icon(Icons.person),
                  label: Text(
                    headTiltDetected
                        ? 'CLEAR HEAD TILT'
                        : 'SIMULATE HEAD TILT',
                  ),
                ),

              const SizedBox(height: 20),

              Text(
                'Driver Safety Monitoring System',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MonitoringCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String status;
  final Color color;

  const MonitoringCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}