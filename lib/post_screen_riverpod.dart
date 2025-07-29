import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statement/models/post_model.dart';
import 'package:statement/provider/post_provider.dart';

class PostScreen extends ConsumerWidget {
  PostScreen({super.key});

  String? title;
  String? body;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsyncValue = ref.watch(postProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(postProvider.notifier).loadPosts();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Form(
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Add Post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      TextFormField(
                        onSaved: (newValue) {
                          title = newValue;
                        },
                        validator: (value) {
                          if (value == null || value.trim() == "") {
                            return "This is a required field";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Title"),
                        ),
                      ),
                      TextFormField(
                        onSaved: (newValue) {
                          body = newValue;
                        },
                        validator: (value) {
                          if (value == null || value.trim() == "") {
                            return "This is a required field";
                          }
                          return null;
                        },
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Body"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final messenger = ScaffoldMessenger.of(context);
                          if (_formKey.currentState?.validate() == true) {
                            _formKey.currentState?.save();
                            ref
                                .read(postProvider.notifier)
                                .createPost(
                                  Post(
                                    userId: 1,
                                    body: body ?? "",
                                    title: title ?? "",
                                  ),
                                )
                                .then((value) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Post created successfully!",
                                      ),
                                    ),
                                  );
                                })
                                .catchError((e) {
                                  messenger.showSnackBar(
                                    SnackBar(content: Text("$e")),
                                  );
                                  Navigator.of(context).pop();
                                });
                          }
                        },
                        child: Text("Create Post"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: postAsyncValue.when(
        data: (posts) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.read(postProvider.notifier).loadPosts();
            },
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text("${posts[index].id}")),
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].body),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("Error: $error"));
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
