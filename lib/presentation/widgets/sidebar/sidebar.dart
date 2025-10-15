import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool dashboardExpanded = false;
  bool settingsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const DrawerHeader(
            child: Center(
              child: Text("App Menu", style: TextStyle(fontSize: 22)),
            ),
          ),
          ExpansionTile(
            title: const Text("Dashboard"),
            leading: const Icon(Icons.dashboard),
            initiallyExpanded: dashboardExpanded,
            onExpansionChanged: (v) => setState(() => dashboardExpanded = v),
            children: [
              ListTile(
                title: const Text("Overview"),
                onTap: () => context.router.pushNamed('/dashboard/overview'),
              ),
              ListTile(
                title: const Text("Reports"),
                onTap: () => context.router.pushNamed('/dashboard/reports'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
            initiallyExpanded: settingsExpanded,
            onExpansionChanged: (v) => setState(() => settingsExpanded = v),
            children: [
              ListTile(
                title: const Text("Profile"),
                onTap: () => context.router.pushNamed('/dashboard/settings'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Report"),
            leading: const Icon(Icons.settings),
            initiallyExpanded: settingsExpanded,
            onExpansionChanged: (v) => setState(() => settingsExpanded = v),
            children: [
              ListTile(
                title: const Text("Report Finance"),
                onTap: () => context.router.pushNamed('/report/finance'),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text("Pesan Warga"),
            leading: const Icon(Icons.settings),
            initiallyExpanded: settingsExpanded,
            onExpansionChanged: (v) => setState(() => settingsExpanded = v),
            children: [
              ListTile(
                title: const Text("Informasi Aspirasi"),
                onTap: () => context.router.pushNamed('/pesanWarga/aspirasi'),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text("Penerimaan Warga"),
            leading: const Icon(Icons.settings),
            initiallyExpanded: settingsExpanded,
            onExpansionChanged: (v) => setState(() => settingsExpanded = v),
            children: [
              ListTile(
                title: const Text("Penerimaan Warga"),
                onTap: () => context.router.pushNamed('/penerimaanWarga/penerimaan'),
              ),
            ],
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => context.router.replaceNamed('/login'),
          ),
        ],
      ),
    );
  }
}
