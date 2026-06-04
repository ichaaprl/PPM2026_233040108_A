import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff1976d2),
          primary: const Color(0xff1976d2),
        ),
        useMaterial3: false,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) { //
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/form':
            final arg = settings.arguments;
            return MaterialPageRoute(
              builder: (_) => CatatanFormPage(initial: arg as Catatan?),
            );
          case '/detail':
            final c = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: c),
            );
        }
        return null;
      },
    );
  }
}

// ==========================================
// MODEL DATA: CATATAN
// ==========================================
class Catatan {
  final int? id;                 //
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

  Map<String, Object?> toMap() => { //
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'dibuat_pada': dibuatPada.millisecondsSinceEpoch,
  };

  static Catatan fromMap(Map<String, Object?> m) => Catatan( //
    id: m['id'] as int?,
    judul: m['judul'] as String,
    isi: m['isi'] as String,
    kategori: m['kategori'] as String,
    dibuatPada: DateTime.fromMillisecondsSinceEpoch(m['dibuat_pada'] as int),
  );

  Catatan copyWith({String? judul, String? isi, String? kategori}) => //
  Catatan(
    id: id,
    judul: judul ?? this.judul,
    isi: isi ?? this.isi,
    kategori: kategori ?? this.kategori,
    dibuatPada: dibuatPada,
  );
}

// ==========================================
// HALAMAN 1: HOME PAGE (DAFTAR CATATAN + FILTER)
// ==========================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Catatan>> _futureCatatan; //

  // State untuk menyimpan kategori aktif yang dipilih
  String _kategoriTerpilih = 'Semua';

  @override
  void initState() {
    super.initState();
    _muatUlang(); //
  }

  // Modifikasi fungsi muat ulang agar menyaring data lokal berdasarkan kategori terpilih
  void _muatUlang() {
    setState(() {
      if (_kategoriTerpilih == 'Semua') {
        _futureCatatan = DbHelper.instance.getAll(); // Ambil seluruh data
      } else {
        // Filter list lokal agar hanya menampilkan kategori yang dicocokkan
        _futureCatatan = DbHelper.instance.getAll().then((list) =>
            list.where((catatan) => catatan.kategori == _kategoriTerpilih).toList()
        );
      }
    });
  }

  Future<void> _bukaForm({Catatan? initial}) async { //
    await Navigator.pushNamed(context, '/form', arguments: initial);
    _muatUlang(); //
  }

  Future<void> _konfirmasiHapus(Catatan c) async { //
    final yakin = await showDialog<bool>( //
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('"${c.judul}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      await DbHelper.instance.delete(c.id!); //
      _muatUlang();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${c.judul}" berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        elevation: 0,
        actions: [
          // ===== ATASNYA SEKARANG BISA DIKLIK (POPUP MENU FILTER) =====
          PopupMenuButton<String>(
            initialValue: _kategoriTerpilih,
            onSelected: (String nilaiBaru) {
              _kategoriTerpilih = nilaiBaru; // Ganti filter kategori aktif
              _muatUlang();                  // Segarkan tampilan list data
            },
            // Desain tombol pemicu agar persis dengan visual proyektor
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    _kategoriTerpilih,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.filter_list), // Ikon filter garis susun
                ],
              ),
            ),
            // Isi daftar item menu pop-up kategori saat ditekan
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'Semua', child: Text('Semua')),
              const PopupMenuItem<String>(value: 'Kuliah', child: Text('Kuliah')),
              const PopupMenuItem<String>(value: 'Tugas', child: Text('Tugas')),
              const PopupMenuItem<String>(value: 'Pribadi', child: Text('Pribadi')),
              const PopupMenuItem<String>(value: 'Lainnya', child: Text('Lainnya')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh), // Ikon penyegaran melingkar
            onPressed: _muatUlang,
          ),
          IconButton(
            icon: const Icon(Icons.brightness_2), // Ikon bulan mode malam
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Catatan>>( //
        future: _futureCatatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? const [];
          if (data.isEmpty) {
            return Center(
              child: Text(
                _kategoriTerpilih == 'Semua'
                    ? 'Belum ada catatan.\nSilakan tambah catatan baru!'
                    : 'Tidak ada catatan\nuntuk kategori "$_kategoriTerpilih".',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final item = data[i];
              final tanggalStr = "${item.dibuatPada.day}/${item.dibuatPada.month}/${item.dibuatPada.year}";

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.note, color: Color(0xff1976d2)),
                ),
                title: Text(
                  item.judul,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text("${item.kategori} • $tanggalStr"),
                onTap: () async {
                  await Navigator.pushNamed(context, '/detail', arguments: item);
                  _muatUlang();
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () => _bukaForm(initial: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _konfirmasiHapus(item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
        backgroundColor: const Color(0xff1976d2),
      ),
    );
  }
}

// ==========================================
// HALAMAN 2: FORM PAGE (TAMBAH & EDIT)
// ==========================================
class CatatanFormPage extends StatefulWidget {
  final Catatan? initial;
  const CatatanFormPage({super.key, this.initial});

  @override
  State<CatatanFormPage> createState() => _CatatanFormPageState();
}

class _CatatanFormPageState extends State<CatatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late String _kategori;
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  bool get _isEdit => widget.initial != null; //
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.initial?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.initial?.isi ?? '');
    _kategori = widget.initial?.kategori ?? 'Lainnya';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async { //
    if (!_formKey.currentState!.validate()) return;
    setState(() => _menyimpan = true);

    try {
      if (_isEdit) {
        final updated = widget.initial!.copyWith(
          judul: _judulCtrl.text.trim(),
          isi: _isiCtrl.text.trim(),
          kategori: _kategori,
        );
        await DbHelper.instance.update(updated); //
      } else {
        final baru = Catatan(
          judul: _judulCtrl.text.trim(),
          isi: _isiCtrl.text.trim(),
          kategori: _kategori,
          dibuatPada: DateTime.now(),
        );
        await DbHelper.instance.insert(baru); //
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isEdit ? 'Catatan diperbarui' : 'Catatan ditambahkan'),
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Catatan' : 'Tambah Catatan'), //
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _menyimpan
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul Catatan',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: _kategoriOpsi
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _kategori = v);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _isiCtrl,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Catatan', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1976d2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN 3: DETAIL CATATAN PAGE
// ==========================================
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    final tanggalStr = "${catatan.dibuatPada.day}/${catatan.dibuatPada.month}/${catatan.dibuatPada.year}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(context, '/form', arguments: catatan); //
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(catatan.kategori),
                  backgroundColor: Colors.blue.shade100,
                ),
                const SizedBox(width: 8),
                Text(
                  tanggalStr,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  catatan.isi,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}