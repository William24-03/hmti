import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'create_edit_post_screen.dart';
import 'edit_profile_screen.dart'; // ✅ Tambahkan ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = ApiService.fetchPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _futurePosts = ApiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // 🏠 HOME PAGE
      RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Post>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                children: [
                  SizedBox(height: 200),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.hasError) {
              return ListView(
                children: [
                  SizedBox(height: 80),
                  Center(child: Text('Error: ${snapshot.error}')),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _refresh,
                      child: Text('Coba lagi'),
                    ),
                  ),
                ],
              );
            } else {
              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return ListView(
                  children: [
                    SizedBox(height: 80),
                    Center(child: Text('Belum ada post')),
                  ],
                );
              }
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final p = posts[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(post: p),
                          ),
                        );
                        _refresh();
                      },
                      child: Card(
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.image != null && p.image!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8.0),
                                ),
                                child: Image.network(
                                  p.image!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    '${p.author} • ${p.createdAt ?? ''}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    p.content.length > 120
                                        ? p.content.substring(0, 120) + '...'
                                        : p.content,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      // 📄 Explore (kosong dulu)
      Container(),
      // 🔖 Bookmark (kosong dulu)
      Container(),
      // 👤 Profile Page
      EditProfileScreen(), // ✅ Ganti Container dengan ini
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'HMTI',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' News',
              style: TextStyle(
                color: Color(0xFF1877F2),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          // ✅ Tombol tambah berita hanya muncul di tab Home
          if (_currentIndex == 0)
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateEditPostScreen()),
                );
                _refresh();
              },
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Pengaturan', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(color: Color(0xFF1877F2)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3); // 👤 Buka tab Profile
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Color(0xFF1877F2),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
