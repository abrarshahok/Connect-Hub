import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/components/loading.dart';
import '../../../auth/data/auth_repository.dart';
import '/service_locator/service_locator.dart';
import '../bloc/posts_bloc.dart';
import '/constants/constants.dart';
import '../../domain/comment_data_model.dart';
import '../../../../components/custom_app_top_bar.dart';
import '../widgets/add_comment_field.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = '/comments-screen';
  CommentsScreen({super.key});
  final _postsBloc = ServiceLocator.instance.get<PostsBloc>();
  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)?.settings.arguments as String;
    final postCommentsStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots();
    return BlocListener<PostsBloc, PostsState>(
      bloc: _postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      listener: (context, state) {},
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: customAppBar(
          showLeadingButton: true,
          title: 'Comments',
        ),
        body: StreamBuilder(
          stream: postCommentsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            final postDocs = snapshot.hasData ? snapshot.data!.docs : [];
            if (postDocs.isEmpty) {
              return Center(
                child: Text(
                  'No Comments!',
                  style: MyFonts.bodyFont(),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: postDocs.length,
                    itemBuilder: (context, index) {
                      final commentData =
                          CommentDataModel.fromJson(postDocs[index].data());
                      String formatedDateTime = DateFormat()
                          .add_MMMMd()
                          .format(commentData.commentedOn);
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(
                            commentData.userImageUrl,
                          ),
                        ),
                        title: Text(
                          '${commentData.username == AuthRepository.currentUser!.username ? 'You' : commentData.username} on $formatedDateTime',
                          style: MyFonts.bodyFont(
                            fontColor: MyColors.secondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        subtitle: Text(
                          commentData.comment,
                          style: MyFonts.bodyFont(
                            fontColor: MyColors.secondaryColor,
                          ),
                        ),
                        trailing: commentData.userId ==
                                AuthRepository.currentUser!.uid
                            ? IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.more_vert,
                                  color: MyColors.secondaryColor,
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
                AddCommentField(
                  postsBloc: _postsBloc,
                  postId: postId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
