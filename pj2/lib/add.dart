import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('shopping_list');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration: const InputDecoration(
                    hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerQuantity,
                decoration: const InputDecoration(
                    hintText: 'Enter the quantity of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item quantity';
                  }

                  return null;
                },
              ),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;
                    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    Reference referenceImageToUpload =
                        referenceDirImages.child('name');

                    try {
                      await referenceImageToUpload.putFile(File(file!.path));
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                    }
                  },
                  icon: const Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload an image')));
                      return;
                    }

                    if (key.currentState!.validate()) {
                      String itemName = _controllerName.text;
                      String itemQuantity = _controllerQuantity.text;

                      Map<String, String> dataToSend = {
                        'name': itemName,
                        'quantity': itemQuantity,
                        'image': imageUrl,
                      };

                      _reference.add(dataToSend);
                    }
                  },
                  child: const Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
