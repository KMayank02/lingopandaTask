import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:lingopanda_task/provider/auth_provider.dart';
import 'package:lingopanda_task/provider/comment_provider.dart';
import 'package:lingopanda_task/screens/comments/components/comment_tile.dart';
import 'package:lingopanda_task/utils/colors.dart';
import 'package:lingopanda_task/utils/size_config.dart';
import 'package:provider/provider.dart';

class CommentListBody extends StatefulWidget {
  const CommentListBody({super.key});

  @override
  State<CommentListBody> createState() => _CommentListBodyState();
}

class _CommentListBodyState extends State<CommentListBody> {
  final remoteConfigs = FirebaseRemoteConfig.instance;
  late CommentProvider commentProvider;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  void initState() {
    super.initState();
    _initConfig();
    Future.delayed(Duration.zero, () {
      commentProvider = Provider.of<CommentProvider>(context, listen: false);
      commentProvider.fetchComments();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          commentProvider.postId <= 100) {
        commentProvider.fetchNext();
      }
    });
  }

  _initConfig() async {
    setState(() {
      isLoading = true;
    });
    // await remoteConfigs.setDefaults({'maskEmail': false});
    await remoteConfigs.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 10)));
    await remoteConfigs.fetchAndActivate();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<UserAuthProvider>(context);
    return Consumer<CommentProvider>(
      builder: (context, value, child) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(color: kPrimaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                    IconButton(
                        onPressed: () async {
                          final shouldLogOut = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              Map<String, bool> options = {
                                'Cancel': false,
                                'Log out': true,
                              };
                              return AlertDialog(
                                title: Text(
                                  'Log out',
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  'Are you sure you want to log out?',
                                  style: TextStyle(color: kTextColor),
                                ),
                                actions: options.keys.map((optionTitle) {
                                  final value = options[optionTitle];
                                  return TextButton(
                                    onPressed: () {
                                      if (value != null) {
                                        Navigator.of(context).pop(value);
                                      } else {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text(
                                      optionTitle,
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ).then(
                            (value) => value ?? false,
                          );
                          if (shouldLogOut) {
                            user.signOut();
                          }
                        },
                        icon: Icon(
                          Icons.logout_rounded,
                          color: kWhiteColor,
                        ))
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      verticalSpaceDefault,
                      verticalSpaceDefault,
                      isLoading || value.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ))
                          : Container(
                              width: SizeConfig.screenWidth,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: ListView.builder(
                                itemCount: value.comments.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      CommentTile(
                                        comment: value.comments[index],
                                        mask:
                                            remoteConfigs.getBool('maskEmail'),
                                      ),
                                      verticalSpaceSmall,
                                    ],
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
