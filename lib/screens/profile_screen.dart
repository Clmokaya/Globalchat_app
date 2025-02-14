import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:globalchat/providers/userProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData = {};
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, child: Text(userProvider.userName[0])),
            SizedBox(
              height: 20,
            ),
            Text(
              userProvider.userName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(userProvider.userEmail),
            ElevatedButton(onPressed: () {}, child: Text('Edit Profile'))
          ],
        ),
      ),
    );
  }
}
