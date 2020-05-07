import 'dart:convert';
import 'dart:ui';
import 'package:drop_bites/components/custom_drawer.dart';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:drop_bites/components/edit_user_dialog.dart';
import 'package:drop_bites/components/stat_block.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/utils/constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_advanced_networkimage/provider.dart';

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
  String uploadImageUrl =
      'http://hackanana.com/dropbites/php/upload_user_image.php';
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User>(context, listen: false);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: AccountView.scaffoldKey,
        drawer: CustomDrawer(),
        backgroundColor: Color(0xFFF4F4F4),
        body: Stack(
          children: <Widget>[
            _buildTopHalf(),
            _buildBottomHalf(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHalf() {
    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height / 1.65,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AdvancedNetworkImage(
                'http://hackanana.com/dropbites/user_images/${loggedInUser.email}.jpg',
              ),
            ),
          ),
        ),
        Container(
          width: width,
          height: height / 1.65,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFF4F4F4).withOpacity(0.1),
              Color(0xFFF4F4F4).withOpacity(0.3),
              Color(0xFFF4F4F4).withOpacity(0.75),
              Color(0xFFF4F4F4).withOpacity(1),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            border: Border.all(
              color: Colors.white.withOpacity(0),
            ),
          ),
        ),
        Positioned(
          top: height / 1.95,
          right: 16,
          child: GestureDetector(
            onTap: () => _getUserImage(),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: kGrey1,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: FaIcon(
                  FontAwesomeIcons.cameraRetro,
                  color: kOrange4,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 1.95,
          right: 72,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditUserDialog(),
              );
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: kGrey1,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: FaIcon(
                  FontAwesomeIcons.solidEdit,
                  color: kOrange4,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 2.2,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    loggedInUser.name,
                    style: kDefaultTextStyle.copyWith(
                      fontSize: 32,
                      color: kGrey6,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 12),
                  (loggedInUser.verified)
                      ? FaIcon(
                          FontAwesomeIcons.checkCircle,
                          size: 18,
                          color: Colors.green,
                        )
                      : FaIcon(
                          FontAwesomeIcons.timesCircle,
                          size: 18,
                          color: Colors.red[500],
                        )
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.at,
                    size: 16,
                    color: kGrey4,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${loggedInUser.email}',
                    style:
                        kDefaultTextStyle.copyWith(fontSize: 18, color: kGrey4),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.phone,
                    size: 16,
                    color: kGrey4,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${loggedInUser.phoneNumber}',
                    style: kNumeralTextStyle.copyWith(
                        fontSize: 18, color: kGrey4, letterSpacing: .5),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          width: width,
          height: height / 2.55,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.all(Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                    blurRadius: .3,
                    offset: Offset(5, 5),
                    color: Color(0xFFEAEAEA)),
                BoxShadow(
                  blurRadius: .3,
                  offset: Offset(-5, -5),
                  color: Colors.white,
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatBlock(
                      title: 'Orders',
                      iconData: FontAwesomeIcons.star,
                      data: '10',
                      color: kOrange3,
                    ),
                    Container(
                      height: 50,
                      width: .4,
                      color: kOrange4,
                    ),
                    StatBlock(
                      title: 'Items',
                      iconData: FontAwesomeIcons.shoppingBasket,
                      data: '29',
                      color: Colors.blueAccent,
                    ),
                    Container(
                      height: 50,
                      width: .4,
                      color: kOrange4,
                    ),
                    StatBlock(
                      title: 'Credits Spent',
                      iconData: FontAwesomeIcons.creditCard,
                      data: '\$156.80',
                      color: Colors.green[400],
                    ),
                  ],
                ),
                SizedBox(height: 36),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Since  ',
                        style: kDefaultTextStyle.copyWith(color: kGrey4),
                      ),
                      TextSpan(
                        text: '${loggedInUser.regDate}',
                        style: kDefaultTextStyle.copyWith(
                          color: kGrey5,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

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
                      uploadImage(image);
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

  void uploadImage(File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "email": loggedInUser.email,
    }).then((res) {
      if (res.body == "Upload Successful") {
        CustomSnackbar.showSnackbar(
            scaffoldKey: AccountView.scaffoldKey,
            text: 'Upload Successful',
            iconData: Icons.check_circle);
      } else {
        CustomSnackbar.showSnackbar(
            scaffoldKey: AccountView.scaffoldKey,
            text: 'Upload Failed',
            iconData: Icons.error);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
