import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../screens/user_data_screen.dart';

class MyAccountScreen extends StatelessWidget {
  static const routeName = '/my_account_screen';
  String? _email;

  listWidget(BuildContext context, Icon _icon, String _title) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      color: Theme.of(context).backgroundColor.withOpacity(0.2),
      child: GridTileBar(
        leading: Container(
          height: 50,
          width: 50,
          child: _icon,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Text(
            _title,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User _userInfo = Provider.of<Users>(context).user;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(UserDataScreen.routeName);
          },
          child: Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            color: Theme.of(context).backgroundColor.withOpacity(0.2),
            child: GridTileBar(
              leading: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: _userInfo.name != 'null'
                      ? Image.file(
                          File(_userInfo.image.path),
                          fit: BoxFit.cover,
                        )
                      : const Text('Image'),
                ),
              ),
              title: Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  _userInfo.name != 'null' ? _userInfo.name.toString() : 'Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
              subtitle: Text(
                _userInfo.email != 'null'
                    ? _userInfo.email.toString()
                    : "Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        listWidget(context, const Icon(Icons.list), "My Listings"),
        const SizedBox(height: 1),
        listWidget(context, const Icon(Icons.email), "My Messages"),
      ],
    );
  }
}
