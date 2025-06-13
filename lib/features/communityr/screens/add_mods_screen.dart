import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/error_text.dart';
import 'package:my_flutter_app/common/loader.dart';
import 'package:my_flutter_app/features/auth/controller/auth_conroller.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';

class AddModsScreen extends ConsumerStatefulWidget {

  final String name;

  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {

  Set <String> uids={};
  int cntr=0;

  void addUid(String Uid){
    setState(() {
      uids.add(Uid);
    });
  }

  void removeUid(String Uid){
    setState(() {
      uids.remove(Uid);
    });
  }

  void saveMods(){
    ref.read(communityControllerProvider.notifier)
        .addMods(widget.name,
        uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: saveMods, icon: Icon(Icons.done))
        ],
      ),

      body:ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community)=>ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context,int index){

                final member=community.members[index];
               return ref.watch(getUserDataProvider(member)).when(
                    data:(user){
                      if(community.mods.contains(member) && cntr==0){
                        uids.add(member);
                      }
                      cntr ++;
                      return CheckboxListTile(
                        value: uids.contains(user.uid),
                        onChanged: (val){
                          if(val!){
                            addUid(user.uid);
                          }
                          else{
                            removeUid(user.uid);
                          }
                        },
                        title:Text(user.name));},
                  error: (error,stackTrace)=>ErrorText(error: error.toString()),
                  loading: ()=> const Loader(),);

              },
          ),


          error: (error,stackTrace)=>ErrorText(error: error.toString()),
          loading: ()=> const Loader(),)
    );
  }
}
