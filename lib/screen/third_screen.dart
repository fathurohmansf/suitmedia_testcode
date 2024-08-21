import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia_testcode/provider/name_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<dynamic> users = [];
  int page = 1;
  int totalPages = 10;
  bool isLoading = false;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://reqres.in/api/users?page=$page&per_page=10'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> newUsers = data['data'];
      totalPages = data['total_pages'];

      setState(() {
        if (isRefresh) {
          users = newUsers;
        } else {
          users.addAll(newUsers);
        }
        isEmpty = users.isEmpty;
      });
    } else {
      // Handle errors
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
        centerTitle: true,
      ),
      body: isEmpty
          ? const Center(child: Text('No Users Available'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['avatar']),
                        ),
                        title:
                            Text('${user['first_name']} ${user['last_name']}'),
                        subtitle: Text(user['email']),
                        onTap: () {
                          Provider.of<NameProvider>(context, listen: false)
                              .setName(
                                  '${user['first_name']} ${user['last_name']}');
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                NumberPaginator(
                  numberPages: totalPages,
                  onPageChange: (index) {
                    setState(() {
                      page = index + 1;
                      fetchUsers(isRefresh: true);
                    });
                  },
                ),
              ],
            ),
    );
  }
}
