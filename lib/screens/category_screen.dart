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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Edit Category',
          style: TextStyle(
            color: Color(0xFF5D4E7C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8F6FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: newCategoryController,
            style: TextStyle(color: Color(0xFF5D4E7C)),
            decoration: InputDecoration(
              hintText: 'Category Name',
              hintStyle: TextStyle(color: Color(0xFF9B8BB4)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFF8F6FA),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
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
            child: Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF7B68AA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              newCategoryController.clear();
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF9B8BB4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete Category',
          style: TextStyle(
            color: Color(0xFF5D4E7C),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${categories[index]}"?',
          style: TextStyle(color: Color(0xFF5D4E7C)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                categories.removeAt(index);
              });
              _saveCategories();
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Color(0xFFB89090),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF9B8BB4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.restaurant_rounded;
      case 'transportasi':
        return Icons.directions_car_rounded;
      case 'utilitas':
        return Icons.home_rounded;
      case 'hiburan':
        return Icons.movie_rounded;
      case 'pendidikan':
        return Icons.school_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (currentUser == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark 
              ? [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                ]
              : [
                  Color(0xFF8B7AB8),
                  Color(0xFF6B5B95),
              ],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
              ? [
                  Color(0xFF1a1a2e), 
                  Color(0xFF16213e),
                  Color(0xFF0f3460),
                ]
              : [
                  Color(0xFF8B7AB8),
                  Color(0xFF6B5B95),
                  Color(0xFF4A4063),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Manage Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF1e1e2e) : Color(0xFFF5F3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        // List kategori
                        Expanded(
                          child: ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? Color(0xFF2d2d44) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF9B87C6).withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  leading: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF7B68AA).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(category),
                                      color: Color(0xFF7B68AA),
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF5D4E7C),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF7B68AA).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.edit_rounded, color: Color(0xFF7B68AA)),
                                          iconSize: 20,
                                          onPressed: () => _editCategory(index),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFB89090).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.delete_rounded, color: Color(0xFFB89090)),
                                          iconSize: 20,
                                          onPressed: () => _deleteCategory(index),
                                        ),
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
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFD4C5F9),
              Color(0xFFB4A5D5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB4A5D5).withOpacity(0.5),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Add Category',
                  style: TextStyle(
                    color: Color(0xFF5D4E7C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F6FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: newCategoryController,
                    style: TextStyle(color: Color(0xFF5D4E7C)),
                    decoration: InputDecoration(
                      hintText: 'Category Name',
                      hintStyle: TextStyle(color: Color(0xFF9B8BB4)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF8F6FA),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _addCategory();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Color(0xFF7B68AA),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      newCategoryController.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF9B8BB4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add_rounded, color: Color(0xFF4A4063), size: 32),
        ),
      ),
    );
  }
}