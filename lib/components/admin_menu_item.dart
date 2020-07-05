import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_bites/components/admin_edit_dialog.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/item.dart';
import 'package:flutter/material.dart';

class AdminMenuItem extends StatefulWidget {
  final Item item;
  final Color color;
  final Function resetItems;

  AdminMenuItem(
      {@required this.item, @required this.color, @required this.resetItems});

  @override
  _AdminMenuItemState createState() => _AdminMenuItemState();
}

class _AdminMenuItemState extends State<AdminMenuItem> {
  String type;

  @override
  void initState() {
    setState(() {
      switch (widget.item.type) {
        case 'app':
          type = 'Appetizer';
          break;
        case 'ent':
          type = 'Entrée';
          break;
        case 'bev':
          type = 'Beverage';
          break;
        case 'des':
          type = 'Dessert';
          break;
        default:
          type = '${widget.item.type}';
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white, widget.color],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [kButtonShadow],
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl:
                    'http://hackanana.com/dropbites/product_images/${widget.item.id}.jpg',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => kLargeImageLoader,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.item.name}',
                  style: kDefaultTextStyle.copyWith(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '${widget.item.id}',
                  style: kNumeralTextStyle.copyWith(
                    fontSize: 18,
                    color: kGrey3,
                  ),
                ),
                Spacer(),
                Text(
                  '\$${widget.item.price.toStringAsFixed(2)}',
                  style: kNumeralTextStyle.copyWith(
                    fontSize: 20,
                    color: kOrange5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            child: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 26,
                  color: kGrey3,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AdminEditDialog(
                      item: widget.item,
                      resetItems: widget.resetItems,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
