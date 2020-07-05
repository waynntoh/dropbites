import 'dart:convert';
import 'dart:io';
import 'package:drop_bites/views/admin_menu.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:random_string/random_string.dart';

class AdminAddDialog extends StatefulWidget {
  final Function resetItems;

  AdminAddDialog({@required this.resetItems});

  @override
  _AdminAddDialogState createState() => _AdminAddDialogState();
}

class _AdminAddDialogState extends State<AdminAddDialog> {
  List<String> typeOptions = ['Appetizer', 'Entrée', 'Beverage', 'Dessert'];
  String selectedTypeOption = 'Appetizer';
  String addItemUrl = 'http://hackanana.com/dropbites/php/add_item.php';
  String uploadImageUrl =
      'http://hackanana.com/dropbites/php/upload_item_image.php';
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File _itemImage;
  String id;
  String type = 'app';
  List<double> ratings = [3.0, 3.5, 4, 4.5, 5];

  @override
  void initState() {
    id = '${randomAlpha(1).toLowerCase()}-${randomNumeric(6)}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: AlertDialog(
        content: SizedBox(
          height: double.infinity,
          width: width / 1.1,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Item',
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
                SizedBox(height: 36),
                SizedBox(
                  width: width / 7,
                  height: 48,
                  child: _itemImage != null
                      ? SizedBox(
                          height: 90,
                          width: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(_itemImage),
                          ),
                        )
                      : InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.cameraRetro,
                                size: 36,
                                color: kOrange4,
                              ),
                            ),
                          ),
                          onTap: () => _getItemImage(),
                        ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: width / 1.7,
                  child: TextField(
                    autofocus: false,
                    controller: nameController,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Name',
                      hintStyle: kDefaultTextStyle.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: width / 1.7,
                  child: TextField(
                    autofocus: false,
                    controller: priceController,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Price (\$)',
                      hintStyle: kDefaultTextStyle.copyWith(fontSize: 16),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: width / 1.7,
                  height: 240,
                  child: TextField(
                    autofocus: false,
                    maxLines: 99,
                    controller: descriptionController,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Description',
                      hintStyle: kDefaultTextStyle.copyWith(fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kOrange3, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: width / 1.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Type :  ', style: kDefaultTextStyle),
                      DropdownButton<String>(
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
                            switch (selectedTypeOption) {
                              case 'Appetizer':
                                type = 'app';
                                break;
                              case 'Entrée':
                                type = 'ent';
                                break;
                              case 'Beverage':
                                type = 'bev';
                                break;
                              case 'Dessert':
                                type = 'des';
                                break;
                              default:
                            }
                          });
                        },
                        items: typeOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 6),
        actions: [
          FlatButton(
            color: kOrange3,
            child: Text(
              'Add',
              style: kDefaultTextStyle.copyWith(color: kGrey6, fontSize: 20),
            ),
            onPressed: () {
              if (nameController.text == '' ||
                  nameController.text == null ||
                  priceController.text == '' ||
                  priceController.text == null ||
                  descriptionController.text == '' ||
                  descriptionController.text == null) {
                Navigator.pop(context);
                CustomSnackbar.showSnackbar(
                    text: 'Incomplete Details',
                    scaffoldKey: AdminMenu.scaffoldKey,
                    iconData: Icons.error);
              } else if (_itemImage == null) {
                CustomSnackbar.showSnackbar(
                    text: 'No Image Selected',
                    scaffoldKey: AdminMenu.scaffoldKey,
                    iconData: Icons.error);
              } else {
                _addItem(id, nameController.text, priceController.text,
                    descriptionController.text, type);
              }
            },
          ),
        ],
      ),
    );
  }

  void _addItem(
      String id, String name, String price, String description, String type) {
    // Start loader
    setState(() {
      isLoading = true;
    });

    http.post(addItemUrl, body: {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "type": type,
      "rating": ratings[randomBetween(0, 5)].toString(),
    }).then((res) {
      if (res.body == "Added Successfully") {
        uploadImage(_itemImage, id);
      } else {
        CustomSnackbar.showSnackbar(
            text: 'Addition Failed',
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

  void uploadImage(File imageFile, String id) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "id": id,
    }).then((res) {
      if (res.body == "Upload Successful") {
        CustomSnackbar.showSnackbar(
            text: 'Item Added',
            scaffoldKey: AdminMenu.scaffoldKey,
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
    widget.resetItems();
  }
}
