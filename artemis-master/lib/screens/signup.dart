import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width to adjust the input fields' width
    double screenWidth = MediaQuery.of(context).size.width;
    double inputWidth =
        screenWidth * 0.8; // Set input width to 80% of the screen width

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title text
              const Text(
                'Welcome to ARTEMIS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 60),

              // Continue with Google
              SizedBox(
                width: inputWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // Background color for the button
                    minimumSize: Size(
                      inputWidth,
                      50,
                    ), // Set width and height for consistency
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    // Add your Google Sign-In logic here
                    print("Sign in with Google pressed");
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons
                            .account_circle, // This is just a placeholder for a Google icon
                        color: Colors.blue, // Google blue icon color
                      ),
                      SizedBox(width: 10), // Space between icon and text
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 16, // Font size
                          fontWeight: FontWeight.bold, // Optional: bold text
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                child: const Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Line color
                        thickness: 1, // Line thickness
                        endIndent: 10, // Left space
                      ),
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                        color: Colors.deepOrange, // Text color
                        fontSize: 16, // Text size
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Line color
                        thickness: 1, // Line thickness
                        indent: 10, // Right space
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

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
                    'Continue with email',
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
