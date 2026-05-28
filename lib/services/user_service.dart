import 'package:cloud_firestore/cloud_firestore.dart';

/////////////////////////////////////////////////////////////
/// USER SERVICE
/////////////////////////////////////////////////////////////

class UserService {

  ///////////////////////////////////////////////////////////
  /// FIRESTORE INSTANCE
  ///////////////////////////////////////////////////////////

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  ///////////////////////////////////////////////////////////
  /// INSERT NEW USER
  ///////////////////////////////////////////////////////////

  Future<void> insertUser(
      Map<String, dynamic> user,
      ) async {

    await _firestore
        .collection('users')
        .add(user);

    print(
      "USER INSERTED SUCCESSFULLY",
    );
  }

  ///////////////////////////////////////////////////////////
  /// LOGIN USER
  ///////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>>
  loginUser(

      String email,
      String password,

      ) async {

    final snapshot =
    await _firestore
        .collection('users')
        .where(
      'email',
      isEqualTo: email,
    )
        .where(
      'password',
      isEqualTo: password,
    )
        .get();

    return snapshot.docs
        .map((doc) => {

      ...doc.data(),

      'id': doc.id,
    })
        .toList();
  }

  ///////////////////////////////////////////////////////////
  /// CHECK EMAIL EXIST
  ///////////////////////////////////////////////////////////

  Future<bool> checkEmailExists(
      String email,
      ) async {

    final snapshot =
    await _firestore
        .collection('users')
        .where(
      'email',
      isEqualTo: email,
    )
        .get();

    return snapshot.docs.isNotEmpty;
  }

  ///////////////////////////////////////////////////////////
  /// UPDATE USER PROFILE
  ///////////////////////////////////////////////////////////

  Future<void> updateUser(

      String id,
      String name,
      String email,
      String password,

      ) async {

    await _firestore
        .collection('users')
        .doc(id)
        .update({

      'name': name,

      'email': email,

      'password': password,
    });
  }

  ///////////////////////////////////////////////////////////
  /// DELETE USER
  ///////////////////////////////////////////////////////////

  Future<void> deleteUser(
      String id,
      ) async {

    await _firestore
        .collection('users')
        .doc(id)
        .delete();
  }
}