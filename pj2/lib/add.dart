// add.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'artboard.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerComment = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('art_posts');
  String imageUrl = '';
  File? imageFile;
  double? imageWidth;
  double? imageHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Art Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  controller: _controllerName,
                  decoration: const InputDecoration(hintText: 'Enter the name'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controllerQuantity,
                  decoration:
                      const InputDecoration(hintText: 'Enter the quantity'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controllerComment,
                  decoration:
                      const InputDecoration(hintText: 'Enter a description'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? pickedImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);
                      try {
                        await referenceImageToUpload
                            .putFile(File(pickedImage.path));
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                        ui.Codec codec = await ui.instantiateImageCodec(
                            File(pickedImage.path).readAsBytesSync());
                        ui.FrameInfo frameInfo = await codec.getNextFrame();
                        setState(() {
                          imageFile = File(pickedImage.path);
                          imageWidth = frameInfo.image.width.toDouble();
                          imageHeight = frameInfo.image.height.toDouble();
                        });
                      } catch (error) {}
                    }
                  },
                  child: const Text('Pick Image'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          String title = _controllerName.text;
                          String quantity = _controllerQuantity.text;
                          String description = _controllerComment.text;
                          String? authorId =
                              FirebaseAuth.instance.currentUser?.uid;
                          User? user = FirebaseAuth.instance.currentUser;
                          String authorFirstName =
                              user?.displayName?.split(' ').firstOrNull ?? '';
                          String authorLastName =
                              user?.displayName?.split(' ').lastOrNull ?? '';
                          Map<String, dynamic> dataToSend = {
                            'title': title,
                            'quantity': quantity,
                            'description': description,
                            'image': imageUrl,
                            'authorId': authorId,
                            'createdAt': FieldValue.serverTimestamp(),
                            'authorFirstName': authorFirstName,
                            'authorLastName': authorLastName,
                          };
                          _reference.add(dataToSend).then((value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ArtbookDashboardScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
                if (imageFile != null)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: imageWidth! / imageHeight!,
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
}
