import "package:flutter/material.dart";
import "package:firebase_auth2/main.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:email_validator/email_validator.dart";
import "Util.dart";

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignUpWidget({required this.onClickedSignIn, super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future SignUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text.trim());
    } on FirebaseException catch (e) {
      print(e);
      // ScaffoldMessenger(child: SnackBar(content: Text("${e.message}")));
      Util.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
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
                height: 4,
              ),
              TextFormField(
                controller: passwordcontroller,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Password"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? "Enter min 6 characters "
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: SignUp,
                label: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 32),
                ),
                icon: const Icon(
                  Icons.lock_open,
                  size: 32,
                ),
              ),
              Center(
                child: Row(
                  children: [
                    const Text.rich(TextSpan(children: [
                      TextSpan(text: "Already have an account?"),
                    ])),
                    GestureDetector(
                      onTap: widget.onClickedSignIn,
                      child: const Text(
                        "Log In",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
