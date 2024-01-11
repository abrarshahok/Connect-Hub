import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/components/loading.dart';
import '/repos/auth_repo.dart';
import '/service_locator/service_locator.dart';
import '../bloc/posts_bloc.dart';
import '/constants/constants.dart';
import '/models/comment_data_model.dart';
import '../../../components/custom_app_top_bar.dart';
import '../../../components/custom_icon_button.dart';
import '/features/posts/widgets/add_comment_field.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = '/comments-screen';
  CommentsScreen({super.key});
  final PostsBloc postsBloc = ServiceLocator.instance.get<PostsBloc>();
  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)?.settings.arguments as String;
    final postCommentsStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots();
    return BlocListener<PostsBloc, PostsState>(
      bloc: postsBloc,
      listenWhen: (previous, current) => current is PostsActionState,
      listener: (context, state) {},
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        appBar: customAppBar(
          showLeadingButton: true,
          leadingButton: CustomIconButton(
            color: MyColors.secondaryColor,
            icon: IconlyLight.arrow_left,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: 'Comments',
        ),
        body: StreamBuilder(
          stream: postCommentsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            final postDocs = snapshot.hasData ? snapshot.data!.docs : [];
            return ListView.builder(
                itemCount: postDocs.length,
                itemBuilder: (context, index) {
                  final commentData =
                      CommentDataModel.fromJson(postDocs[index].data());
                  String formatedDateTime =
                      DateFormat().add_MMMMd().format(commentData.commentedOn);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        commentData.userImageUrl,
                      ),
                    ),
                    title: Text(
                      '${commentData.username == AuthRepo.currentUser!.username ? 'You' : commentData.username} on $formatedDateTime',
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
                    trailing: commentData.userId == AuthRepo.currentUser!.uid
                        ? IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              color: MyColors.secondaryColor,
                            ))
                        : null,
                  );
                });
          },
        ),
        bottomNavigationBar: AddCommentField(
          postsBloc: postsBloc,
          postId: postId,
        ),
      ),
    );
  }
}
