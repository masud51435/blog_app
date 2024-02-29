import 'dart:io';
import 'package:blog_app/utlis/session/session_manager.dart';
import 'package:blog_app/utlis/toastMsg/toastMessage.dart';
import 'package:blog_app/view/login/loginView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class profileController extends ChangeNotifier {
  DatabaseReference reef = FirebaseDatabase.instance.ref('Users_profile');

  final ImagePicker picker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController updateController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  XFile? _image;
  XFile? get image => _image;

  Future CameraImage() async {
    final XFile? camera = await picker.pickImage(source: ImageSource.camera);
    if (camera != null) {
      _image = camera;
      uploadImage();
      notifyListeners();
    }
  }

  Future GalleryImage() async {
    final XFile? gallery = await picker.pickImage(source: ImageSource.gallery);

    if (gallery != null) {
      _image = XFile(gallery.path);
      uploadImage();
      notifyListeners();
    }
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
                    CameraImage();
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
                    GalleryImage();
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
    setLoading(true);
    final storageRef = FirebaseStorage.instance.ref('/ProfileImages');
    final ref = storageRef.child(SessionController().userId.toString());
    UploadTask uploadTask = ref.putFile(File(image!.path));
    await Future.value(uploadTask);

    var imageUrl = await ref.getDownloadURL();

    reef
        .child(SessionController().userId.toString())
        .update({'profilePic': imageUrl.toString()}).then((value) {
      // SessionController().img = imageUrl.toString();
      setLoading(false);
      _image == null;
      if (kDebugMode) {
        print('Profile Picture Updated');
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then(
      (value) {
        SessionController().userId = '';
        GoogleSignIn().signOut();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));

        if (context.mounted) {
          Utils.toastMessage('LogOut successfully', Colors.blue,
              const Icon(Icons.check), context);
        }
      },
    );
  }
}
