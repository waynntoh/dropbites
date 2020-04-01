import 'dart:ui';
import 'package:drop_bites/components/custom_drawer.dart';
import 'package:drop_bites/components/history_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/utils/constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AccountView extends StatefulWidget {
  static const String id = 'account_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  double height;
  double width;
  User loggedInUser;
  File _userImage;
  bool editable = false;
  String imageDirectoryUrl = 'http://hackanana.com/dropbites/user_images';
  TextEditingController nameController = TextEditingController();

  Future _getUserImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _userImage = image;
    });

    if (_userImage != null) {
      AccountView.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    color: kOrange3,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Upload image?',
                    style: TextStyle(color: kOrange3),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    color: kOrange0,
                    child: Text(
                      'No',
                      style: kDefaultTextStyle.copyWith(color: Colors.black),
                    ),
                    onPressed: () {
                      AccountView.scaffoldKey.currentState
                          .hideCurrentSnackBar();
                    },
                  ),
                  SizedBox(width: 16),
                  FlatButton(
                    color: kOrange3,
                    child: Text(
                      'Upload',
                      style: kDefaultTextStyle.copyWith(color: Colors.black),
                    ),
                    onPressed: () {
                      AccountView.scaffoldKey.currentState
                          .hideCurrentSnackBar();
                      // TODO: Upload image
                      print('Upload image');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User>(context, listen: false);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: AccountView.scaffoldKey,
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            _buildTopHalf(),
            _buildBottomHalf(),
            _buildHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHalf() {
    return Positioned(
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height / 1.65,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'http://hackanana.com/dropbites/user_images/${loggedInUser.email}.jpg'),
              ),
            ),
          ),
          Container(
            width: width,
            height: height / 1.65,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.75),
                Colors.white.withOpacity(1),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              border: Border.all(
                color: Colors.white.withOpacity(0),
              ),
            ),
          ),
          _buildTopInfo(),
          _buildTopButtons(),
          Positioned(
            top: 36,
            left: 16,
            child: GestureDetector(
              onTap: () {
                AccountView.scaffoldKey.currentState.openDrawer();
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: kGrey3,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: kOrange3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopInfo() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: height / 2.2,
          left: 24,
          height: height / 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                loggedInUser.name,
                style: kDefaultTextStyle.copyWith(
                  fontSize: 32,
                  color: kGrey6,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.at,
                    size: 16,
                    color: kGrey4,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${loggedInUser.email}',
                    style:
                        kDefaultTextStyle.copyWith(fontSize: 18, color: kGrey4),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopButtons() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: height / 2.05,
          right: 72,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: kGrey1,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: GestureDetector(
                onTap: () {
                  _getUserImage();
                },
                child: FaIcon(
                  FontAwesomeIcons.cameraRetro,
                  color: kOrange4,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 2.05,
          right: 16,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: kGrey1,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: GestureDetector(
                onTap: () {
                  // TODO: Edit info
                  print('Edit info');
                },
                child: FaIcon(
                  FontAwesomeIcons.userEdit,
                  color: kOrange4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomHalf() {
    return Positioned(
      top: height / 1.8,
      width: width,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.green[50],
                  Colors.green[100],
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.all(8),
              width: width / 3.5,
              child: Column(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.creditCard,
                    color: Colors.green[400],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${loggedInUser.credits.toStringAsFixed(2)}',
                    style: kNumeralTextStyle.copyWith(
                      fontSize: 17,
                      color: kGrey4,
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue[50],
                  Colors.blue[100],
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.all(8),
              width: width / 3.5,
              child: Column(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.mobileAlt,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${loggedInUser.phoneNumber}',
                    style: kNumeralTextStyle.copyWith(
                      fontSize: 17,
                      color: kGrey4,
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orange[50],
                  Colors.orange[100],
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.all(8),
              width: width / 3.5,
              child: Column(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.calendarAlt,
                    color: kOrange4,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${loggedInUser.regDate}',
                    style: kNumeralTextStyle.copyWith(
                      fontSize: 17,
                      color: kGrey4,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          height: height / 3,
          width: width,
          child: Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Order History',
                  style: kDefaultTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: kGrey6,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      HistoryItem(),
                      HistoryItem(),
                      HistoryItem(),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
