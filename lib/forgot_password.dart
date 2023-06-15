import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:email_validator/email_validator.dart";
import "Util.dart";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailcontroller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();

    super.dispose();
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text.trim());
      Util.showSnackBar("Password Reset Email Sent");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      print(e.message);
      Util.showSnackBar(e.message);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  "Receive an Email to reset your password ",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextFormField(
                  controller: emailcontroller,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: "Email"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value != null && !EmailValidator.validate(value)
                          ? "Enter a valid email "
                          : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: resetPassword,
                  label: const Text(
                    "Reset Password  ",
                    style: TextStyle(fontSize: 32),
                  ),
                  icon: const Icon(
                    Icons.lock_open,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
