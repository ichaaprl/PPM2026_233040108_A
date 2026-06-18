import 'package:flutter/material.dart';
import 'api_client.dart';

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
        colorSchemeSeed: Colors.pink,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });

  Map<String, dynamic> toJson() => {
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'dibuat_pada': dibuatPada.toIso8601String(),
  };

  factory Catatan.fromJson(Map<String, dynamic> json) => Catatan(
    id: json['id'],
    judul: json['judul'],
    isi: json['isi'],
    kategori: json['kategori'],
    dibuatPada: DateTime.parse(json['dibuat_pada']),
  );
}

// ═══════════════════════════════════════════
// HOME PAGE
// ═══════════════════════════════════════════

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Catatan>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ApiClient.instance.getAll();
  }

  void _refresh() {
    setState(() {
      _load();
    });
  }

  void _delete(int id) async {
    try {
      await ApiClient.instance.delete(id);
      _refresh();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil dihapus")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e")),
      );
    }
  }

  // ✅ DIALOG DELETE (dipindah ke tempat yang benar)
  void _confirmDelete(int id) async {
    final yakin = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Catatan"),
        content: const Text("Yakin mau hapus?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (yakin == true) {
      _delete(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
        appBar: AppBar(
          title: const Text(
            "Catatan Mahasiswa",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.pink.shade700,
          elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _refresh,
                ),
              ],
        ),
      body: FutureBuilder<List<Catatan>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final pesan = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : snapshot.error.toString();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.pink.shade300),
                  const SizedBox(height: 8),
                  Text(pesan, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.pink.shade400),
            );
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_outlined, size: 64, color: Colors.pink.shade200),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada catatan.',
                    style: TextStyle(color: Colors.pink.shade300, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, i) {
              final c = data[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.pink.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade50,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  title: Text(
                    c.judul,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(c.isi, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          c.kategori,
                          style: TextStyle(
                              fontSize: 11, color: Colors.pink.shade400),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined,
                            color: Colors.pink.shade400),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormPage(catatan: c),
                            ),
                          );
                          _refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red),
                        onPressed: () => _delete(c.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
          _refresh();
        },
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// FORM PAGE
// ═══════════════════════════════════════════

class FormPage extends StatefulWidget {
  final Catatan? catatan;

  const FormPage({super.key, this.catatan});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _judul = TextEditingController();
  final _isi = TextEditingController();
  String _kategori = 'Umum';

  final List<String> _kategoriList = [
    'Umum',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Penting'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.catatan != null) {
      _judul.text = widget.catatan!.judul;
      _isi.text = widget.catatan!.isi;
      _kategori = widget.catatan!.kategori;
    }
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  void _save() async {
    if (_judul.text.isEmpty) return;

    if (widget.catatan == null) {
      await ApiClient.instance.insert(
        Catatan(
          judul: _judul.text,
          isi: _isi.text,
          kategori: _kategori,
          dibuatPada: DateTime.now(),
        ),
      );
    } else {
      await ApiClient.instance.update(
        Catatan(
          id: widget.catatan!.id,
          judul: _judul.text,
          isi: _isi.text,
          kategori: _kategori,
          dibuatPada: widget.catatan!.dibuatPada,
        ),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: Text(widget.catatan == null ? "Tambah Catatan" : "Edit Catatan"),
        backgroundColor: const Color(0xFFFFF0F5),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Field Judul
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.shade200),
              ),
              child: TextField(
                controller: _judul,
                decoration: InputDecoration(
                  hintText: 'Judul',
                  prefixIcon:
                  Icon(Icons.title, color: Colors.pink.shade300),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Dropdown Kategori
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _kategori,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _kategoriList
                      .map((k) => DropdownMenuItem(
                    value: k,
                    child: Row(
                      children: [
                        Icon(Icons.category_outlined,
                            color: Colors.pink.shade300, size: 20),
                        const SizedBox(width: 8),
                        Text(k),
                      ],
                    ),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _kategori = v!),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Textarea Isi
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.shade200),
              ),
              child: TextField(
                controller: _isi,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Isi',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Icon(Icons.notes, color: Colors.pink.shade300),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Simpan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}