import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () => FirebaseAuth.instance.signOut(),
              label: const Text(
                "Sign Out",
                style: TextStyle(fontSize: 32),
              ),
              icon: const Icon(
                Icons.lock_open,
                size: 32,
              ),
            ),
            Center(child: Text("Signed In as  ${user.email}"))
          ],
        ),
      ),
    );
  }
}
