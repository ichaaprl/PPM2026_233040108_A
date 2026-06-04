import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' show Catatan;

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const _keyCatatan = 'list_catatan';

  // Ambil Semua Catatan (Read)
  Future<List<Catatan>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final String? catatanString = prefs.getString(_keyCatatan);

    if (catatanString == null) {
      return [];
    }

    final List<dynamic> jsonDecoded = jsonDecode(catatanString);
    return jsonDecoded.map((item) => Catatan.fromMap(item)).toList();
  }

  // Tambah Catatan Baru (Create)
  Future<void> insert(Catatan c) async {
    final prefs = await SharedPreferences.getInstance();
    final listCatatan = await getAll();

    final catatanBaru = Catatan(
      id: DateTime.now().millisecondsSinceEpoch,
      judul: c.judul,
      isi: c.isi,
      kategori: c.kategori,
      dibuatPada: c.dibuatPada,
    );

    listCatatan.add(catatanBaru);

    final String jsonString = jsonEncode(listCatatan.map((e) => e.toMap()).toList());
    await prefs.setString(_keyCatatan, jsonString);
  }

  // Perbarui Catatan (Update)
  Future<void> update(Catatan c) async {
    final prefs = await SharedPreferences.getInstance();
    final listCatatan = await getAll();

    final index = listCatatan.indexWhere((element) => element.id == c.id);
    if (index != -1) {
      listCatatan[index] = c;
      final String jsonString = jsonEncode(listCatatan.map((e) => e.toMap()).toList());
      await prefs.setString(_keyCatatan, jsonString);
    }
  }

  // Hapus Catatan (Delete)
  Future<void> delete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final listCatatan = await getAll();

    listCatatan.removeWhere((element) => element.id == id);

    final String jsonString = jsonEncode(listCatatan.map((e) => e.toMap()).toList());
    await prefs.setString(_keyCatatan, jsonString);
  }
}