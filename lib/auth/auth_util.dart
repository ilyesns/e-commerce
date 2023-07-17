import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_user_provider.dart';

Future<User?> signInOrCreateAccount(
  BuildContext context,
  Future<UserCredential?> Function() signInFunc,
  String authProvider,
) async {
  try {
    final userCredential = await signInFunc();
    if (userCredential?.user != null) {
      // await maybeCreateUser(userCredential!.user!);
    }
    return userCredential?.user;
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message!}')),
    );
    return null;
  }
}

// Future maybeCreateUser(User user) async {
//   final userRecord = UsersRecord.collection.doc(user.uid);
//   final userExists = await userRecord.get().then((u) => u.exists);
//   if (userExists) {
//     currentUserDocument = await UsersRecord.getDocumentOnce(userRecord);
//     return;
//   }

//   final userData = createUsersRecordData(
//     email: user.email,
//     displayName: user.displayName,
//     photoUrl: user.photoURL,
//     uid: user.uid,
//     phoneNumber: user.phoneNumber,
//     createdTime: getCurrentTimestamp,
//   );

//   await userRecord.set(userData);
//   currentUserDocument =
//       serializers.deserializeWith(UsersRecord.serializer, userData);
// }

Future resetPassword(
    {required String email, required BuildContext context}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message!}')),
    );
    return null;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Password reset email sent')),
  );
}

Future sendEmailVerification() async =>
    currentUser?.user?.sendEmailVerification();

// String get currentUserEmail =>
//     currentUserDocument?.email ?? currentUser?.user?.email ?? '';

// String get currentUserUid => currentUser?.user?.uid ?? '';

// String get currentUserDisplayName =>
//     currentUserDocument?.displayName ?? currentUser?.user?.displayName ?? '';

// String get currentUserPhoto =>
//     currentUserDocument?.photoUrl ?? currentUser?.user?.photoURL ?? '';

// String get currentPhoneNumber =>
//     currentUserDocument?.phoneNumber ?? currentUser?.user?.phoneNumber ?? '';

// String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified {
  // Reloads the user when checking in order to get the most up to date
  // email verified status.
  if (currentUser?.user != null && !currentUser!.user!.emailVerified) {
    currentUser!.user!
        .reload()
        .then((_) => currentUser!.user = FirebaseAuth.instance.currentUser);
  }
  return currentUser?.user?.emailVerified ?? false;
}

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

// Set when using phone verification (after phone number is provided).
String? _phoneAuthVerificationCode;
// Set when using phone sign in in web mode (ignored otherwise).
ConfirmationResult? _webPhoneAuthConfirmationResult;

Future beginPhoneAuth({
  required BuildContext context,
  required String phoneNumber,
  required VoidCallback onCodeSent,
}) async {
  if (kIsWeb) {
    _webPhoneAuthConfirmationResult =
        await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
    onCodeSent();
    return;
  }
  final completer = Completer<bool>();
  // If you'd like auto-verification, without the user having to enter the SMS
  // code manually. Follow these instructions:
  // * For Android: https://firebase.google.com/docs/auth/android/phone-auth?authuser=0#enable-app-verification (SafetyNet set up)
  // * For iOS: https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0#start-receiving-silent-notifications
  // * Finally modify verificationCompleted below as instructed.
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: Duration(seconds: 5),
    verificationCompleted: (phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      // If you've implemented auto-verification, navigate to home page or
      // onboarding page here manually. Uncomment the lines below and replace
      // DestinationPage() with the desired widget.
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) => DestinationPage()),
      // );
    },
    verificationFailed: (e) {
      completer.complete(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.message!}'),
      ));
    },
    codeSent: (verificationId, _) {
      _phoneAuthVerificationCode = verificationId;
      completer.complete(true);
      onCodeSent();
    },
    codeAutoRetrievalTimeout: (_) {},
  );

  return completer.future;
}

Future verifySmsCode({
  required BuildContext context,
  required String smsCode,
}) async {
  if (kIsWeb) {
    return signInOrCreateAccount(
      context,
      () => _webPhoneAuthConfirmationResult!.confirm(smsCode),
      'PHONE',
    );
  } else {
    final authCredential = PhoneAuthProvider.credential(
        verificationId: _phoneAuthVerificationCode!, smsCode: smsCode);
    return signInOrCreateAccount(
      context,
      () => FirebaseAuth.instance.signInWithCredential(authCredential),
      'PHONE',
    );
  }
}

// DocumentReference? get currentUserReference => currentUser?.user != null
//     ? UsersRecord.collection.doc(currentUser!.user!.uid)
//     : null;

// UsersRecord? currentUserDocument;
// final authenticatedUserStream = FirebaseAuth.instance
//     .authStateChanges()
//     .map<String>((user) => user?.uid ?? '')
//     .switchMap(
//       (uid) => uid.isEmpty
//           ? Stream.value(null)
//           : UsersRecord.getDocument(UsersRecord.collection.doc(uid))
//               .handleError((_) {}),
//     )
//     .map((user) => currentUserDocument = user)
//     .asBroadcastStream();
