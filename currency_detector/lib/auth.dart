import 'package:currency_detector/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';
import 'login.dart';

class Auth {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return SwipeNavigation() /*HomePage()*/;
          } else {
            return const LoginPage();
          }
        });
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        // Handle the case when the user cancels the sign-in process
        print("User cancelled Google sign-in");
        return null;
      }
    } catch (error) {
      print("Error during Google sign-in: $error");
      return null;
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
