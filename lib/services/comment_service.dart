import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingopanda_task/models/comment.dart';
import 'package:lingopanda_task/utils/colors.dart';
import 'package:overlay_support/overlay_support.dart';

class CommentApi {
  String baseUrl = 'https://jsonplaceholder.typicode.com/comments';

  List<DioExceptionType> dioErrors = [
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.badCertificate,
    DioExceptionType.badResponse,
    DioExceptionType.cancel,
    DioExceptionType.connectionError,
    DioExceptionType.unknown,
  ];

  final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10)));

  Future<List<Comment>> getComments(int postId) async {
    try {
      Response response = await dio.get('$baseUrl?postId=$postId');

      List data = response.data;
      List<Comment> comments =
          data.map((data) => Comment.fromJson(data)).toList();
      return comments;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        showSimpleNotification(
          Text(
            'Connection timed out.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          background: kPrimaryColor,
          elevation: 5,
          position: NotificationPosition.bottom,
        );
        rethrow;
      }
      if (dioErrors.contains(e.type)) {
        showSimpleNotification(
          Text(
            e.message??'An error occurred while fetching comments.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          background: kPrimaryColor,
          elevation: 5,
          position: NotificationPosition.bottom,
        );
        rethrow;
      } else {
        showSimpleNotification(
          Text(
            e.message ?? 'An error occurred while fetching comments.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          background: kPrimaryColor,
          elevation: 5,
          position: NotificationPosition.bottom,
        );
        rethrow;
      }
    } catch (e) {
      showSimpleNotification(
        Text(
          e.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: kPrimaryColor,
        elevation: 5,
        position: NotificationPosition.bottom,
      );
      rethrow;
    }
  }
}
