import 'package:shared_preferences/shared_preferences.dart';

class CategoryStorage {
  static const String _key = 'categories';

  // Ambil semua kategori
  static Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ??
        ['Makanan', 'Transportasi', 'Hiburan', 'Pendidikan', 'Utilitas'];
  }

  // Tambah kategori baru
  static Future<void> addCategory(String newCategory) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getCategories();

    if (!categories.contains(newCategory)) {
      categories.add(newCategory);
      await prefs.setStringList(_key, categories);
      print('Kategori "$newCategory" ditambahkan.');
    } else {
      print('Kategori "$newCategory" sudah ada.');
    }
  }

  // Hapus kategori
  static Future<void> removeCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getCategories();
    categories.remove(category);
    await prefs.setStringList(_key, categories);
    print('Kategori "$category" dihapus.');
  }

  // Reset ke default
  static Future<void> resetCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final defaultCategories = [
      'Makanan',
      'Transportasi',
      'Hiburan',
      'Pendidikan',
      'Utilitas'
    ];
    await prefs.setStringList(_key, defaultCategories);
    print('Kategori direset ke default.');
  }
}