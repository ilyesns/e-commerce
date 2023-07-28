// Delete the image from Firebase Storage
import 'package:firebase_storage/firebase_storage.dart';

Future<void> deleteFileFRomFirebase(String url) async {
  try {
    String filePath = url.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/blueray-market.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference imageRef = storage.ref().child(filePath);

    await imageRef.delete().catchError((val) {
      print('[Error]' + val);
    }).then((_) {
      print('[Sucess] Image deleted');
    });
  } catch (error) {
    print(error);
  }
}
