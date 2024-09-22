import 'package:flutter/material.dart';
import 'package:lingopanda_task/models/comment.dart';
import 'package:lingopanda_task/utils/colors.dart';
import 'package:lingopanda_task/utils/size_config.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, required this.mask});

  final Comment comment;
  final bool mask;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: kSecondaryColor,
            child: Text(
              comment.name[0].toUpperCase(),
              style: TextStyle(
                  color: kTextColor, fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          horizontalSpaceDefault,
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name : ',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        comment.name,
                        style: TextStyle(
                            color: kTextColor, fontWeight: FontWeight.bold),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Email : ',
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        mask
                            ? comment.email.substring(0, 3) +
                                '*' * (comment.email.indexOf('@') - 3) +
                                comment.email
                                    .substring(comment.email.indexOf('@'))
                            : comment.email,
                        style: TextStyle(
                            color: kTextColor, fontWeight: FontWeight.bold),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Text(
                  comment.body,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                  softWrap: true,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
