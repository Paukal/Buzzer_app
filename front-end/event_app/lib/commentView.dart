/*
* Lets Go App
* Paulius Tomas Kalvers
* Comment view logic
* */

import 'package:flutter/material.dart';
import 'client.dart';
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

    return /*Scaffold(
        appBar: AppBar(title: Text("Comments"),),
    body:*/Material(
        child: Stack(children: [
      FutureBuilder<CommentCollection>(
        future: commentList,
        builder:
            (BuildContext context, AsyncSnapshot<CommentCollection> snapshot) {
          if (snapshot.hasData) {
            comments = snapshot.data!;
            if (comments.list.isNotEmpty) {
              return Container(
                  height: 445,
                  child: ListView.builder(
                  itemCount: comments.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final commentObject = comments.list[index];

                    return Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(15),),
                        height: 50,
                        child: Row(children: [
                          s1.userId == commentObject.userId ? IconButton(
                            icon: const Icon(Icons.clear),
                            color: Colors.black,
                            tooltip: 'Filters',
                            onPressed: () {
                                sendDeleteCommentDataToServer(commentObject.commentId.toString());

                                setState(() {
                                  commentList = getComments(object, objectId.toString());
                                });
                            },
                          ) : Container(),
                        Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child:
                        Text(commentObject.comment)),
                          new Spacer(),
                          Column(
                            children: [
                              Text(commentObject.userName),
                              Text(commentObject.date.replaceRange(commentObject.date.length-3, commentObject.date.length, ""))
                            ],
                          )
                        ])));
                  }));
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
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(50)),
          width: 40,
          height: 40,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            color: Colors.white,
            tooltip: 'Filters',
            onPressed: () {
              if(comment != "") {
                sendComment(
                    s1.userId, s1.firstName, object, objectId.toString(),
                    comment);

                setState(() {
                  commentList = getComments(object, objectId.toString());
                });
              }
            },
          ),
        ),
      )
    ]));
  }
}
