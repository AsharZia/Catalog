import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatalogScreen extends StatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _isLoading = false;
  var catalogs = List<Catalog>();

  @override
  void initState() {
    getCatalogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Catalog'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : catalogs.isEmpty
                ? Center(child: Text('Currently no catalog available'))
                : ListView.builder(
                    itemCount: catalogs.length,
                    itemBuilder: (builder, index) {
                      return ListTile(
                        title: Text(catalogs[index].name),
                      );
                    }),
      ),
    );
  }

  void getCatalogs() async {
    var url = 'https://5fc8e4482af77700165adf01.mockapi.io/catalog';
    try {
      setState(() {
        _isLoading = true;
      });
      var response = await http.get(url);
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      catalogs = parsed.map<Catalog>((json) => Catalog.fromJson(json)).toList();
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print(e);
      _showDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Failure"),
          content: Text("Unable to process request"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Catalog {
  String id;
  String createdAt;
  String name;
  String avatar;

  Catalog({this.id, this.createdAt, this.name, this.avatar});

  Catalog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}
