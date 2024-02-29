import 'package:blog_app/utlis/session/session_manager.dart';
import 'package:blog_app/view/Post/add_post.dart';

import 'package:blog_app/view/profile/profile.dart';
import 'package:blog_app/view/singleItem/SingleItem.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('AllPost');
  DatabaseReference reef = FirebaseDatabase.instance.ref('Users_profile');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddPost()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileView()));
              },
              child: StreamBuilder(
                stream:
                    reef.child(SessionController().userId.toString()).onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as Map;
                    final profilePic = map['profilePic'];
                    Future.delayed(Duration.zero, () {
                      setState(() {
                        SessionController().img = map['profilePic'].toString();
                        SessionController().name = map['name'].toString();
                      });
                    });

                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: ClipOval(
                        child:  Image(
                                height: 33,
                                width: 33,
                                image: NetworkImage(profilePic),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.error_outline,
                                    color: Colors.black,
                                  );
                                },
                              )
                           
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: StreamBuilder(
                    stream: ref.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasData) {
                        Map<dynamic, dynamic> map =
                            snapshot.data!.snapshot.value as dynamic;
                        List<dynamic> list = [];
                        list.clear();
                        list = map.values.toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Daily',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Recommendation',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                              flex: 1,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 1.4,
                                  mainAxisSpacing: 15,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    snapshot.data!.snapshot.children.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final title = list[index]['title'];
                                  final image = list[index]['image'];
                                  final id = list[index]['id'];
                                  final detail = list[index]['detail'];
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black26,
                                    ),
                                    child: GridTile(
                                      footer: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image(
                                                    height: 20,
                                                    width: 20,
                                                    image: NetworkImage(
                                                      SessionController().img,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(
                                                        Icons.error_outline,
                                                        color: Colors.black,
                                                      );
                                                    },
                                                    // fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  SessionController()
                                                      .name
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      header: const Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 18, top: 8),
                                          child: Icon(
                                            Icons.bookmark_add_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Item(
                                                detail: detail,
                                                id: id,
                                                pic: image,
                                                title: title,
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image(
                                            image: NetworkImage(image),
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: LoadingAnimationWidget
                                                    .staggeredDotsWave(
                                                  color: Colors.blueGrey,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.error_outline,
                                                color: Colors.black,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: ListView.builder(
                                itemCount:
                                    snapshot.data!.snapshot.children.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final title = list[index]['title'];
                                  final image = list[index]['image'];
                                  final id = list[index]['id'];
                                  final detail = list[index]['detail'];
                                  return Card(
                                    shadowColor: Colors.blueGrey.shade100,
                                    elevation: 7,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(5),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Item(
                                              detail: detail,
                                              id: id,
                                              pic: image,
                                              title: title,
                                            ),
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        height: 150,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            image: NetworkImage(image),
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: LoadingAnimationWidget
                                                    .discreteCircle(
                                                  color: Colors.blueGrey,
                                                  size: 25,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.error_outline,
                                                color: Colors.black,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image(
                                                height: 20,
                                                width: 20,
                                                image: NetworkImage(
                                                  SessionController().img,
                                                ),
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.error_outline,
                                                    color: Colors.black,
                                                  );
                                                },
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              SessionController()
                                                  .name
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: PopupMenuButton(
                                        itemBuilder: (context) => [],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: LoadingAnimationWidget.twistingDots(
                            leftDotColor: Colors.black,
                            rightDotColor: Colors.redAccent,
                            size: 30,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
