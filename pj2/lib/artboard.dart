// artboard.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pj2/add.dart';
import 'package:pj2/profile.dart';

class ArtbookDashboardScreen extends StatefulWidget {
  const ArtbookDashboardScreen({Key? key});

  @override
  _ArtbookDashboardScreenState createState() => _ArtbookDashboardScreenState();
}

class _ArtbookDashboardScreenState extends State<ArtbookDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Art Gallery'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('art_posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<QueryDocumentSnapshot> posts = snapshot.data!.docs;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post['title']),
              subtitle: Text(post['description']),
              trailing: post['image'] != null
                  ? Image.network(
                      post['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
