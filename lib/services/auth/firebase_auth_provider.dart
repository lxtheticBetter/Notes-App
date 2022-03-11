import 'package:notesapp/services/auth/auth_user.dart';
import 'package:notesapp/services/auth/auth_provider.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FireBaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createtUser({
    required String email,
    required String password,
  }) async {
    // TODO: implement createtUser
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          {
            throw WeakPasswordAuthException();
          }
        case 'email-already-in-use':
          {
            throw EmailAlreadyInUseAuthException();
          }
        case 'invalid-email':
          {
            throw InvalidEmailAuthException();
          }
        default:
          {
            throw GenerciAuthexception();
          }
      }
    } catch (e) {
      throw GenerciAuthexception();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          {
            throw UserNotFoundAuthException();
          }
        case 'wrong-password':
          {
            throw WrongPasswordAuthException();
          }
        default:
          {
            throw GenerciAuthexception();
          }
      }
    } catch (e) {
      throw GenerciAuthexception();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser; // TODO: implement logOut
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }
}
