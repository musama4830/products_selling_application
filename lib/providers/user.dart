import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class User {
  XFile image;
  String id;
  String name;
  String email;
  String password;
  String location;

  User({
    required this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.location,
  });
}

class Users with ChangeNotifier {
  String _userDataToken;
  String userDataId = 'null';
  String userDataEmail = 'null';
  String userDataPassword = 'null';
  Users(this._userDataToken, this.userDataId, this.userDataEmail, this.userDataPassword);

  CollectionReference fbUser = FirebaseFirestore.instance.collection('user');
  final storage = FirebaseStorage.instance;

  // final List<User> _user = [];
  // List<User> get items {
  //   return [..._user];
  // }
  User _user = User(
    image: XFile('null'),
    id: 'null',
    name: 'null',
    email: 'null',
    password: 'null',
    location: 'null',
  );
  User get user {
    _user.id = userDataId;
    _user.email = userDataEmail;
    _user.password = userDataPassword;
    notifyListeners();
    return _user;
  }

  Future<void> addUserdata(User user) async {
    await fbUser.doc(userDataId).set({
      'name': user.name,
      'location': user.location,
    });
    try{
      await storage.ref('/user_image/$userDataId').putFile(File(user.image.path));
    } on firebase_core.FirebaseException catch (error) {
      print(error);
    }

    _user = User(
      image: user.image,
      id: userDataId,
      name: user.name,
      email: userDataEmail,
      password: userDataPassword,
      location: user.location,
    );
    notifyListeners();
  }

  // void updateUser(String id, User user) {
  //   final prodIndex = _user.indexWhere((userData) => userData.id == id);
  //   if (prodIndex >= 0) {
  //     _user[prodIndex] = User(
  //       image: user.image,
  //       id: id,
  //       name: user.name,
  //       email: user.email,
  //       password: user.password,
  //       location: user.location,
  //     );
  //     notifyListeners();
  //   } else {
  //     print('\n...\n...\n...\n');
  //   }
  // }
}
