import 'dart:async';
import 'package:flutter/material.dart';
import '../models/server_model.dart';
import 'server_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isConnected = false;
  bool _isConnecting = false;
  ServerModel _selectedServer = const ServerModel(
    name: "United States",
    flag: "🇺🇸",
    ip: "104.23.12.1",
    ping: 45,
  );
  
  Timer? _timer;
  int _secondsConnected = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleConnection() {
    if (_isConnecting) return;

    if (_isConnected) {
      // Disconnect
      setState(() {
        _isConnected = false;
        _secondsConnected = 0;
        _timer?.cancel();
        _pulseController.stop();
        _pulseController.reset();
      });
    } else {
      // Connect
      setState(() {
        _isConnecting = true;
        _pulseController.repeat(reverse: true);
      });

      // Simulate connection delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isConnecting = false;
            _isConnected = true;
            _startTimer();
            _pulseController.stop();
            _pulseController.reset();
          });
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsConnected++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final int h = seconds ~/ 3600;
    final int m = (seconds % 3600) ~/ 60;
    final int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _selectServer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServerListScreen()),
    );

    if (result != null && result is ServerModel) {
      setState(() {
        _selectedServer = result;
        // If we were connected, simulate a reconnect
        if (_isConnected) {
          _isConnected = false;
          _toggleConnection();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure VPN"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {}, // Drawer could go here
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // Status Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _isConnected 
                  ? Colors.green.withOpacity(0.1) 
                  : (_isConnecting ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _isConnected 
                  ? "CONNECTED" 
                  : (_isConnecting ? "CONNECTING..." : "DISCONNECTED"),
              style: TextStyle(
                color: _isConnected 
                    ? Colors.green 
                    : (_isConnecting ? Colors.orange : Colors.grey),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Timer
          Text(
            _formatDuration(_secondsConnected),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w200,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          
          const Spacer(),
          
          // Main Connect Button
          Center(
            child: GestureDetector(
              onTap: _toggleConnection,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 180 * (_isConnecting ? _pulseAnimation.value : 1.0),
                    height: 180 * (_isConnecting ? _pulseAnimation.value : 1.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isConnected 
                          ? colorScheme.primary 
                          : (_isConnecting ? Colors.orange : colorScheme.surfaceContainerHighest),
                      boxShadow: [
                        BoxShadow(
                          color: (_isConnected ? colorScheme.primary : Colors.grey).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.power_settings_new,
                        size: 80,
                        color: _isConnected || _isConnecting 
                            ? Colors.white 
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const Spacer(),
          
          // Server Selection Card
          GestureDetector(
            onTap: _selectServer,
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _selectedServer.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Current Location",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          _selectedServer.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          
          // Stats Row
          if (_isConnected)
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(Icons.arrow_downward, "Download", "45.2 MB/s"),
                  Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                  _buildStatItem(Icons.arrow_upward, "Upload", "12.8 MB/s"),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
