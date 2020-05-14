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
  List<String> options = ['Name', 'Email', 'Password', 'Phone Number'];
  String selectedOption = 'Name';
  TextEditingController newDataController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  String editUserUrl = 'http://hackanana.com/dropbites/php/edit_user.php';
  bool isLoading = false;
  bool obscureOld = true;
  bool obscureNew = true;

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: AlertDialog(
        content: SizedBox(
          height: height / 3,
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
                child: Column(
                  children: <Widget>[
                    buildTextField(loggedInUser, selectedOption, width),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            color: kOrange3,
            child: Text(
              'Save Changes',
              style: kDefaultTextStyle.copyWith(color: kGrey6, fontSize: 20),
            ),
            onPressed: () {
              if (selectedOption == 'Name') {
                _editUser(
                    loggedInUser, 'full_name', newDataController.text, '');
              } else if (selectedOption == 'Email') {
                _editUser(loggedInUser, 'email', newDataController.text, '');
              } else if (selectedOption == 'Phone Number') {
                _editUser(
                    loggedInUser, 'phone_number', newDataController.text, '');
              } else {
                _editUser(loggedInUser, 'password', newDataController.text,
                    oldPasswordController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField(User loggedInUser, String option, double width) {
    if (option == 'Name') {
      newDataController.text = '';
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          controller: newDataController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: loggedInUser.name,
          ),
        ),
      );
    } else if (option == 'Email') {
      newDataController.text = '';
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          controller: newDataController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: loggedInUser.email,
          ),
        ),
      );
    } else if (option == 'Phone Number') {
      newDataController.text = '';
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          autofocus: false,
          controller: newDataController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: loggedInUser.phoneNumber,
            hintStyle: kNumeralTextStyle.copyWith(fontSize: 20),
          ),
        ),
      );
    } else {
      oldPasswordController.text = '';
      newDataController.text = '';
      return Column(
        children: <Widget>[
          SizedBox(
            width: width / 1.7,
            child: TextField(
              autofocus: false,
              obscureText: obscureOld,
              controller: oldPasswordController,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Old Password',
                hintStyle: kDefaultTextStyle.copyWith(fontSize: 16),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureOld = !obscureOld;
                    });
                  },
                  child: Icon(
                    obscureOld ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: width / 1.7,
            child: TextField(
              obscureText: obscureNew,
              autofocus: false,
              controller: newDataController,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'New Password',
                hintStyle: kDefaultTextStyle.copyWith(fontSize: 16),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureNew = !obscureNew;
                    });
                  },
                  child: Icon(
                    obscureNew ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  void _editUser(
      User loggedInUser, String col, String newData, String oldPassword) {
    // Start loader
    setState(() {
      isLoading = true;
    });

    if (oldPassword == '') {
      // OTHER DETAILS
      http.post(editUserUrl, body: {
        "email": loggedInUser.email,
        "col": col,
        "new_data": newData,
      }).then((res) {
        print(res.body);
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
        } else if (col == 'phone_number') {
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
    } else {
      // PASSWORD
      http.post(editUserUrl, body: {
        "email": loggedInUser.email,
        "col": col,
        "old_password": oldPassword,
        "new_data": newData,
      }).then((res) {
        if (res.body == "Edited Successfully") {
          CustomSnackbar.showSnackbar(
              text: 'Changes saved',
              scaffoldKey: AccountView.scaffoldKey,
              iconData: Icons.check_circle);
        } else if (res.body == '-Edit Failed') {
          CustomSnackbar.showSnackbar(
              text: 'Incorrect Old Password',
              scaffoldKey: AccountView.scaffoldKey,
              iconData: Icons.error);
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
        } else if (col == 'phone_number') {
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
}
