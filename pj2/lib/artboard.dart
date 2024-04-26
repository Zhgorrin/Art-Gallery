import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add.dart';
import 'profile.dart';

class ArtbookDashboardScreen extends StatefulWidget {
  const ArtbookDashboardScreen({Key? key}) : super(key: key);

  @override
  _ArtbookDashboardScreenState createState() => _ArtbookDashboardScreenState();
}

class _ArtbookDashboardScreenState extends State<ArtbookDashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Gallery'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Art Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Profile'));
      case 1:
        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('art_posts').snapshots(),
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
      case 2:
        return const Center(child: Text('Add'));
      default:
        return const Center(child: Text('Error'));
    }
  }
}
