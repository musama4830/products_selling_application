import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

class UserDataScreen extends StatefulWidget {
  static const routeName = '/user_data_screen';

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  String _userId = 'null';
  XFile? _image;
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedUserData = User(
    image: XFile('null'),
    id: '',
    name: '',
    email: '',
    password: '',
    location: '',
  );
  var _initValues = {
    'id': '',
    'name': '',
    'email': '',
    'password': '',
    'location': '',
  };
  var _isInit = true;
  var _isImageEmpty = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // _productId = ModalRoute.of(context)!.settings.arguments;
      // if (_productId != 'null') {
      //   _editedProduct =
      //       Provider.of<Products>(context, listen: false).findById(_productId);
      //   _initValues = {
      //     'id': _editedProduct.id,
      //     'title': _editedProduct.title,
      //     'totalQuantity': _editedProduct.totalQuantity.toString(),
      //     'purchasePrice': _editedProduct.purchasePrice.toString(),
      //     'salePrice': _editedProduct.salePrice.toString(),
      //   };
      // }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    setState(() {
      _editedUserData.image = _image as XFile;
      _editedUserData.id = DateTime.now().toString();
    });
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _updateImage();
    _form.currentState!.save();
    await Future.delayed(const Duration(milliseconds: 100), () {
      if (_userId != 'null') {
      } else {
        Provider.of<Users>(context, listen: false).addUserdata(_editedUserData);
      }
    });
    Navigator.of(context).pop();
  }

  _getFromGallery() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _image = pickedFile as XFile;
      setState(() {
        _isImageEmpty = false;
      });
      Navigator.of(context).pop();
    }
  }

  _getFromCamera() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      _image = pickedFile as XFile;
      setState(() {
        _isImageEmpty = false;
      });
      Navigator.of(context).pop();
    }
  }

  void takePhoto() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 110,
            color: Theme.of(context).backgroundColor,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.camera),
                        onPressed: () {
                          _getFromCamera();
                        }),
                    const SizedBox(height: 5),
                    const Text('Camera')
                  ],
                ),
                const SizedBox(width: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: () {
                          _getFromGallery();
                        }),
                    const SizedBox(height: 5),
                    const Text('Gallery')
                  ],
                ),
              ],
            ),
          );
        });
  }

  buttonWidget() {
    return Center(
      child: Container(
        height: 120,
        width: 120,
        margin: const EdgeInsets.only(bottom: 10),
        child: !_isImageEmpty
            ? Image.file(
                File(_image!.path),
                fit: BoxFit.cover,
              )
            : IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: takePhoto,
              ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).backgroundColor.withOpacity(0.1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text(
          'Account Info',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _form,
              child: Expanded(
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      // initialValue: _initValues['name'],
                      decoration: const InputDecoration(labelText: 'Name'),
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUserData = User(
                          image: _editedUserData.image,
                          id: _editedUserData.id,
                          name: value.toString(),
                          email: _editedUserData.email,
                          password: _editedUserData.password,
                          location: _editedUserData.location,
                        );
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['email'],
                      decoration: const InputDecoration(labelText: 'Email'),
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a email.';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUserData = User(
                          image: _editedUserData.image,
                          id: _editedUserData.id,
                          name: _editedUserData.name,
                          email: value.toString(),
                          password: _editedUserData.password,
                          location: _editedUserData.location,
                        );
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['password'],
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_locationFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password.';
                        }
                        if (value.length < 7) {
                          return 'Please enter a strong password.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUserData = User(
                          image: _editedUserData.image,
                          id: _editedUserData.id,
                          name: _editedUserData.name,
                          email: _editedUserData.email,
                          password: value.toString(),
                          location: _editedUserData.location,
                        );
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['location'],
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a location.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUserData = User(
                          image: _editedUserData.image,
                          id: _editedUserData.id,
                          name: _editedUserData.name,
                          email: _editedUserData.email,
                          password: _editedUserData.password,
                          location: value.toString(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    buttonWidget(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Sava Data'),
                      onPressed: _saveForm,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
