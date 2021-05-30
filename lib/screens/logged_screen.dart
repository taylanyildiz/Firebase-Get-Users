import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_api/models/user_model.dart';
import 'package:firebase_sign_api/services/fire_base_data_service.dart';
import 'package:flutter/material.dart';

class LoggedScreen extends StatefulWidget {
  LoggedScreen({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;
  @override
  _LoggedScreenState createState() => _LoggedScreenState();
}

class _LoggedScreenState extends State<LoggedScreen> {
  Widget _listProfileUser(BuildContext context) {
    return StreamBuilder<List<UserModel?>?>(
      stream: FirebaseDataService().users,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              List<UserModel?> user = snapshot.data!;
              return user[index]!.profile != 'none'
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(user[index]!.profile),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 20.0,
                        child: Text(
                            user[index]!.email.split('@')[0][0].toUpperCase()),
                      ),
                    );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _messageBuild(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.title!),
        centerTitle: true,
        leadingWidth: double.infinity,
        leading: Padding(
          padding: user!.photoURL != null
              ? EdgeInsets.only(left: 10.0)
              : EdgeInsets.all(10),
          child: user.photoURL != null
              ? Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      '${user.displayName!.split(' ')[0]}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child:
                          Text('${user.email!.split('@')[0][0].toUpperCase()}'),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      '${user.email!.split('@')[0]}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profiles',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => print('more'),
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.only(top: 10.0),
                    child: _listProfileUser(context),
                  ),
                  Divider(thickness: 4.0, color: Colors.red),
                ],
              ),
            ),
          ),
          _messageBuild(context)
        ],
      ),
    );
  }
}
