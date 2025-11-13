import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/news.dart';
import '../services/api_service.dart';
import 'create_edit_book_screen.dart';
import 'create_edit_news_screen.dart';
import 'detail_book_screen.dart';
import 'detail_news_screen.dart';
import 'edit_profile_screen.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> _booksFuture;
  late Future<List<News>> _newsFuture;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() {
    _booksFuture = ApiService.fetchBooks();
    _newsFuture = ApiService.fetchNews();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // Books tab
      RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return ListView(children: const [
                SizedBox(height: 200),
                Center(child: CircularProgressIndicator())
              ]);
            if (snap.hasError)
              return ListView(children: [
                const SizedBox(height: 80),
                Center(child: Text('Gagal memuat books')),
                Center(
                    child: ElevatedButton(
                        onPressed: _refresh, child: const Text('Retry')))
              ]);
            final books = snap.data ?? [];
            if (books.isEmpty)
              return ListView(children: const [
                SizedBox(height: 80),
                Center(child: Text('Belum ada buku'))
              ]);
            return ListView.builder(
                itemCount: books.length,
                itemBuilder: (c, idx) {
                  final b = books[idx];
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: BookCard(
                          book: b,
                          onTap: () async {
                            final r = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailBookScreen(book: b)));
                            if (r == true) _refresh();
                          }));
                });
          },
        ),
      ),

      // News tab
      RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<News>>(
          future: _newsFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return ListView(children: const [
                SizedBox(height: 200),
                Center(child: CircularProgressIndicator())
              ]);
            if (snap.hasError)
              return ListView(children: [
                const SizedBox(height: 80),
                Center(child: Text('Gagal memuat news')),
                Center(
                    child: ElevatedButton(
                        onPressed: _refresh, child: const Text('Retry')))
              ]);
            final list = snap.data ?? [];
            if (list.isEmpty)
              return ListView(children: const [
                SizedBox(height: 80),
                Center(child: Text('Belum ada news'))
              ]);
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (c, i) {
                  final n = list[i];
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(n.title),
                        subtitle: Text('${n.author} • ${n.createdAt ?? ''}'),
                        onTap: () async {
                          final r = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailNewsScreen(news: n)));
                          if (r == true) _refresh();
                        },
                      ));
                });
          },
        ),
      ),

      // Explore placeholder
      const Center(child: Text('Explore (kosong)')),

      // Profile
      const EditProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(children: const [
          Text('HMTI',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(' News',
              style: TextStyle(
                  color: Color(0xFF1877F2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold))
        ]),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (_tabIndex == 0)
            IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () async {
                  final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateEditBookScreen()));
                  if (res == true) _refresh();
                }),
          if (_tabIndex == 1)
            IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: () async {
                  final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateEditNewsScreen()));
                  if (res == true) _refresh();
                }),
        ],
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
            child: Text('Pengaturan', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(color: Color(0xFF1877F2))),
        ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _tabIndex = 3);
            }),
        ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
            }),
        ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await ApiService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            })
      ])),
      body: IndexedStack(index: _tabIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
          selectedItemColor: const Color(0xFF1877F2),
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Books'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
