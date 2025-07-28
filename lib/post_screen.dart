import 'package:flutter/material.dart';
import 'package:statement/models/post_model.dart';
import 'package:statement/services/api_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> posts = [];
  bool isLoading = false;
  String? error;
  String? title;
  String? body;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
      });

      posts = await ApiService.getPosts();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Something Went Wrong: $e";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          IconButton(
            onPressed: () {
              _loadPosts();
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

                            ApiService.createPost(
                                  Post(
                                    userId: 1,
                                    body: body ?? "",
                                    title: title ?? "",
                                  ),
                                )
                                .then((response) {
                                  _loadPosts();
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Post Created Successfully",
                                      ),
                                    ),
                                  );
                                })
                                .catchError((onError) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text("$onError"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });

                            Navigator.pop(context);
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error == null
          ? RefreshIndicator(
              onRefresh: () async {
                await _loadPosts();
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
            )
          : Center(child: Text(error.toString())),
    );
  }
}
