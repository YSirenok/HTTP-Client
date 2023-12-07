import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    try {
      await fetchUsers();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      users = jsonList.map((json) => UserModel.fromJson(json)).toList();
      setState(() {});
    } else {
      throw HttpException(
          'Failed to load users. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display either a list of users or a loading indicator based on the users list
            users.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true, // Important to prevent rendering issues
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      // Build a ListTile for each user
                      final user = users[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
}
