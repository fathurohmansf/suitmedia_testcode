import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia_testcode/provider/name_provider.dart';
import 'package:suitmedia_testcode/screen/second_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController palindromeController = TextEditingController();
  bool isPalindrome = false;

  void checkPalindrome() {
    String cleanedText = palindromeController.text
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
    String reversedText = cleanedText.split('').reversed.join('');
    isPalindrome = cleanedText == reversedText;
  }

  void showPalindromeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Palindrome Check"),
          content: Text(isPalindrome ? "isPalindrome" : "bukan Palindrome"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // agar tidak terjadi bottom overflow
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // SingleChildScrollView(
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(),
                // Profile Picture
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 30),
                // Name Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Palindrome Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: palindromeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // White background for input box
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Palindrome',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Buttons
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          checkPalindrome();
                          showPalindromeDialog(); // Show dialog with result
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2B637B), // Color for the button
                        minimumSize: const Size(350, 50), // Button size
                      ),
                      child: const Text(
                        'CHECK',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Space between buttons
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<NameProvider>(context, listen: false)
                            .setName(nameController.text);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecondScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2B637B), // Color for the button
                        minimumSize: const Size(350, 50), // Button size
                      ),
                      child: const Text(
                        'NEXT',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
