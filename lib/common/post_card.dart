import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/theme/pallete.dart';
import '../features/auth/controller/auth_conroller.dart';
import '../model/post_model.dart';

class PostCard extends ConsumerWidget{

  final Post post;
  const PostCard({
    super.key,
    required this.post
});


  @override

  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,

                          ).copyWith(right: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            post.communityProfilePic
                                        ),
                                        radius: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          children: [
                                            Text('r/${post.communityName}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                )),

                                            Text('u/${post.username}',
                                                style: TextStyle(
                                                  fontSize: 12,

                                                ))
                                          ],
                                        ),),

                                    ],

                                  ),
                                  if(post.uid == user.uid)
                                    IconButton(
                                        icon: Icon(Icons.delete,
                                          color: Pallete.redColor,))
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                    post.title,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,

                                    )
                                ),
                              ),
                              if(isTypeImage)
                                SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.35,
                                  width: double.infinity,
                                  child: Image.network(post.link!,
                                    fit: BoxFit.cover,),

                                ),

                              if(isTypeLink)
                                  child: AnyLinkPreview(
                                    displayDirection: UIDirection
                                        .uiDirectionHorizontal,
                                    link: post.link!,
                                  ),

                                ),

                              if(isTypeText)
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child:  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(post.description!,
                                      style: TextStyle(
                                          color: Colors.grey),),
                                  ),


                                    ],
                          )
                      )

                    ],
                  ),
                )
              ],
            ),
          )
        ]
    );
  }
  }
