import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width to adjust the input fields' width
    double screenWidth = MediaQuery.of(context).size.width;
    double inputWidth =
        screenWidth * 0.8; // Set input width to 80% of the screen width

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.deepOrange, // AppBar color set to orange
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title text
              const Text(
                'Login to Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 40),

              // Email input
              SizedBox(
                width: inputWidth,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ), // Label color
                    fillColor: Colors.black,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white), // Text color
                ),
              ),
              const SizedBox(height: 20),

              // Password input
              SizedBox(
                width: inputWidth,
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ), // Label color
                    fillColor: Colors.black,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white), // Text color
                ),
              ),
              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: inputWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.deepOrange, // Button color set to orange
                  ),
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;

                    // Add your authentication logic here
                    print('Email: $email, Password: $password');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 18, // Text size
                      fontWeight: FontWeight.bold, // Optional: bold text
                    ),
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
