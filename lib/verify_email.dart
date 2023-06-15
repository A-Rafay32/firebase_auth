import "dart:async";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth2/home_page.dart";
import "package:flutter/material.dart";
import "Util.dart";

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isVerified = false;
  bool canResend = false;
  Timer? timer;

  @override
  void initState() {
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      sendVerificationEmail();
      timer =
          Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified);
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    //call after email verification
    await FirebaseAuth.instance.currentUser!.reload();
    //so that build method can show you HomePage when email is verified
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    // if verified cancel the timer
    if (isVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      //get current user
      final user = FirebaseAuth.instance.currentUser!;
      // send verification email  to that user
      await user.sendEmailVerification();

      // setState(() {
      //   canResend = false;
      // });
      // const Duration(seconds: 5);
      // setState(() {
      //   canResend = true;
      // });
    } on FirebaseAuthException catch (e) {
      Util.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isVerified)
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Verify Email"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Verification email has been sent to ${FirebaseAuth.instance.currentUser!.email}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () =>
                        // (canResend) ?
                        sendVerificationEmail(),
                    // : null,
                    label: const Text(
                      "Resend Email",
                      style: TextStyle(fontSize: 32),
                    ),
                    icon: const Icon(
                      Icons.email_outlined,
                      size: 32,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    label: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 32),
                    ),
                    icon: const Icon(
                      Icons.email_outlined,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
