import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_app_in_flutter/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Ref ref;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService(this.ref);

  // Login
  Future<UserCredential?> signIn(
      String email,
      String password,
      ) async {
    try {
      final UserCredential result =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserState(true);

      return result;
    } on FirebaseAuthException catch (e) {
      throw Exception("Login Failed: ${e.message}");
    }
  }

  // Register
  Future<UserCredential?> createUser(
      String username,
      String email,
      String password,
      ) async {
    try {
      // Check user already exists in Firestore
      final bool exists = await _checkUserExists(email);

      if (exists) {
        throw Exception("User with this email already exists");
      }

      // Create Firebase Auth user
      final UserCredential result =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user to Firestore
      await _addUserToDatabase(
        username,
        email,
      );


      await _saveUserState(true);

      return result;
    } catch (e) {
      throw Exception("Register failed: $e");
    }
  }

  // Add user to Firestore
  Future<void> _addUserToDatabase(
      String username,
      String email,
      ) async {
    try {
      final UserModel user = UserModel(
        username: username,
        email: email,
      );

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(user.toMap());
    } catch (e) {
      throw Exception("Failed to save user: $e");
    }
  }

  // Check user exists
  Future<bool> _checkUserExists(String email) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result =
      await _firestore
          .collection("users")
          .where(
        "email",
        isEqualTo: email,
      )
          .limit(1)
          .get();

      return result.docs.isNotEmpty;
    } catch (e) {
      throw Exception("Error in checking user: $e");
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _saveUserState(false);
  }

  // Save login state
  Future<void> _saveUserState(bool isLoggedIn) async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      'isLoggedIn',
      isLoggedIn,
    );
  }

  // Get login state
  Future<bool> getUserState() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }
}