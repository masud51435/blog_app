import 'dart:io';
import 'package:blog_app/utlis/session/session_manager.dart';
import 'package:blog_app/utlis/simple_button/roundButton.dart';

import 'package:blog_app/view/profile/profile_provider.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('Users_profile');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: ref.child(SessionController().userId.toString()).onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map;
            final name = map['name'];
            final number = map['number'];
            final picture = map['profilePic'];
            final email = map['email'];

            return Consumer<profileController>(
              builder: (context, profileChanger, child) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 30,
                          bottom: 40,
                        ),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/bb.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade200,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Stack(
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipOval(
                                        child: profileChanger.image == null
                                            ? Image(
                                                image: NetworkImage(picture),
                                                fit: BoxFit.cover,
                                                height: 150,
                                                width: 150,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.black,
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                  );
                                                },
                                              )
                                            : Image.file(
                                                File(
                                                    profileChanger.image!.path),
                                                fit: BoxFit.cover,
                                                height: 150,
                                                width: 150,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -18,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: IconButton(
                                        onPressed: () {
                                          profileChanger.showMyDialog(context);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                name,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 90,
                        child: ShowValue(
                          title: "Name",
                          value: name,
                          icon: Icons.person,
                          update: () {
                            // profileChanger.updateValue(
                            //     name, context, 'userName');
                            // Navigator.pop(context);
                          },
                          delete: () {},
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: ShowValue(
                          title: "Number",
                          value: number == '' ? '+880xxxxxxxxxxx' : number,
                          icon: Icons.phone,
                          update: () {
                            // profileChanger.updateValue(
                            //     number, context, 'phoneNumber');
                            // Navigator.pop(context);
                          },
                          delete: () {},
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: ShowValue(
                          title: "Email",
                          value: email,
                          icon: Icons.email,
                          update: () {
                            // profileChanger.updateValue(email, context, 'email');
                            // Navigator.pop(context);
                          },
                          delete: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonButton(
                          color: Colors.blueGrey,
                          onPress: () {
                            profileChanger.logOut(context);
                          },
                          title: 'LogOut',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ShowValue extends StatelessWidget {
  const ShowValue(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.update,
      required this.delete});

  final String title, value;
  final IconData icon;
  final VoidCallback update;
  final VoidCallback delete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          icon,
                          color: const Color.fromARGB(255, 94, 94, 94),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 107, 107, 107)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 35,
                        ),
                        Text(value),
                      ],
                    ),
                  ],
                ),
                PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        onTap: update,
                        leading: const Icon(Icons.update),
                        title: const Text('Update'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: ListTile(
                        onTap: delete,
                        leading: const Icon(Icons.delete_outline),
                        title: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
