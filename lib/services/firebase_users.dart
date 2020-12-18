import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connector/models/user_model.dart';
import 'package:connector/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');

class FirebaseUserService {
  static final FirebaseUserService _instance =
      new FirebaseUserService.internal();

  factory FirebaseUserService() => _instance;

  FirebaseUserService.internal();

  Future<UserModel> createUser(String id, Map<String, dynamic> user) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(userCollection.doc(id));

      final Map<String, dynamic> data = user;

      tx.set(ds.reference, data);

      return data;
    };

    return FirebaseFirestore.instance
        .runTransaction(createTransaction)
        .then((mapData) {
      return UserModel.fromTransaction(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future<dynamic> updateUser(UserModel user) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(userCollection.doc(user.uid));

      tx.update(ds.reference, user.toPostJson());
      return {'updated': true, 'data': user.toPostJson()};
    };

    return FirebaseFirestore.instance
        .runTransaction(updateTransaction)
        .then((result) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userInfo');
      UserModel responseUser =
          UserModel.fromTransaction(result['data'].cast<String, dynamic>());
      responseUser.isProviderAuth = globalUserInfo.isProviderAuth;
      globalUserInfo = responseUser;
      await prefs.setString('userInfo', json.encode(responseUser.toJson()));
      return result['updated'];
    }).catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Future<dynamic> deleteUser(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(userCollection.doc(id));

      tx.delete(ds.reference);
      return {'deleted': true};
    };

    return FirebaseFirestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Stream<QuerySnapshot> getUserList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = userCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  getUser({String id}) async {
    final DocumentReference ref = userCollection.doc(id);
    final DocumentSnapshot snapshot = await ref.get();

    return snapshot.data();
  }

  Stream<DocumentSnapshot> getUserSnapShot({String id}) {
    Stream<DocumentSnapshot> snapshots = userCollection.doc(id).snapshots();
    return snapshots;
  }
}
