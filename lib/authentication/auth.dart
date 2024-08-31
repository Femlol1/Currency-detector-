//impports the nessasry libraries
import 'package:currency_detector/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

//authentication class
class Auth {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          // If the snapshot contains data, that means the user is authenticated
          if (snapshot.hasData) {
            // So, we send them to the home page
            return SwipeNavigation(); //or main page ;
          } else {
            // If the snapshot doesn't contain data, that means the user is not authenticated
            // So, we show them the LoginPage
            return const LoginPage();
          }
        });
  }

//google sign in function
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();
// If the Google sign-in was successful
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        // Create a new authentication credential using the Google sign-in details
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Sign into Firebase with the Google credential
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

//sign out function
  signOut() {
    //calls the Firebase signout function
    FirebaseAuth.instance.signOut();
  }
}
