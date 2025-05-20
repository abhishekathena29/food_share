import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get loading => _isLoading;

  String? _error;
  String? get error => _error;
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String pass) async {
    _isLoading = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection("user")
            .doc(userCredential.user!.uid)
            .set({"email": email});
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //  Future _register() async {
  //   if (_dobController.text.isEmpty ||
  //       _nameController.text.isEmpty ||
  //       _emailController.text.isEmpty ||
  //       _passwordController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Complete the form to proceed')));
  //     return;
  //   }
  //   if (_selectedCurrency == null) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Select Your Currency')));
  //     return;
  //   }
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: _emailController.text.trim(),
  //             password: _passwordController.text.trim());
  //     if (userCredential.user != null) {
  //       await FirebaseFirestore.instance
  //           .collection("user")
  //           .doc(userCredential.user!.uid)
  //           .set({
  //         "email": _emailController.text.trim(),
  //         "dob": Timestamp.fromDate(_selectedDate!),
  //         "name": _nameController.text.trim(),
  //         'currencyName': _selectedCurrency!.name,
  //         'currencyCode': _selectedCurrency!.code,
  //         'currencySymbol': _selectedCurrency!.symbol,
  //       });
  //     }
  //     if (mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const Homepage()),
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     // Handle errors
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(e.message.toString()),
  //       ));
  //     }
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  //   // }
  // }
}
