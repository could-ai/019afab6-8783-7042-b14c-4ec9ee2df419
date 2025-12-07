import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _killSwitch = false;
  bool _autoConnect = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader("Connection"),
          SwitchListTile(
            title: const Text("Kill Switch"),
            subtitle: const Text("Block internet if VPN connection drops"),
            value: _killSwitch,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (val) => setState(() => _killSwitch = val),
          ),
          SwitchListTile(
            title: const Text("Auto Connect"),
            subtitle: const Text("Connect automatically on app launch"),
            value: _autoConnect,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (val) => setState(() => _autoConnect = val),
          ),
          const Divider(),
          _buildSectionHeader("General"),
          SwitchListTile(
            title: const Text("Notifications"),
            subtitle: const Text("Show connection status in notification bar"),
            value: _notifications,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (val) => setState(() => _notifications = val),
          ),
          ListTile(
            title: const Text("Protocol"),
            subtitle: const Text("IKEv2 (Recommended)"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Protocol selection coming soon")),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader("Account"),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("My Account"),
            subtitle: const Text("Free Plan"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            subtitle: const Text("Version 1.0.0"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
