import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// ==========================================
/// VIEW PROFIL (UI UTAMA JADI EPSILON PINK)
/// ==========================================
class ProfileView extends StatelessWidget {
  final String name, bio, jurusan, semester, lokasi, kontak;
  final String? imagePath;
  final List<Map<String, String>> pengalaman;

  const ProfileView({
    super.key,
    required this.name,
    required this.bio,
    required this.jurusan,
    required this.semester,
    required this.lokasi,
    required this.kontak,
    this.imagePath,
    required this.pengalaman,
  });

  // Fungsi helper untuk menampilkan gambar yang aman bagi Web & Mobile
  dynamic _getProfileImage() {
    if (imagePath == null || imagePath!.isEmpty) return null;
    if (kIsWeb) {
      return NetworkImage(imagePath!);
    } else {
      return FileImage(File(imagePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          const SizedBox(height: 15),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.pink.shade100,
            backgroundImage: _getProfileImage(),
            child: imagePath == null || imagePath!.isEmpty
                ? const Icon(Icons.person, size: 45, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            "Mahasiswa $jurusan",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _Stat("12", "Post"),
              _Stat("128", "Teman"),
              _Stat("1.2K", "Like"),
            ],
          ),
          const SizedBox(height: 20),

          _buildInfoCard(Icons.info_outline, "Tentang", bio),
          _buildInfoCard(Icons.school_outlined, "Pendidikan", "$jurusan - $semester"),
          _buildInfoCard(Icons.location_on_outlined, "Lokasi", lokasi),
          _buildInfoCard(Icons.email_outlined, "Kontak", kontak),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.pink, size: 20),
                    SizedBox(width: 8),
                    Text("Skills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _SkillChip("Flutter"),
                    _SkillChip("Dart"),
                    _SkillChip("Java"),
                    _SkillChip("Python"),
                    _SkillChip("Git"),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.collections_bookmark_outlined, color: Colors.pink, size: 20),
                        SizedBox(width: 8),
                        Text("Pengalaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Text("${pengalaman.length}", style: const TextStyle(color: Colors.pink, fontSize: 12, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                ...pengalaman.map((e) => Card(
                  color: Colors.pink.shade50.withOpacity(0.3),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.pink.shade100.withOpacity(0.5)),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: e['image'] != null && e['image']!.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: kIsWeb
                                ? Image.network(e['image']!, fit: BoxFit.cover)
                                : Image.file(File(e['image']!), fit: BoxFit.cover),
                          )
                              : const Icon(Icons.image, color: Colors.white),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(e['desc']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.pink.shade50.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.pink.shade100.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink.shade300, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String val, label;
  const _Stat(this.val, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.pink.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: Text(label, style: const TextStyle(color: Colors.pink, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}

/// ==========================================
/// HALAMAN EDIT PROFIL
/// ==========================================
class ProfilePage extends StatefulWidget {
  final String name, bio, jurusan, semester;
  final String? imagePath;
  final Function(String, String, String, String, String?) onSave;

  const ProfilePage({
    super.key,
    required this.name,
    required this.bio,
    required this.jurusan,
    required this.semester,
    this.imagePath,
    required this.onSave,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameC;
  late TextEditingController bioC;
  late TextEditingController jurusanC;
  late TextEditingController semesterC;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.name);
    bioC = TextEditingController(text: widget.bio);
    jurusanC = TextEditingController(text: widget.jurusan);
    semesterC = TextEditingController(text: widget.semester);
    imagePath = widget.imagePath;
  }

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        // Jika di web, gunakan path sementara (Blob URL) agar bisa dibaca Image.network
        imagePath = picked.path;
      });
    }
  }

  dynamic _getEditProfileImage() {
    if (imagePath == null || imagePath!.isEmpty) return null;
    if (kIsWeb) {
      return NetworkImage(imagePath!);
    } else {
      return FileImage(File(imagePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(nameC.text, bioC.text, jurusanC.text, semesterC.text, imagePath);
              Navigator.pop(context);
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Foto Profil", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _getEditProfileImage(),
                    child: imagePath == null || imagePath!.isEmpty ? const Icon(Icons.person, size: 50) : null,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.pink,
                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: pickImage, child: const Text("Ganti Foto dari Galeri", style: TextStyle(color: Colors.grey))),

            const SizedBox(height: 20),
            _buildTextField(nameC, "Nama Lengkap *", Icons.person_outline),
            const SizedBox(height: 15),
            _buildTextField(bioC, "Bio / Tentang", Icons.info_outline, maxLines: 3),
            const SizedBox(height: 15),
            _buildTextField(jurusanC, "Jurusan", Icons.school_outlined),
            const SizedBox(height: 15),
            _buildTextField(semesterC, "Semester", Icons.av_timer),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  widget.onSave(nameC.text, bioC.text, jurusanC.text, semesterC.text, imagePath);
                  Navigator.pop(context);
                },
                child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink.shade300),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.pink)),
      ),
    );
  }
}

/// ==========================================
/// HALAMAN UPLOAD PENGALAMAN (FORM BARU)
/// ==========================================
class UploadPengalamanPage extends StatefulWidget {
  final Function(String, String, String?) onSave;
  const UploadPengalamanPage({super.key, required this.onSave});

  @override
  State<UploadPengalamanPage> createState() => _UploadPengalamanPageState();
}

class _UploadPengalamanPageState extends State<UploadPengalamanPage> {
  final titleC = TextEditingController();
  final descC = TextEditingController();
  String? expImagePath;

  Future pickExpImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        expImagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Pengalaman"),
        actions: [
          TextButton(
            onPressed: () {
              if (titleC.text.isNotEmpty) {
                widget.onSave(titleC.text, descC.text, expImagePath);
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: pickExpImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.pink.shade100, width: 1),
                ),
                child: expImagePath != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: kIsWeb
                      ? Image.network(expImagePath!, fit: BoxFit.cover)
                      : Image.file(File(expImagePath!), fit: BoxFit.cover),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.pink.shade300),
                    const SizedBox(height: 8),
                    const Text("Ketuk untuk pilih gambar", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w500)),
                    Text("dari galeri perangkat kamu", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Informasi Pengalaman", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: titleC,
              decoration: InputDecoration(
                labelText: "Judul *",
                prefixIcon: const Icon(Icons.title, color: Colors.pink),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descC,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                prefixIcon: const Icon(Icons.description_outlined, color: Colors.pink),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A4568),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (titleC.text.isNotEmpty) {
                    widget.onSave(titleC.text, descC.text, expImagePath);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Simpan Pengalaman", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}