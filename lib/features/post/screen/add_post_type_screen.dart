import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/error_text.dart';
import 'package:my_flutter_app/common/loader.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';

import '../../../core/utils.dart';
import '../../../model/community_model.dart';
import '../../../theme/pallete.dart';
import '../controller/post_controller.dart';


class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController=TextEditingController();
  final descriptionController=TextEditingController();
  final linkController=TextEditingController();
  File? bannerFile;
  List <Community> communities=[];
  Community? selectedCommunity;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost(){

    if(widget.type== 'image' && bannerFile !=null && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile,
      );
    }

    else if(widget.type== 'text' &&  titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        description: descriptionController.text.trim()
      );
    }

    else if(widget.type== 'link' &&  titleController.text.isNotEmpty && linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim()
      );
    }
    else{
      showSnackBar(context, 'Please Enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage= widget.type=='image';
    final isTypeText= widget.type=='text';
    final isTypeLink= widget.type=='link';
    final currentTheme=ref.watch(themeNotifierProvider);
    final isLoading=ref.watch(postControllerProvider);


    return Scaffold(
      appBar: AppBar(
        title: Text('post ${widget.type}'),
        actions: [
          TextButton(onPressed: sharePost, child:const Text('Share'))
        ],
      ),
      body: isLoading ? const Loader(): Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter title here',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
              ),
              maxLength: 30,
            ),
            const SizedBox(height:  10,),
            if (isTypeImage)
            GestureDetector(
              onTap: selectBannerImage,
              child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color:currentTheme.textTheme.bodySmall!.color!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    child: bannerFile != null
                        ? Image.file(bannerFile!):
                        const Center(
                        child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40))

                  )),
            ),

            if(isTypeText)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Description Here',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),

            if(isTypeLink)
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Link Here',
                  border: InputBorder.none,
                  contentPadding:  EdgeInsets.all(18),
                ),

              ),
           const SizedBox(height: 20,),
            Align(
              alignment:Alignment.topLeft,
              child: Text('Select Community'),),
            
            ref.watch(userCommunitiesProvider).when(
                data: (data){
                  communities=data;
                  if(data.isEmpty){
                    return const SizedBox();
                  }
                  
                  return DropdownButton(
                      value:selectedCommunity?? data[0],
                      items: data.map(
                          (e)=>DropdownMenuItem(
                    value:e ,
                    child: Text(e.name),
                  ),).toList(),
                      onChanged: (val){
                        setState(() {
                          selectedCommunity=val;
                        });
                      });
                },
                error: (error,StackTrace)=>ErrorText(error: error.toString()),
                loading:()=> const Loader()),

          ],
        ),
      ),
    );
  }
}
