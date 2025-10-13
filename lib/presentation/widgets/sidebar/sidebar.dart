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
                title: const Text("Keuangan"),
                onTap: () => context.router.pushNamed('/dashboard/keuangan'),
              ),
              ListTile(
                title: const Text("Kegiatan"),
                onTap: () => context.router.pushNamed('/dashboard/kegiatan'),
              ),
              ListTile(
                title: const Text("Kependudukan"),
                onTap: () => context.router.pushNamed('/dashboard/kependudukan'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Data Warga & Rumah"),
            leading: const Icon(Icons.dashboard),
            initiallyExpanded: dashboardExpanded,
            onExpansionChanged: (v) => setState(() => dashboardExpanded = v),
            children: [
              ListTile(
                title: const Text("Warga - Daftar"),
                onTap: () => context.router.pushNamed('/warga/daftar'),
              ),
              ListTile(
                title: const Text("Warga - Tambah"),
                onTap: () => context.router.pushNamed('/warga/tambah'),
              ),
              ListTile(
                title: const Text("Keluarga"),
                onTap: () => context.router.pushNamed('/keluarga'),
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
