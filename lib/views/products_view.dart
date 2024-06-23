import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final FirestoreService _db = FirestoreService();
  List<Product> _products = [];
  bool _loading = false;
  bool _hasMore = true;
  int _perPage = 10;
  var _lastDocument;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    setState(() {
      _loading = true;
    });

    var products = await _db.getProducts(_perPage);

    setState(() {
      _products.addAll(products);
      _loading = false;
      _lastDocument = products.isNotEmpty ? products.last.id : null;
      _hasMore = products.length == _perPage;
    });
  }

  Future<void> _loadMoreProducts() async {
    if (!_loading && _hasMore) {
      setState(() {
        _loading = true;
      });

      var products = await _db.getProducts(_perPage);

      setState(() {
        _products.addAll(products);
        _loading = false;
        _lastDocument = products.isNotEmpty ? products.last.id : null;
        _hasMore = products.length == _perPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: _buildProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product screen or implement inline form
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _products.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _products.length) {
          return ListTile(
            title: Text(_products[index].name),
            subtitle: Text(_products[index].price.toString()),
            onTap: () {
              // Implement update or delete functionality
            },
          );
        } else {
          if (_loading && _hasMore) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () => _loadMoreProducts(),
                child: Text('Load More'),
              ),
            );
          }
        }
      },
    );
  }
}
