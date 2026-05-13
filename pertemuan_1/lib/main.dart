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
      title: 'Kreatif Hub Icha',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.pinkAccent,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Creative Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(icon: Icon(Icons.auto_awesome), text: 'Welcome'),
              Tab(icon: Icon(Icons.layers), text: 'Design Gear'),
              Tab(icon: Icon(Icons.dashboard_customize), text: 'Layouts'),
              Tab(icon: Icon(Icons.extension), text: 'Elements'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WelcomeScreen(),
            DesignGearScreen(),
            LayoutExperimentScreen(),
            ElementCollectionScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.pinkAccent,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.style), label: 'Styles'),
            BottomNavigationBarItem(icon: Icon(Icons.face_retouching_natural), label: 'Me'),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 1: WELCOME ---
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Text('✨', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 10),
          const Text(
            'Hi, Icha Aprilia!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.pinkAccent),
          ),
          const Text('Ready to build something amazing today?'),
          const SizedBox(height: 30),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.pink.shade50, Colors.white]),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              children: [
                const CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.badge, color: Colors.white)),
                const SizedBox(height: 15),
                _infoRow(Icons.fingerprint, "233040108"),
                _infoRow(Icons.school, "Informatics Engineering"),
                _infoRow(Icons.bolt, "Active Semester: 6"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// --- SCREEN 2: DESIGN GEAR ---
class DesignGearScreen extends StatelessWidget {
  const DesignGearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250, height: 80,
          decoration: const ShapeDecoration(
            color: Colors.pinkAccent,
            shape: StadiumBorder(),
          ),
          child: const Center(child: Text('Stadium Shape', style: TextStyle(color: Colors.white))),
        ),
        const SizedBox(height: 30),
        Container(
          width: 120, height: 120,
          decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
          child: const Icon(Icons.rocket_launch, color: Colors.white, size: 50),
        ),
        const SizedBox(height: 30),
        Container(
          width: 180, height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.pinkAccent, width: 3),
              borderRadius: BorderRadius.circular(15)
          ),
          child: const Center(child: Text('Outlined Box')),
        ),
      ],
    );
  }
}

// --- SCREEN 3: LAYOUT EXPERIMENT ---
class LayoutExperimentScreen extends StatelessWidget {
  const LayoutExperimentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Horizontal Play", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _chip("Start", Colors.indigo),
            _chip("Middle", Colors.indigo),
            _chip("End", Colors.indigo),
          ],
        ),
        const SizedBox(height: 30),
        const Text("Vertical Play", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Column(
          children: [
            _cardItem("Primary Task", Icons.check_circle, Colors.green),
            _cardItem("Secondary Project", Icons.pending, Colors.orange),
            _cardItem("Archived Work", Icons.archive, Colors.grey),
          ],
        )
      ],
    );
  }

  Widget _chip(String label, Color color) => Chip(
    label: Text(label, style: const TextStyle(color: Colors.white)),
    backgroundColor: color,
  );

  Widget _cardItem(String title, IconData icon, Color color) => Card(
    child: ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    ),
  );
}

// --- SCREEN 4: ELEMENT COLLECTION ---
class ElementCollectionScreen extends StatelessWidget {
  const ElementCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: const [
          _IconBox(Icons.auto_fix_high, "Magic", Colors.amber),
          _IconBox(Icons.camera_roll, "Film", Colors.blue),
          _IconBox(Icons.cloud_queue, "Cloud", Colors.lightBlue),
          _IconBox(Icons.coffee, "Coffee", Colors.brown),
          _IconBox(Icons.diamond, "VIP", Colors.cyan),
          _IconBox(Icons.music_note, "Music", Colors.purple),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _IconBox(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: color, size: 40),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}