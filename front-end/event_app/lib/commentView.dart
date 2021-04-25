import 'package:flutter/material.dart';
import 'eventsParse.dart';
import 'placesParse.dart';
import 'client.dart';
import 'eventFilter.dart';
import 'placeFilter.dart';
import 'eventView.dart';
import 'placeView.dart';
import 'menu.dart';

class CommentCollection {
  final List<Comment> list;

  CommentCollection(this.list);

  factory CommentCollection.fromJson(List<dynamic> json) =>
      CommentCollection(json.map((e) => Comment.fromJson(e)).toList());
}

class Comment {
  final int commentId;
  final String userId;
  final String userName;
  final String object;
  final String objectId;
  final String date;
  final String comment;

  Comment(this.commentId, this.userId, this.userName, this.object,
      this.objectId, this.date, this.comment);

  factory Comment.fromJson(List<dynamic> json) =>
      Comment(json[0], json[1], json[2], json[3], json[4], json[5], json[6]);

  Map<String, dynamic> toMap() {
    return {
      'comment_id': commentId,
      'user_id': userId,
      'user_name': userName,
      'object': object,
      'object_id': objectId,
      'date': date,
      'comment': comment,
    };
  }
}

class CommentView extends StatefulWidget {
  CommentView(this.object, this.objectId);

  final String object;
  final int objectId;

  @override
  _CommentViewState createState() => _CommentViewState(object, objectId);
}

class _CommentViewState extends State<CommentView> {
  _CommentViewState(this.object, this.objectId);

  final String object;
  final int objectId;

  var s1 = LoggedInSingleton();
  late Future<CommentCollection> commentList;
  late String comment;

  @override
  void initState() {
    super.initState();

    commentList = getComments(object, objectId.toString());
  }

  @override
  Widget build(BuildContext context) {
    CommentCollection comments;

    return Material(
        child: Stack(children: [
      FutureBuilder<CommentCollection>(
        future: commentList,
        builder:
            (BuildContext context, AsyncSnapshot<CommentCollection> snapshot) {
          if (snapshot.hasData) {
            comments = snapshot.data!;
            if (comments.list.isNotEmpty) {
              return ListView.builder(
                  itemCount: comments.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final commentObject = comments.list[index];

                    return Container(
                        height: 50,
                        color: Colors.amber[200],
                        child: Row(children: [
                          Text(commentObject.comment),
                          Text("                                        "),
                          Column(
                            children: [
                              Text(commentObject.userName),
                              Text(commentObject.date)
                            ],
                          )
                        ]));
                  });
            } else {
              return Center(
                  child: Text(
                'No comments to show',
                textAlign: TextAlign.center,
              ));
            }
          } else {
            return Center(
                child: Text(
              'No comments to show',
              textAlign: TextAlign.center,
            ));
          }
        },
      ),
      Positioned(
        top: 450,
        right: 60,
        left: 50,
        child: TextFormField(
          decoration: InputDecoration(labelText: "Type comment"),
          onTap: () {
            setState(() {});
          },
          onChanged: (String? newValue) {
            setState(() {
              comment = newValue!;
            });
          },
        ),
      ),
      Positioned(
        top: 450,
        right: 60,
        left: 280,
        child: ElevatedButton(
          onPressed: () {
            sendComment(
                s1.userId, s1.firstName, object, objectId.toString(), comment);

            setState(() {
              commentList = getComments(object, objectId.toString());
            });
          },
          child: const Icon(Icons.navigation, size: 20),
        ),
      )
    ]));
  }
}
