import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/Screens/api/apis.dart';
import 'package:we_chat/Screens/helpers/dialogs.dart';
import 'package:we_chat/Screens/home_screen.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';

import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser? user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: const Text('Profile Screen'),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                Dialogs.showProgressbar(context);
                await APIs.updateActiveStats(false);

                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    Navigator.pop(context);
                    APIs.auth = FirebaseAuth.instance;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  });
                });
              },
              icon: const Icon(Icons.logout_outlined),
              label: Text("Logout"),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .04,
                    ),
                    Stack(
                      children: [
                        (_image != null)
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * 0.2,
                                  height: mq.height * 0.2,
                                  fit: BoxFit.cover,
                                ))
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * 0.2,
                                  height: mq.height * 0.2,
                                  imageUrl: widget.user!.image,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: MaterialButton(
                              onPressed: () {
                                _showBottomSheet();
                              },
                              color: Colors.white,
                              elevation: 1,
                              shape: CircleBorder(),
                              child: Icon(Icons.edit),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .06,
                    ),
                    Text(
                      widget.user!.email,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(
                      height: mq.height * .06,
                    ),
                    TextFormField(
                      initialValue: widget.user!.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required To Be Filled",
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg: Tony Stark',
                          label: const Text('Name')),
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    TextFormField(
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required To Be Filled",
                      initialValue: widget.user!.about,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'About You',
                          label: const Text('About')),
                    ),
                    SizedBox(
                      height: mq.height * .06,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            minimumSize: Size(mq.width * 0.7, mq.height * 0.1)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            log('inside validator');
                            APIs.updateUserInfo();
                            Dialogs.showSnackbar(
                                context, 'Profile Updated Successfuly!!');
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                        label: const Text(
                          "Update",
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(bottom: mq.height * 0.05, top: mq.height * .03),
            children: [
              Text(
                "Choose Your Profile Photo",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image-path:${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/fromphone.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image-path:${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
