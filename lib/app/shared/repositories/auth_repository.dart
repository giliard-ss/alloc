import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class IAuthRepository {
  User getUser();
  Future<User> getGoogleLogin();
  Future<String> getToken();
  Future<void> googleLogout();
}

class AuthRepository implements IAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User> getGoogleLogin() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // Once signed in, return the UserCredential
    UserCredential result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  @override
  Future<String> getToken() {
    return null;
  }

  @override
  User getUser() {
    return _auth.currentUser;
  }

  @override
  Future<void> googleLogout() async {
    await _googleSignIn.signOut();
    return _auth.signOut();
  }
}
