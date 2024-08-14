import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia_testcode/provider/name_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/scheduler.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<dynamic> users = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isLastPage = false;
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

    if (isRefresh) {
      currentPage = 1;
      isLastPage = false;
      users.clear();
    }

    final response = await http.get(
        Uri.parse('https://reqres.in/api/users?page=$currentPage&per_page=10'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'].isEmpty) {
        setState(() {
          isEmpty = true;
        });
      } else {
        setState(() {
          users.addAll(data['data']);
          currentPage++;
          if (data['data'].length < 10) {
            isLastPage = true;
          }
          isEmpty = false;
        });
      }
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
          : RefreshIndicator(
              onRefresh: () => fetchUsers(isRefresh: true),
              child: ListView.builder(
                itemCount: isLastPage ? users.length : users.length + 1,
                itemBuilder: (context, index) {
                  if (index == users.length) {
                    // Use addPostFrameCallback to schedule fetchUsers after the current frame is done
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      fetchUsers();
                    });
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['avatar']),
                    ),
                    title: Text('${user['first_name']} ${user['last_name']}'),
                    subtitle: Text(user['email']),
                    onTap: () {
                      Provider.of<NameProvider>(context, listen: false).setName(
                          '${user['first_name']} ${user['last_name']}');
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
    );
  }
}
