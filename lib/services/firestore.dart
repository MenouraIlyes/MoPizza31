import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mopizza/models/cart_item.dart';

class FirestoreService {
  // get the collection of orders
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  // CREATE: Add a new order
  Future<void> addOrder(List<CartItem> cartItems) {
    List<Map<String, dynamic>> cartItemsMap =
        cartItems.map((item) => item.toMap()).toList();
    return orders.add({
      'order': cartItemsMap,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: Get all orders from the database
  Future<List<Map<String, dynamic>>> getOrders() async {
    QuerySnapshot snapshot = await orders.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // UPDATE: Update an order with a doc id
  Future<void> updateOrder(String docId, List<CartItem> updatedCartItems) {
    List<Map<String, dynamic>> updatedCartItemsMap =
        updatedCartItems.map((item) => item.toMap()).toList();
    return orders.doc(docId).update({
      'order': updatedCartItemsMap,
      'timestamp': Timestamp.now(), // Update the timestamp if needed
    });
  }

  // DELETE: Delete an order from the database
  Future<void> deleteOrder(String docId) {
    return orders.doc(docId).delete();
  }
}

class AuthService {
  // Google sing in
  Future<bool> signInwithGoogle() async {
    try {
      // begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // The user canceled the sign-in
        return false;
      }

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // finally, lets sign in
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // facebook sign in
  Future<bool> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken!.tokenString);
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Optional: Get user data from Facebook
        final userData = await FacebookAuth.instance.getUserData();
        // Use userData here (e.g., print(userData['email']))

        return true;
      } else if (result.status == LoginStatus.cancelled) {
        print('Login cancelled by user');
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
