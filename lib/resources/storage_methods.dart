import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    try {
      TaskSnapshot snapshot = await ref.putData(file);

      // Use the completed property to await the upload completion
      await snapshot.ref.getDownloadURL();

      return snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return ''; // Return an appropriate value or throw an exception
    }
  }
}
