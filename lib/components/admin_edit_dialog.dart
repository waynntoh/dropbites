import 'dart:convert';
import 'dart:io';
import 'package:drop_bites/utils/item.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/admin_menu.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminEditDialog extends StatefulWidget {
  final Item item;
  final Function resetItems;

  AdminEditDialog({@required this.item, @required this.resetItems});

  @override
  _AdminEditDialogState createState() => _AdminEditDialogState();
}

class _AdminEditDialogState extends State<AdminEditDialog> {
  List<String> options = ['Name', 'Price (\$)', 'Type', 'Description', 'Image'];
  List<String> typeOptions = ['Appetizer', 'Entrée', 'Beverage', 'Dessert'];
  String selectedOption = 'Name';
  String selectedTypeOption = 'Appetizer';
  TextEditingController newDataController = TextEditingController();
  String editUserUrl = 'http://hackanana.com/dropbites/php/edit_item.php';
  String uploadImageUrl =
      'http://hackanana.com/dropbites/php/upload_item_image.php';
  String deleteItemUrl = 'http://hackanana.com/dropbites/php/delete_item.php';
  bool isLoading = false;
  String briefDescription = '';
  File _itemImage;
  bool deleteConfirmation = false;

  @override
  void initState() {
    setState(() {
      switch (widget.item.type) {
        case 'app':
          selectedTypeOption = 'Appetizer';
          break;
        case 'ent':
          selectedTypeOption = 'Entrée';
          break;
        case 'bev':
          selectedTypeOption = 'Beverage';
          break;
        case 'des':
          selectedTypeOption = 'Dessert';
          break;
        default:
          selectedTypeOption = 'Error';
      }

      List splitString = widget.item.description.split(' ');
      try {
        for (int i = 0; i < 15; i++) {
          briefDescription += '${splitString[i]} ';
        }
      } catch (e) {
        briefDescription = widget.item.description;
      }
      briefDescription += '...';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: AlertDialog(
        content: SizedBox(
          height: height / 2.3,
          width: width / 1.1,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Item',
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
                        newDataController.text = '';
                        _itemImage = null;
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
        actionsPadding: EdgeInsets.only(right: 6),
        actions: [
          FlatButton(
            onPressed: () {
              if (!deleteConfirmation) {
                setState(() {
                  deleteConfirmation = true;
                });
              } else {
                http.post(deleteItemUrl, body: {
                  'id': widget.item.id,
                }).then((res) {
                  widget.resetItems();
                  CustomSnackbar.showSnackbar(
                    text: 'Deleted [${widget.item.id}]',
                    scaffoldKey: AdminMenu.scaffoldKey,
                    iconData: Icons.check_circle,
                  );
                  Navigator.pop(context);
                }).catchError((e) {
                  print(e);
                });
              }
            },
            child: Text(
              deleteConfirmation ? 'Confirm Deletion' : 'Delete Item',
              style: kDefaultTextStyle.copyWith(color: kGrey6, fontSize: 20),
            ),
            color: Colors.redAccent[200],
          ),
          FlatButton(
            color: kOrange3,
            child: Text(
              _itemImage != null ? 'Upload Image' : 'Save Changes',
              style: kDefaultTextStyle.copyWith(color: kGrey6, fontSize: 20),
            ),
            onPressed: () {
              if (selectedOption == 'Name') {
                if (newDataController.text == '' || newDataController == null) {
                  Navigator.pop(context);
                  CustomSnackbar.showSnackbar(
                    text: 'Invalid Name',
                    scaffoldKey: AdminMenu.scaffoldKey,
                    iconData: Icons.error,
                  );
                } else {
                  _editItem('name', newDataController.text);
                }
              } else if (selectedOption == 'Price (\$)') {
                if (newDataController.text == '' || newDataController == null) {
                  Navigator.pop(context);
                  CustomSnackbar.showSnackbar(
                    text: 'Invalid Price',
                    scaffoldKey: AdminMenu.scaffoldKey,
                    iconData: Icons.error,
                  );
                } else {
                  _editItem('price', newDataController.text);
                }
              } else if (selectedOption == 'Type') {
                _editItem('type', newDataController.text);
              } else if (selectedOption == 'Description') {
                if (newDataController.text == '' || newDataController == null) {
                  Navigator.pop(context);
                  CustomSnackbar.showSnackbar(
                    text: 'Invalid Description',
                    scaffoldKey: AdminMenu.scaffoldKey,
                    iconData: Icons.error,
                  );
                } else {
                  _editItem('description', newDataController.text);
                }
              } else if (selectedOption == 'Image') {
                if (_itemImage != null) {
                  uploadImage(_itemImage);
                } else {
                  Navigator.pop(context);
                  CustomSnackbar.showSnackbar(
                    text: 'No Image Selected',
                    scaffoldKey: AdminMenu.scaffoldKey,
                    iconData: Icons.error,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField(User loggedInUser, String option, double width) {
    if (option == 'Name') {
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          maxLength: 20,
          controller: newDataController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: widget.item.name,
          ),
        ),
      );
    } else if (option == 'Price (\$)') {
      return SizedBox(
        width: width / 1.7,
        child: TextField(
          controller: newDataController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: widget.item.price.toStringAsFixed(2),
          ),
          keyboardType: TextInputType.number,
        ),
      );
    } else if (option == 'Type') {
      return DropdownButton<String>(
        value: selectedTypeOption,
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
            selectedTypeOption = newValue;
          });
        },
        items: typeOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    } else if (option == 'Description') {
      return SizedBox(
        width: width / 1.7,
        height: 185,
        child: TextField(
          maxLines: 99,
          maxLength: 240,
          controller: newDataController,
          decoration: kTextFieldDecoration.copyWith(
            hintText: briefDescription,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kOrange3, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
        ),
      );
    } else if (option == 'Image') {
      return Center(
        child: _itemImage != null
            ? SizedBox(
                height: 180,
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_itemImage),
                ),
              )
            : InkWell(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: kGrey1,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white,
                    child: FaIcon(
                      FontAwesomeIcons.cameraRetro,
                      size: 48,
                      color: kOrange4,
                    ),
                  ),
                ),
                onTap: () {
                  _getItemImage();
                },
              ),
      );
    } else {
      return Container();
    }
  }

  void _editItem(String col, String newData) {
    // Start loader
    setState(() {
      isLoading = true;
    });

    http.post(editUserUrl, body: {
      "id": widget.item.id,
      "col": col,
      "new_data": newData,
    }).then((res) {
      if (res.body == "Edited Successfully") {
        CustomSnackbar.showSnackbar(
            text: 'Changes Saved',
            scaffoldKey: AdminMenu.scaffoldKey,
            iconData: Icons.check_circle);
      } else {
        CustomSnackbar.showSnackbar(
            text: 'Edit Failed',
            scaffoldKey: AdminMenu.scaffoldKey,
            iconData: Icons.error);
      }

      // End loader
      setState(() {
        isLoading = false;
      });
      widget.resetItems();
      Navigator.pop(context);
    }).catchError((err) {
      print(err);
    });
  }

  Future _getItemImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _itemImage = image;
    });
  }

  void uploadImage(File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "id": widget.item.id,
    }).then((res) {
      if (res.body == "Upload Successful") {
        CustomSnackbar.showSnackbar(
            scaffoldKey: AdminMenu.scaffoldKey,
            text: 'Upload Successful',
            iconData: Icons.check_circle);
      } else {
        CustomSnackbar.showSnackbar(
            scaffoldKey: AdminMenu.scaffoldKey,
            text: 'Upload Failed',
            iconData: Icons.error);
      }
    }).catchError((err) {
      print(err);
    });
    await DefaultCacheManager().removeFile(
        'http://hackanana.com/dropbites/product_images/${widget.item.id}.jpg');
    widget.resetItems();
    Navigator.pop(context);
  }
}
