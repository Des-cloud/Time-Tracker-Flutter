import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBaseClass{
  User get currentUser;
  Stream<User> authStateChanges();
  Future<User> loginAnon();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> logout();
}

class Authentication implements AuthBaseClass{
  final _auth= FirebaseAuth.instance;

  //Stream builder code
  @override
  Stream<User> authStateChanges()=> _auth.authStateChanges();

  @override
  User get currentUser=> _auth.currentUser;

  @override
  Future<User> loginAnon() async{
    final userCredential= await _auth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<User> signInWithGoogle() async{
    final googleSignIn= GoogleSignIn();
    final googleUSer= await googleSignIn.signIn();
    if(googleUSer != null){
      final googleAuth= await googleUSer.authentication;
      if(googleAuth != null){
        final userCredential= await _auth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
        ));
        return userCredential.user;
      }else{
        throw FirebaseAuthException(message: "Missing google id token", code: "ERROR_MISSING_GOOGLE_ID_TOKEN");
      }
    }else{
      throw FirebaseAuthException(message: "Sign in not permitted. Sign in returned null", code: "ERROR_ABORTED_LOGIN");
    }
  }

  @override
  Future<User> signInWithFacebook() async{
    final facebookSignIn= FacebookLogin();
    final facebookUser= await facebookSignIn.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch(facebookUser.status){
      case FacebookLoginStatus.Success:
        final fbAccess= facebookUser.accessToken;
        final userCredential= await _auth.signInWithCredential(FacebookAuthProvider.credential(fbAccess.token));
        return userCredential.user;
      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(message: "Login aborted by user", code: "ERROR_ABORTED_BY_USER");
      case FacebookLoginStatus.Error:
        throw FirebaseAuthException(message: facebookUser.error.developerMessage, code: "ERROR_LOGIN_ABORTED_BY_FACEBOOK");
      default:
        throw UnimplementedError("Not implemented");
    }

  }

  @override
  Future<void> logout() async{
    final googleSignIn= GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin= FacebookLogin();
    await facebookLogin.logOut();
    await _auth.signOut();
  }
}