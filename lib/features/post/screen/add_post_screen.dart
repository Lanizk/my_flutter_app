import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';


class AddPostScreen extends ConsumerWidget{
  const AddPostScreen({super.key});

  void navigateTotype(BuildContext context, String type){
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {



   double cardHeightWidth=120;
   double iconSize=60;
   final currentTheme=ref.watch(themeNotifierProvider);


    return Row (
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
      GestureDetector(
        onTap: ()=>navigateTotype(context,'image'),
        child: SizedBox(
          height: cardHeightWidth,
          width: cardHeightWidth,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            color: currentTheme.scaffoldBackgroundColor,
            elevation: 16,
            child:  Center(
              child: Icon(Icons.image_outlined,
              size: iconSize,),
            ),
          ),
        ),
      ),

      GestureDetector(
        onTap: ()=>navigateTotype(context,'text'),
        child: SizedBox(
          height: cardHeightWidth,
          width: cardHeightWidth,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            color: currentTheme.scaffoldBackgroundColor,
            elevation: 16,
            child:  Center(
              child: Icon(Icons.font_download_outlined,
                size: iconSize,),
            ),
          ),
        ),
      ),

      GestureDetector(
        onTap: ()=>navigateTotype(context,'link'),
        child: SizedBox(
          height: cardHeightWidth,
          width: cardHeightWidth,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            color: currentTheme.scaffoldBackgroundColor,
            elevation: 16,
            child:  Center(
              child: Icon(Icons.link_outlined,
                size: iconSize,),
            ),
          ),
        ),
      )
    ],

    );
  }
}