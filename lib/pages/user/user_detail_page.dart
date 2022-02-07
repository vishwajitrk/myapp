import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/blocs/user/user_bloc.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/widgets/circular_loading.dart';
import 'package:myapp/widgets/data_detail_item.dart';
import 'package:myapp/widgets/ink_button.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:AppBar(
        title: const Text("Profile", style: const TextStyle( fontSize: 25, color: Colors.white),),
        backgroundColor: const Color(0xFF1C85DD),
        elevation: 0.0,
      ),
      body: BlocProvider<UserBloc>(
        create: (context) => UserBloc()..add(GetIdEvent(id: 1)),
        child: ProfileDetail(),
      ) 
    );
  }
}

class ProfileDetail extends StatefulWidget {
  ProfileDetail({Key? key}) : super(key: key);

  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  List imagePicker = [];
  String sError = 'No Error Dectected';
  bool _editMode = false;
  String userBlank = "https://e7.pngegg.com/pngimages/647/460/png-clipart-computer-icons-open-person-family-icon-black-silhouette-black.png";
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void messageDialogs(BuildContext ctx, String title, String message){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
            title: Center(
              child: Text(title, style: const TextStyle(fontSize: 20),),
            ),
            content: Text(message),
            actions: [
              MaterialButton(
                child: const Text("Close"),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                  ctx.read<UserBloc>().add(GetIdEvent(id: 1));
                },
              )
            ],
          );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (contex, state){
        if(state is LoadingUser){
          WidgetsBinding.instance!.addPostFrameCallback((_) => loadingIndicator(context, "Loading..."));
        }
        else if(state is UserState && state.user != null){
          //close show loading
          Navigator.of(context, rootNavigator: true).pop();
        }
        else if(state is FailureUser){
          Navigator.of(context, rootNavigator: true).pop(); //close loading
          WidgetsBinding.instance!.addPostFrameCallback((_) => messageDialog(context, "Error", state.error));
        }
        else if(state is SuccessSaveUser){
          Navigator.of(context, rootNavigator: true).pop(); //close loading
          WidgetsBinding.instance!.addPostFrameCallback((_) => messageDialogs(context, "Success", "Update successfully"));
          setState(() {
            _editMode = false;
          });
        }
      },
      buildWhen: (prevState, currState){
        return currState is UserState && currState.user != null || currState is SuccessSaveUser;
      },
      builder: (context, state){
        return Container(
          color: Colors.white,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 450,
                        decoration: const BoxDecoration(
                          gradient:  LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.redAccent, Colors.pinkAccent]
                          )
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                height: 300,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                    image: (_editMode && _image != null) ? FileImage(_image!) : NetworkImage(state.user?.avatar?.replaceAll("localhost:3001", 'https://reqres.in') ?? userBlank) as ImageProvider ,
                                    fit: BoxFit.cover
                                  )
                                ),
                                child: InkWell(
                                  child: _editMode ?
                                    const Icon(Icons.camera_alt_outlined, size: 100, color: Colors.grey,) :
                                    Container(),
                                  onTap: (){
                                    getImage();
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              Card(
                                margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(

                                          children: const <Widget>[
                                             Text(
                                              "Followers",
                                              style:  TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                             SizedBox(
                                              height: 5.0,
                                            ),
                                             Text(
                                              "28.5K",
                                              style:  TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.pinkAccent,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(

                                          children: const <Widget>[
                                             Text(
                                              "Follow",
                                              style:  TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                             SizedBox(
                                              height: 5.0,
                                            ),
                                             Text(
                                              "1300",
                                              style:  TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.pinkAccent,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      

                      ListTile(
                        title: const Center(
                          child: Text(
                            '',
                            style:  TextStyle(
                                fontWeight: FontWeight.bold, fontSize:50),
                          ),
                        ),
                        trailing: InkWell(
                          onTap: (){
                            setState(() {
                              _editMode = true;
                            });
                          },
                          child: const Icon(Icons.edit_location_outlined, size: 50, color: Colors.black,),
                        ) 
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Info Profile',
                        style:  TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                (_editMode == true) ? formEdit(context, state.user) : 
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          DetailItem(
                            title: "First Name",
                            value: state.user?.firstName
                          ),
                          DetailItem(
                            title: "Last Name",
                            value: state.user?.lastName
                          ),
                          DetailItem(
                            title: "Email",
                            value: state.user?.email,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: MaterialButton(
                                color: const Color(0xFF735CEC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                                ),
                                elevation: 0.0,
                                padding: const EdgeInsets.all(0.0),
                                child: const InkButton(text: "Cancel"),
                                onPressed: (){},
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: MaterialButton(
                                color: const Color(0xFF735CEC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                                ),
                                elevation: 0.0,
                                padding: const EdgeInsets.all(0.0),
                                child: const InkButton(text: "Logout"),
                                onPressed: (){
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        );
      
      }, 
    );
    
  }  

  // Future<List<Asset>?> loadAssets() async {
  //   List<Asset> resultList = [];

  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 2,
  //       enableCamera: true,
  //       selectedAssets: imagePicker,
  //       cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#abcdef",
  //         actionBarTitle: "Image Example",
  //         allViewTitle: "All Photos",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     sError = e.toString();
  //   }

  //   if (!mounted) return null;

  //   setState(() {
  //     imagePicker = resultList;
  //     sError = 'No Error Dectected';
  //   });

  //   return resultList;
  // }

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget formEdit(BuildContext context, User? user){

    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    firstNameController.text = user?.firstName as String;
    lastNameController.text = user?.lastName as String;
    return Container(
      child:  Form(
        key: _formKey,
        child: Column(
          children: [
            DetailItemEditComponent(
              title: "First Name", 
              widget: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
                controller: firstNameController,
                decoration: const InputDecoration(
                  enabledBorder:  OutlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.grey, width: 1),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.grey, width: 1),
                  ),
                  border:  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey, width: 1),
                  ),
                  hintText: "First Name",
                ),
              ),
            ),

            DetailItemEditComponent(
              title: "Last Name", 
              widget: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
                controller: lastNameController,
                decoration: const InputDecoration(
                  enabledBorder:  OutlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.grey, width: 1),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.grey, width: 1),
                  ),
                  border:  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey, width: 1),
                  ),
                  hintText: "Last Name",
                ),
              ),
            ),
            DetailItem(
              title: "Email",
              value: user?.email,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        elevation: 0.0,
                        padding: const EdgeInsets.all(0.0),
                        child: const InkButton(text: "Update"),
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {

                            context.read<UserBloc>().add(SaveEvent(id: 1, firstName: firstNameController.text.trim(), lastName: lastNameController.text.trim(), file: _image));

                          }else{
                            WidgetsBinding.instance!.addPostFrameCallback((_) => messageDialog(context, "Error", "Error validation"));
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: MaterialButton(
                        onPressed: (){
                          setState(() {
                            _editMode = false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        elevation: 0.0,
                          padding: const EdgeInsets.all(0.0),
                        child: const InkButton(text: "Cancel"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}