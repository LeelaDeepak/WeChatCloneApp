import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/Screens/api/apis.dart';
import 'package:we_chat/Screens/helpers/dialogs.dart';
import 'package:we_chat/Screens/profile_screen.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log(message.toString());
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStats(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStats(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            onWillPop: () async {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  leading: const Icon(CupertinoIcons.home),
                  title: _isSearching
                      ? TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name Or Email'),
                          autofocus: true,
                          style:
                              const TextStyle(fontSize: 17, letterSpacing: 0.5),
                          //when search text changes then updated search list
                          onChanged: (val) {
                            //search logic
                            _searchList.clear();

                            for (var i in _list) {
                              if (i.name
                                      .toLowerCase()
                                      .contains(val.toLowerCase()) ||
                                  i.email
                                      .toLowerCase()
                                      .contains(val.toLowerCase())) {
                                _searchList.add(i);
                                setState(() {
                                  _searchList;
                                });
                              }
                            }
                          },
                        )
                      : Text('We Chat'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        },
                        icon: Icon(_isSearching
                            ? CupertinoIcons.clear_circled_solid
                            : Icons.search)),
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProfileScreen(
                                        user: APIs.me,
                                      )));
                        },
                        icon: const Icon(Icons.more_vert))
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FloatingActionButton(
                    onPressed: () async {
                      _addChatUserDialog();
                    },
                    child: const Icon(Icons.add_comment_rounded),
                  ),
                ),
                body: StreamBuilder(
                    stream: APIs.getMyUsersId(),

                    //get id of only known users
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                              child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          return StreamBuilder(
                            stream: APIs.getAllUsers(
                                snapshot.data?.docs.map((e) => e.id).toList() ??
                                    []),

                            //get only those user, who's ids are provided
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                //if data is loading
                                case ConnectionState.waiting:
                                case ConnectionState.none:
                                // return const Center(
                                //     child: CircularProgressIndicator());

                                //if some or all data is loaded then show it
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  final data = snapshot.data?.docs;
                                  _list = data
                                          ?.map((e) =>
                                              ChatUser.fromJson(e.data()))
                                          .toList() ??
                                      [];

                                  if (_list.isNotEmpty) {
                                    return ListView.builder(
                                        itemCount: _isSearching
                                            ? _searchList.length
                                            : _list.length,
                                        padding: EdgeInsets.only(
                                            top: mq.height * .01),
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return ChatUserCard(
                                              user: _isSearching
                                                  ? _searchList[index]
                                                  : _list[index]);
                                        });
                                  } else {
                                    return const Center(
                                      child: Text('No Connections Found!',
                                          style: TextStyle(fontSize: 20)),
                                    );
                                  }
                              }
                            },
                          );
                      }
                    }))));
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await APIs.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
