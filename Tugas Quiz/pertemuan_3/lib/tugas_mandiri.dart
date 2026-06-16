import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// MODEL DATA (Ditambah field email)
// ==========================================
class Catatan {
  final String id; // Ditambahkan ID untuk mempermudah pencarian saat edit
  final String judul;
  final String isi;
  final String kategori;
  final String email; // Tugas Mandiri 3: Field Email
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });
}

// ==========================================
// MAIN APPLICATION & ROUTING
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
          // Tugas Mandiri 1: Menerima argumen opsional untuk mode EDIT
            final catatanLama = settings.arguments as Catatan?;
            return MaterialPageRoute(
              builder: (_) => TambahCatatanPage(catatanLama: catatanLama),
            );
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }
        return null;
      },
    );
  }
}

// ==========================================
// HOMEPAGE (DENGAN FILTER KATEGORI & EDIT)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tugas Mandiri 2: State untuk Filter Kategori
  String _filterKategori = 'Semua';
  final List<String> _filterOpsi = const ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  // State: Daftar Catatan (Default awal)
  final List<Catatan> _catatan = [
    Catatan(
      id: '1',
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation pada Pertemuan 3.',
      kategori: 'Kuliah',
      email: 'mhs@kampus.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  // Fungsi Tambah Catatan Baru
  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() {
        _catatan.add(hasil);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" berhasil ditambahkan')),
      );
    }
  }

  // Tugas Mandiri 1: Fungsi Edit Catatan Lama
  Future<void> _bukaEditCatatan(Catatan catatanLama) async {
    final hasil = await Navigator.pushNamed(context, '/tambah', arguments: catatanLama);

    if (hasil is Catatan) {
      setState(() {
        // Cari indeks catatan lama berdasarkan ID, lalu timpa dengan data baru
        final index = _catatan.indexWhere((element) => element.id == hasil.id);
        if (index != -1) {
          _catatan[index] = hasil;
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" berhasil diperbarui')),
      );
    }
  }

  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} - ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Tugas Mandiri 2: Filter list sebelum di-render di ListView
    final catatanTerfilter = _catatan.where((c) {
      if (_filterKategori == 'Semua') return true;
      return c.kategori == _filterKategori;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Tugas Mandiri 2: Dropdown Filter di AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: _filterKategori,
              icon: const Icon(Icons.filter_list, color: Colors.indigo),
              underline: const SizedBox(), // Menghilangkan garis bawah bawaan
              items: _filterOpsi.map((String kategori) {
                return DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _filterKategori = v!;
                });
              },
            ),
          ),
        ],
      ),
      body: catatanTerfilter.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada catatan ditemukan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: catatanTerfilter.length,
        itemBuilder: (context, i) {
          final c = catatanTerfilter[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              title: Text(
                c.judul,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Kategori: ${c.kategori} | Oleh: ${c.email}'),
                  Text(
                    _formatTanggal(c.dibuatPada),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.pushNamed(context, '/detail', arguments: c);
              },
              // Menggabungkan aksi Edit dan Hapus di trailing menggunakan Row
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tugas Mandiri 1: Tombol Edit
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.orange),
                    onPressed: () => _bukaEditCatatan(c),
                  ),
                  // Tombol Hapus
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _catatan.removeWhere((element) => element.id == c.id);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Catatan "${c.judul}" dihapus')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==========================================
// TAMBAH & EDIT CATATAN (DENGAN RE-USE FORM & REGEX)
// ==========================================
class TambahCatatanPage extends StatefulWidget {
  // Tugas Mandiri 1: Menerima objek Catatan jika dalam mode edit
  final Catatan? catatanLama;
  const TambahCatatanPage({super.key, this.catatanLama});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late TextEditingController _emailCtrl; // Tugas Mandiri 3: Controller Email

  String _kategori = 'Kuliah';
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // Tugas Mandiri 1: Jika ada catatanLama, isi field dengan data lama (Mode Edit)
    _judulCtrl = TextEditingController(text: widget.catatanLama?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatanLama?.isi ?? '');
    _emailCtrl = TextEditingController(text: widget.catatanLama?.email ?? '');
    _kategori = widget.catatanLama?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    // Jika mode edit, gunakan ID lama. Jika baru, buat ID unik berdasarkan timestamp.
    final idBaru = widget.catatanLama?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final catatanData = Catatan(
      id: idBaru,
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(), // Pakai tanggal lama jika edit
    );

    Navigator.pop(context, catatanData);
  }

  @override
  Widget build(BuildContext context) {
    // Cek status mode form untuk membedakan judul AppBar
    final isEditMode = widget.catatanLama != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Ubah Catatan' : 'Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Input Judul
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tugas Mandiri 3: Input Email dengan Validasi Regex
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: 'contoh@kampus.com',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';

                // Pola Regex standard validasi email
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(v.trim())) {
                  return 'Format email tidak valid (misal: mhs@kampus.com)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Dropdown Kategori
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),

            // Input Isi
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),

            // Tombol Simpan (menyesuaikan teks mode)
            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(isEditMode ? Icons.update : Icons.save),
              label: Text(isEditMode ? 'Perbarui Catatan' : 'Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// DETAIL CATATAN
// ==========================================
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Row untuk menampilkan Kategori dan Email Pengirim
            Row(
              children: [
                Chip(
                  label: Text(catatan.kategori),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Oleh: ${catatan.email}',
                    style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),

            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}