import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/imagesApi.dart';
import '../model/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Images> _cats = [];
  List<Images> _filteredCats = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _limit = 40;
  bool _isFetchingMore = false;
  String _selectedType = 'gifs'; // default to gifs

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    try {
      final cats = await CatService.fetchCats(_currentPage, _limit, _selectedType);
      setState(() {
        _cats.addAll(cats);
        _filteredCats.addAll(cats);
        _isLoading = false;
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
      _showErrorDialog('Failed to load cats. Please try again.');
    }
  }

  void _loadMoreCats() {
    if (!_isFetchingMore) {
      setState(() {
        _isFetchingMore = true;
        _currentPage++;
      });
      _loadCats();
    }
  }

  void _filterCats(String query) {
    final List<Images> filteredCats = _cats.where((cat) {
      final catName = cat.name?.toLowerCase() ?? '';
      final input = query.toLowerCase();
      return catName.contains(input);
    }).toList();

    setState(() {
      _filteredCats = filteredCats;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Browser'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterCats,
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedType,
                  items: [
                    DropdownMenuItem(
                      value: 'gifs',
                      child: Text('GIFs'),
                    ),
                    DropdownMenuItem(
                      value: 'images',
                      child: Text('Images'),
                    ),
                    DropdownMenuItem(
                      value: 'both',
                      child: Text('Both'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                      _currentPage = 1;
                      _cats.clear();
                      _filteredCats.clear();
                      _isLoading = true;
                      _loadCats();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                    !_isFetchingMore) {
                  _loadMoreCats();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: _filteredCats.length + 1,
                itemBuilder: (context, index) {
                  if (index == _filteredCats.length) {
                    return _isFetchingMore
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }
                  final cat = _filteredCats[index];
                  return ListTile(
                    leading: Image.network(
                      cat.url ?? '',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cat.name ?? 'Unknown'),
                    subtitle: Text('ID: ${cat.id}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
