import 'package:cloud_firestore/cloud_firestore.dart';

/////////////////////////////////////////////////////////////
/// QUIZ SERVICE
/////////////////////////////////////////////////////////////

class QuizService {

  ///////////////////////////////////////////////////////////
  /// FIRESTORE INSTANCE
  ///////////////////////////////////////////////////////////

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  ///////////////////////////////////////////////////////////
  /// SAVE QUIZ RESULT
  ///////////////////////////////////////////////////////////

  Future<void> saveQuizResult(
      Map<String, dynamic> result,
      ) async {

    final snapshot =
    await _firestore
        .collection('quiz_results')
        .where(
      'userId',
      isEqualTo: result['userId'],
    )
        .where(
      'category',
      isEqualTo: result['category'],
    )
        .get();

    /////////////////////////////////////////////////////////
    /// CHECK EXISTING RESULT
    /////////////////////////////////////////////////////////

    if (snapshot.docs.isNotEmpty) {

      ///////////////////////////////////////////////////////
      /// UPDATE EXISTING RESULT
      ///////////////////////////////////////////////////////

      await snapshot.docs.first.reference.update({

        'score': result['score'],

        'wrongAnswer':
        result['wrongAnswer'],

        'totalQuestion':
        result['totalQuestion'],

        'percentage':
        result['percentage'],

        'timestamp':
        result['timestamp'],
      });

    } else {

      ///////////////////////////////////////////////////////
      /// CREATE NEW RESULT
      ///////////////////////////////////////////////////////

      await _firestore
          .collection('quiz_results')
          .add(result);
    }
  }

  ///////////////////////////////////////////////////////////
  /// GET USER QUIZ RESULTS
  ///////////////////////////////////////////////////////////

  Future<List<Map<String, dynamic>>>
  getUserResults(
      String userId,
      ) async {

    final snapshot =
    await _firestore
        .collection('quiz_results')
        .where(
      'userId',
      isEqualTo: userId,
    )
        .get();

    return snapshot.docs
        .map((doc) => doc.data())
        .toList();
  }

  ///////////////////////////////////////////////////////////
  /// DELETE USER QUIZ RESULTS
  ///////////////////////////////////////////////////////////

  Future<void> deleteUserResults(
      String userId,
      ) async {

    final snapshot =
    await _firestore
        .collection('quiz_results')
        .where(
      'userId',
      isEqualTo: userId,
    )
        .get();

    for (var doc in snapshot.docs) {

      await doc.reference.delete();
    }
  }
}