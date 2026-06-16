import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profil Profesional', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section dengan Image Error Handling
            _buildHeader(),
            const SizedBox(height: 24),

            // Section 1: Tentang Saya
            const _SectionCard(
              icon: Icons.person_outline,
              title: 'Tentang Saya',
              content: 'Mahasiswa Teknik Informatika yang fokus pada pengembangan aplikasi mobile menggunakan Flutter. Memiliki minat tinggi dalam UI/UX Design.',
            ),

            // Section 2: Skills
            const _SectionCard(
              icon: Icons.psychology_outlined,
              title: 'Skills & Kompetensi',
              content: '',
              customContent: Wrap(
                spacing: 8,
                runSpacing: 0,
                children: [
                  Chip(label: Text('Flutter'), avatar: Icon(Icons.bolt, size: 16)),
                  Chip(label: Text('Dart')),
                  Chip(label: Text('Firebase')),
                  Chip(label: Text('Git')),
                  Chip(label: Text('Figma')),
                ],
              ),
            ),

            // Section 3: Pendidikan
            const _SectionCard(
              icon: Icons.school_outlined,
              title: 'Pendidikan',
              content: '',
              customContent: Column(
                children: [
                  _TimelineTile(
                    title: 'Universitas Pasundan',
                    subtitle: 'S1 Teknik Informatika (2023 - Sekarang)',
                    isLast: false,
                  ),
                  _TimelineTile(
                    title: 'SMA SAPTA DHARMA BANDUNG',
                    subtitle: 'MIPA (2020 - 2023)',
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Section 4: Pengalaman
            const _SectionCard(
              icon: Icons.work_outline,
              title: 'Pengalaman Organisasi',
              content: '',
              customContent: Column(
                children: [
                  _TimelineTile(
                    title: 'Bendahara program kerja HMTIF UNPAS',
                    subtitle: 'Himpunan Mahasiswa IT (2023)',
                    isLast: false,
                  ),
                  _TimelineTile(
                    title: 'Freelance Ngajar Coding',
                    subtitle: 'Project Bikin Game (2023-Sekarang)',
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Section 5: Kontak
            const _SectionCard(
              icon: Icons.contact_mail_outlined,
              title: 'Hubungi Saya',
              content: '',
              customContent: Column(
                children: [
                  _ContactTile(icon: Icons.email, text: 'ichaapriliaptri@gmail.com'),
                  _ContactTile(icon: Icons.phone, text: '+62 812 3456 7890'),
                  _ContactTile(icon: Icons.location_on, text: 'Bandung, Indonesia'),
                ],
              ),
            ),

            const SizedBox(height: 100), // Spasi agar tidak tertutup FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur edit sedang dikembangkan 🛠️'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit_note),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Notif'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Setting'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade100, width: 4),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                // Menggunakan Image.network di dalam child agar bisa handle error
                child: ClipOval(
                  child: Image.network(
                    'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 60, color: Colors.grey);
                    },
                  ),
                ),
              ),
            ),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Icha Aprilia Putri',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'Mobile Application Developer',
          style: TextStyle(fontSize: 16, color: Colors.blue.shade700),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Felix'),
            ),
            accountName: const Text('Icha'),
            accountEmail: const Text('ichaapriliaptri@gmail.com'),
            decoration: BoxDecoration(color: Colors.blue.shade700),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pengaturan'),
                  content: const Text('Ini adalah dialog pengaturan.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget untuk Baris Pendidikan/Pengalaman
class _TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isLast;
  const _TimelineTile({required this.title, required this.subtitle, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            const Icon(Icons.circle, size: 12, color: Colors.blue),
            if (!isLast) Container(width: 2, height: 25, color: Colors.blue.shade100),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget untuk Baris Kontak
class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// Custom Card untuk setiap Section
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Widget? customContent;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            if (content.isNotEmpty)
              Text(content, style: TextStyle(color: Colors.grey.shade800, height: 1.5)),
            if (customContent != null) customContent!,
          ],
        ),
      ),
    );
  }
}