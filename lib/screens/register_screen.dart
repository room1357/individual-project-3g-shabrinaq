import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B7AB8),
              Color(0xFF6B5B95),
              Color(0xFF4A4063),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  
                  // Profile icon 
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFB4A5D5),
                          Color(0xFF9B87C6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9B87C6).withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 25),

                  // Judul
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign up to get started',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 35),

                  // Full Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: fullNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Username Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: usernameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Confirm Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Register Button
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD4C5F9),
                          Color(0xFFB4A5D5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFB4A5D5).withOpacity(0.5),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (passwordController.text != confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password dan Confirm Password tidak cocok!')),
                          );
                          return;
                        }

                        final username = usernameController.text;
                        final password = passwordController.text;
                        final email = emailController.text;
                        final fullName = fullNameController.text;
                        
                        AuthService.registerUser(
                          username: username,
                          password: password,
                          email: email,
                          fullName: fullName,
                        ).then((result) {
                          if (result['success']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result['message'])),
                            );

                            // Setelah register, langsung ke halaman login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result['message'])),
                            );
                          }
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Terjadi kesalahan: $error')),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4063),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Link to login page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigasi ke LoginScreen dengan pop
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Color(0xFFD4C5F9),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFD4C5F9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}