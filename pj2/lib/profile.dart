// profile.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pj2/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  String _firstName = '';
  String _lastName = '';

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      setState(() {
        _firstName = userData.get('firstName') ?? '';
        _lastName = userData.get('lastName') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const ArtbookLoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildUserInfo(),
                const Divider(),
                const Expanded(child: _UserPostsList()),
              ],
            ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/default_profile.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_firstName $_lastName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_currentUser?.email != null) Text(_currentUser!.email!),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _UserPostsList extends StatelessWidget {
  const _UserPostsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('art_posts')
          .where('authorId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No posts yet.'));
        }

        final List<QueryDocumentSnapshot> userPosts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: userPosts.length,
          itemBuilder: (context, index) {
            final post = userPosts[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(post['title']),
              subtitle: Text(post['description'] ?? ''),
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
