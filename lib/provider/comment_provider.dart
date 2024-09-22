import 'package:flutter/material.dart';
import 'package:lingopanda_task/models/comment.dart';
import 'package:lingopanda_task/services/comment_service.dart';

class CommentProvider extends ChangeNotifier {
  final commentService = CommentApi();
  bool isLoading = false;
  List<Comment> comments = [];
  int postId = 1;

  void fetchNext() {
    postId++;
    notifyListeners();
    fetchComments();
  }

  Future<void> fetchComments() async {
    if (postId == 1) {
      isLoading = true;
      notifyListeners();
    }

    List<Comment> newComments = await commentService.getComments(postId);
    comments.addAll(newComments);
    isLoading = false;
    notifyListeners();
  }
}
