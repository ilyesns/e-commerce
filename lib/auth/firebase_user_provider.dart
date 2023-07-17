import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseUserProvider {
  FirebaseUserProvider(this.user);
  User? user;
  bool get loggedIn => user != null;
}

FirebaseUserProvider? currentUser;

bool get loggedIn => currentUser?.loggedIn ?? false;

Stream<FirebaseUserProvider> firebaseUserProviderStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<FirebaseUserProvider>(
      (user) {
        currentUser = FirebaseUserProvider(user);

        return currentUser!;
      },
    );
