import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'galery_widget.dart';

class TugasPertemuan extends StatefulWidget {
  const TugasPertemuan({super.key});

  @override
  State<TugasPertemuan> createState() => _TugasPertemuanState();
}

class _TugasPertemuanState extends State<TugasPertemuan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String name = "Icha Aprilia";
  String bio = "Belajar Flutter!";
  String jurusan = "Teknik Informatika";
  String semester = "Semester 6";
  String lokasi = "Bandung, Jawa Barat";
  String kontak = "icha@student.ac.id";
  String? imagePath;

  List<Map<String, String>> pengalaman = [
    {
      "title": "UI Designer",
      "desc": "Design mobile app modern",
    }
  ];

  void updateProfile(String n, String b, String j, String s, String? img) {
    setState(() {
      name = n;
      bio = b;
      jurusan = j;
      semester = s;
      imagePath = img;
    });
  }

  void addPengalaman(String title, String desc, String? imgPath) {
    setState(() {
      pengalaman.add({
        "title": title,
        "desc": desc,
        "image": imgPath ?? "",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          "Profil Saya",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),

      /// 1. DRAWER (MENU UTAMA) - Sesuai gambar Menu Utama
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, left: 20, bottom: 20),
                color: Colors.pinkAccent.shade100,
                child: const Text(
                  "Menu Utama",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.pink),
                title: const Text("Profil"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.widgets, color: Colors.pink),
                title: const Text("Widget Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GaleryWidget()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.cloud_upload, color: Colors.pink),
                title: const Text("Upload Pengalaman"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UploadPengalamanPage(onSave: addPengalaman),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.pink),
                title: const Text("Pengaturan"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),

      /// 2. BODY UTAMA PROFIL
      body: Stack(
        children: [
          ProfileView(
            name: name,
            bio: bio,
            jurusan: jurusan,
            semester: semester,
            lokasi: lokasi,
            kontak: kontak,
            imagePath: imagePath,
            pengalaman: pengalaman,
          ),

          /// 3. TOMBOL EDIT PROFIL MELAYANG (Pojok Kanan Bawah)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.pink.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(
                      name: name,
                      bio: bio,
                      jurusan: jurusan,
                      semester: semester,
                      imagePath: imagePath,
                      onSave: updateProfile,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.pink, size: 18),
              label: const Text(
                "Edit Profil",
                style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}