import "package:flutter/material.dart";

import "../screens/edit_product_screen.dart";

class ManageProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  ManageProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              }, // TODO: Should pass product data to editable form screen
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {}, // TODO: Should delete data from memory
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
