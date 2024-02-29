import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utlis/input_field/textField.dart';
import '../../utlis/simple_button/roundButton.dart';
import '../../utlis/toastMsg/toastMessage.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late String imageUrl;
  XFile? _image;
  DatabaseReference ref = FirebaseDatabase.instance.ref('AllPost');

  bool loading = false;

  Future cameraImage() async {
    final XFile? camera = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (camera != null) {
        _image = camera;
        uploadImage();
      }
    });
  }

  Future galleryImage() async {
    final XFile? gallery = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (gallery != null) {
        _image = gallery;
        uploadImage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    detailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  showMyDialog(context);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.black87,
                            size: 30,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      keyBoardType: TextInputType.multiline,
                      maxline: null,
                      controller: titleController,
                      onValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid Name';
                        }
                        return null;
                      },
                      hintText: 'Title',
                      prefixIcon: const Icon(Icons.title_outlined),
                    ),
                    InputField(
                      keyBoardType: TextInputType.multiline,
                      maxline: null,
                      controller: detailController,
                      onValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid Name';
                        }
                        return null;
                      },
                      hintText: 'Description',
                      prefixIcon: const Icon(Icons.description_outlined),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonButton(
                      loading: loading,
                      color: Colors.blueGrey,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          uploadData();
                        }
                      },
                      title: 'Add Post',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    cameraImage();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                ),
                const Divider(
                  thickness: 2,
                ),
                ListTile(
                  onTap: () {
                    galleryImage();
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.image),
                  title: const Text('Gallery'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadImage() async {
    final storageRef = FirebaseStorage.instance.ref("/postImage");
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    final reference = storageRef.child(time);
    UploadTask uploadTask = reference.putFile(File(_image!.path));
    await Future.value(uploadTask);
    imageUrl = await reference.getDownloadURL();
  }

  Future<void> uploadData() async {
    setState(() {
      loading = true;
    });
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await ref.child(id).set({
      'id': id,
      'image': imageUrl.toString(),
      'title': titleController.text.toString(),
      'detail': detailController.text.toString(),
    }).then((value) {
      setState(() {
        loading = false;
      });
      titleController.clear();
      detailController.clear();
      Utils.toastMessage('post upload successfully', Colors.blue,
          const Icon(Icons.check), context);
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils.toastMessage(
          error.toString(), Colors.red, const Icon(Icons.error), context);
    });
  }
}
