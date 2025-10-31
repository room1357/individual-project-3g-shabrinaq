import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categories = ['Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan'];
  TextEditingController newCategoryController = TextEditingController();
  User? currentUser;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentUser(); 
  }

  @override
  void dispose() {
    newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        currentUser = user;
      });
      await _loadCategories();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadCategories() async {
    if (currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    final key = 'categories_${currentUser!.username}';
    final storedData = prefs.getStringList(key);

    setState(() {
      categories = storedData ?? [
        'Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan',
      ];
    });
  }

  Future<void> _saveCategories() async {
    if (currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    final key = 'categories_${currentUser!.username}'; 
    await prefs.setStringList(key, categories);
  }

  void _addCategory() {
    if (newCategoryController.text.isNotEmpty) {
      setState(() {
        categories.add(newCategoryController.text.trim());
        newCategoryController.clear();
      });
      _saveCategories();
    }
  }
  
  void _editCategory(int index) {
    newCategoryController.text = categories[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Kategori'),
        content: TextField(
          controller: newCategoryController,
          decoration: InputDecoration(hintText: 'Nama Kategori'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newCategoryController.text.isNotEmpty) {
                setState(() {
                  categories[index] = newCategoryController.text;
                  newCategoryController.clear();
                });
                _saveCategories();
              }
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          ),
          TextButton(
            onPressed: () {
              newCategoryController.clear();
              Navigator.pop(context);
            },
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Kategori'),
        content: Text('Apakah yakin ingin menghapus kategori "${categories[index]}"?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                categories.removeAt(index);
              });
              _saveCategories();
              Navigator.pop(context);
            },

            
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Kategori',
          style: TextStyle(color: Colors.black), 
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List kategori
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    elevation: 3,
                    child: ListTile(
                      title: Text(category),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: const Color.fromARGB(255, 191, 99, 245)),
                            onPressed: () => _editCategory(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Tambah Kategori'),
              content: TextField(
                controller: newCategoryController,
                decoration: InputDecoration(hintText: 'Nama Kategori'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _addCategory();
                    Navigator.pop(context);
                  },
                  child: Text('Tambah'),
                ),
                TextButton(
                  onPressed: () {
                    newCategoryController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Batal'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}