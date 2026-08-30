import 'package:flutter/material.dart';

import 'screens/lighting_screen.dart';
import 'screens/parking_screen.dart';
import 'screens/environment_screen.dart';
import 'screens/security_screen.dart';
import 'screens/driver_monitoring_screen.dart';

void main() {
  runApp(const VehicleControlApp());
}

class VehicleControlApp extends StatelessWidget {
  const VehicleControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Control System',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const VehicleDashboard(),
    );
  }
}

class VehicleDashboard extends StatelessWidget {
  const VehicleDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'VEHICLE CONTROL SYSTEM',
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 15),

              Icon(
                Icons.directions_car,
                size: 100,
                color: Colors.blue.shade700,
              ),

              const SizedBox(height: 10),

              const Text(
                'SMART VEHICULAR CONTROL CENTER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Select a vehicle system to open its control panel.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),

              _systemCard(
                context,
                icon: Icons.lightbulb,
                title: 'SMART VEHICLE LIGHTING',
                subtitle: 'Automatic and manual lighting control',
                color: Colors.amber,
                page: const SmartLightingHomePage(),
              ),

              const SizedBox(height: 15),

              _systemCard(
                context,
                icon: Icons.local_parking,
                title: 'ADVANCED PARKING ASSISTANCE',
                subtitle: 'Parking distance and obstacle monitoring',
                color: Colors.blue,
                page: const ParkingDashboard(),
              ),

              const SizedBox(height: 15),

              _systemCard(
                context,
                icon: Icons.thermostat,
                title: 'VEHICLE ENVIRONMENT CONTROL',
                subtitle: 'Temperature, humidity and HVAC control',
                color: Colors.orange,
                page: const EnvironmentDashboard(),
              ),

              const SizedBox(height: 15),

              _systemCard(
                context,
                icon: Icons.security,
                title: 'VEHICLE SECURITY & ANTI-THEFT',
                subtitle: 'Vehicle protection and disturbance detection',
                color: Colors.red,
                page: const SecurityHomePage(),
              ),

              const SizedBox(height: 15),

              _systemCard(
                context,
                icon: Icons.monitor_heart,
                title: 'DRIVER MONITORING',
                subtitle: 'Driver health and alert monitoring',
                color: Colors.green,
                page: const DriverMonitoringHomePage(),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 15),

              const Text(
                'VEHICLE CONTROL SYSTEM',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'LUTWAMA JOEL MARTHAN',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _systemCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
      ),
    );
  }
}