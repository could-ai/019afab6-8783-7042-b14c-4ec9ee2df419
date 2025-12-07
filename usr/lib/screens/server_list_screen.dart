import 'package:flutter/material.dart';
import '../models/server_model.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  final List<ServerModel> servers = const [
    ServerModel(name: "United States", flag: "🇺🇸", ip: "104.23.12.1", ping: 45),
    ServerModel(name: "United Kingdom", flag: "🇬🇧", ip: "89.12.43.2", ping: 120),
    ServerModel(name: "Germany", flag: "🇩🇪", ip: "178.21.90.3", ping: 85),
    ServerModel(name: "Japan", flag: "🇯🇵", ip: "203.11.55.4", ping: 210),
    ServerModel(name: "Singapore", flag: "🇸🇬", ip: "112.45.22.5", ping: 180),
    ServerModel(name: "Australia", flag: "🇦🇺", ip: "139.99.10.6", ping: 250),
    ServerModel(name: "Canada", flag: "🇨🇦", ip: "198.51.100.7", ping: 60),
    ServerModel(name: "France", flag: "🇫🇷", ip: "51.15.20.8", ping: 95),
    ServerModel(name: "Netherlands", flag: "🇳🇱", ip: "188.166.10.9", ping: 40),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: servers.length,
        itemBuilder: (context, index) {
          final server = servers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Text(server.flag, style: const TextStyle(fontSize: 24)),
              ),
              title: Text(
                server.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("IP: ${server.ip}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.signal_cellular_alt,
                    color: server.ping < 100
                        ? Colors.green
                        : (server.ping < 200 ? Colors.orange : Colors.red),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${server.ping} ms",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context, server);
              },
            ),
          );
        },
      ),
    );
  }
}
