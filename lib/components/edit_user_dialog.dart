import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/account_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditUserDialog extends StatefulWidget {
  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  List<String> options = ['Name', 'Email', 'Phone Number'];
  String selectedOption = 'Name';
  TextEditingController textController = TextEditingController();
  String editUserUrl = 'http://hackanana.com/dropbites/php/edit_user.php';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: AlertDialog(
        content: SizedBox(
          height: height / 3.5,
          width: width / 1.5,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Account',
                    style: kDefaultTextStyle.copyWith(fontSize: 22),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 26,
                      color: Colors.redAccent,
                    ),
                  )
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edit : ',
                    style: kDefaultTextStyle,
                  ),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedOption,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: kDefaultTextStyle.copyWith(color: kGrey6),
                    underline: Container(
                      height: 1,
                      color: kOrange3,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedOption = newValue;
                      });
                    },
                    items:
                        options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: buildTextField(loggedInUser, selectedOption, width),
              )
            ],
          ),
        ),
        actionsPadding: EdgeInsets.only(bottom: 8, right: 14),
        actions: [
          FlatButton(
            color: kOrange3,
            child: Text(
              'Save Changes',
              style: kDefaultTextStyle.copyWith(color: kGrey6, fontSize: 20),
            ),
            onPressed: () {
              if (selectedOption == 'Name') {
                _editUser(loggedInUser, 'full_name', textController.text);
              } else if (selectedOption == 'Email') {
                _editUser(loggedInUser, 'email', textController.text);
              } else {
                _editUser(loggedInUser, 'phone_number', textController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField(User loggedInUser, String option, double width) {
    if (option == 'Name') {
      textController.text = loggedInUser.name;
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          controller: textController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: loggedInUser.name,
          ),
        ),
      );
    } else if (option == 'Email') {
      textController.text = loggedInUser.email;
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          controller: textController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: loggedInUser.email,
          ),
        ),
      );
    } else {
      textController.text = loggedInUser.phoneNumber;
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          autofocus: false,
          controller: textController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: loggedInUser.phoneNumber,
            hintStyle: kNumeralTextStyle.copyWith(fontSize: 20),
          ),
        ),
      );
    }
  }

  void _editUser(User loggedInUser, String col, String newData) {
    // Start loader
    setState(() {
      isLoading = true;
    });

    http.post(editUserUrl, body: {
      "email": loggedInUser.email,
      "col": col,
      "new_data": newData,
    }).then((res) {
      if (res.body == "Edited Successfully") {
        CustomSnackbar.showSnackbar(
            text: 'Changes saved',
            scaffoldKey: AccountView.scaffoldKey,
            iconData: Icons.check_circle);
      } else {
        CustomSnackbar.showSnackbar(
            text: 'Edit Failed',
            scaffoldKey: AccountView.scaffoldKey,
            iconData: Icons.error);
      }
      // Update user object
      if (col == 'full_name') {
        loggedInUser.setName(newData);
      } else if (col == 'email') {
        loggedInUser.setEmail(newData);
      } else {
        loggedInUser.setPhoneNumber(newData);
      }

      // End loader
      setState(() {
        isLoading = true;
      });

      Navigator.pop(context);
    }).catchError((err) {
      print(err);
    });
  }
}
