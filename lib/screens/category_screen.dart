import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categories = ['Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan'];
  TextEditingController newCategoryController = TextEditingController();

  void _addCategory() {
    if (newCategoryController.text.isNotEmpty) {
      setState(() {
        categories.add(newCategoryController.text);
        newCategoryController.clear();
      });
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