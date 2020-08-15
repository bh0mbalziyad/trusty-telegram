import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/product.dart";
import "../providers/products_provider.dart";

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  bool isInitBuild = true;
  final _form = GlobalKey<FormState>();
  var editedProduct = Product(
    id: null,
    description: '',
    price: 0,
    imageUrl: '',
    title: '',
  );

  @override
  initState() {
    _imageUrlFocusNode.addListener(_updateImagePreview);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInitBuild) return;
    final productId = ModalRoute.of(context).settings.arguments as String;
    if (productId == null) {
      isInitBuild = false;
      return;
    }
    editedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    _imageUrlController.text = editedProduct.imageUrl;

    isInitBuild = false;
    super.didChangeDependencies();
  }

  @override
  dispose() {
    _imageUrlFocusNode.removeListener(_updateImagePreview);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImagePreview() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  // called when form is to be submitted
  void _saveForm() {
    final isFormValid = _form.currentState.validate();
    if (!isFormValid) return;
    _form.currentState.save();

    Provider.of<ProductsProvider>(context, listen: false)
        .addProduct(editedProduct);
    Navigator.of(context).pop();
  }

  String _titleValidator(String fieldValue) {
    if (fieldValue.isEmpty)
      return "Title cannot be empty"; // returned when field has an error
    return null; // returned when field has
  }

  String _descriptionValidator(String fieldValue) {
    if (fieldValue.isEmpty) return "Description cannot be empty";
    if (fieldValue.length <= 10) return "Must be more than 10 characters";
    return null;
  }

  String _urlValidator(String fieldValue) {
    if (fieldValue.isEmpty) return "URL cannot be empty";
    if (!fieldValue.startsWith("http") || !fieldValue.startsWith("https"))
      return "Not a valid URL";
    return null;
  }

  String _priceValidator(String fieldValue) {
    String errorMessagePriceZero = "Price cannot be zero";
    String errorMessagePriceNaN = "Price must be a number";
    String errorMessagePriceEmpty = "Price cannot be empty";
    if (fieldValue.isEmpty) return errorMessagePriceEmpty;
    if (double.tryParse(fieldValue) == null) return errorMessagePriceNaN;
    if (double.tryParse(fieldValue) <= 0.0) return errorMessagePriceZero;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit products'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              color: Colors.white,
              onPressed: _saveForm,
              tooltip: 'Save',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  initialValue: editedProduct.title,
                  textInputAction: TextInputAction.next,
                  validator: _titleValidator,
                  onSaved: (value) => editedProduct.title = value,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  initialValue: editedProduct.price.toString(),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: _priceValidator,
                  focusNode: _priceFocusNode,
                  onSaved: (value) => editedProduct.price = double.parse(value),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_descFocusNode),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  initialValue: editedProduct.description,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: _descriptionValidator,
                  onSaved: (value) => editedProduct.description = value,
                  focusNode: _descFocusNode,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a url')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Image URL",
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        validator: _urlValidator,
                        focusNode: _imageUrlFocusNode,
                        onSaved: (value) => editedProduct.imageUrl = value,
                        onFieldSubmitted: (_) => _saveForm(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
