import 'dart:core';
import 'dart:core';

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
  int _currentPage = 0;
  final int _limit = 40;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    try {
      final cats = await CatService.fetchCats(_currentPage, _limit);
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
      final catName = cat.id?.toLowerCase() ?? '';
      final input = query.toLowerCase();
      return catName.contains(input);
    }).toList();

    setState(() {
      _filteredCats = filteredCats;
    });
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
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCats,
            ),
          ),

          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent && !_isFetchingMore) {
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
                      height: 350,
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