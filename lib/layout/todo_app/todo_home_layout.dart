import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
//import 'package:conditional_builder/conditional_builder.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/components/constants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget
{




  var scaffoldkey= GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();


  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener:(BuildContext context,AppStates state) {
          if (state is AppInsertDatabaseState ){
            Navigator.pop(context);

          }
        } ,
        builder: (BuildContext context,AppStates state) {
          AppCubit hussein = AppCubit.get(context);
          return Scaffold(
            key:scaffoldkey,
            appBar: AppBar(
              title: Text(
                  hussein.titles[hussein.currentIndex]
              ),
            ),
            body: ConditionalBuilder(
              builder:(context)=> hussein.screens[hussein.currentIndex] ,
              condition: state is! AppLoadingDatabaseState,
              fallback:(context)=> Center(child: CircularProgressIndicator()) ,

            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async
              {

                if(hussein.isBottomSheet) {
                  if(formKey.currentState!.validate())
                  {
                    hussein.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    //
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value)
                    //   {
                    //     Navigator.pop(context);
                    //
                    //     // setState((
                    //     //
                    //     //     ) {
                    //     //   isBottomSheet=false;
                    //     //   fabIcon=Icons.edit;
                    //     //   tasks=value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    //
                    //
                    //
                    //
                    //
                    // });

                  }

                }else
                {
                  scaffoldkey.currentState?.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.grey[300],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextField(
                                  controller: titleController,
                                  label: 'title',
                                  prefix: Icons.title,
                                  type: TextInputType.text,
                                  validate: ( value){
                                    if(value==null ||value.isEmpty)
                                    {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15.0),
                                defaultTextField(

                                  controller: timeController,
                                  label: 'time',
                                  prefix: Icons.watch_later_outlined,
                                  type: TextInputType.datetime,
                                  onTap: (){
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text=value.toString() ;

                                    });

                                  },
                                  validate: ( value){
                                    if(value==null ||value.isEmpty)
                                    {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 15.0),
                                defaultTextField(

                                  controller: dateController,
                                  label: 'date',
                                  prefix: Icons.date_range_outlined,
                                  type: TextInputType.datetime,
                                  onTap: (){
                                    showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-10-08'),
                                    ).then((value) {
                                      dateController.text=DateFormat.yMMMd().format(value!);


                                    });

                                  },
                                  validate: ( value){
                                    if(value==null ||value.isEmpty)
                                    {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),
                  ).closed.then((value) {

                    hussein.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });

                 hussein.changeBottomSheetState(isShow: true, icon: Icons.add);

                }


              },
              child: Icon(hussein.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: hussein.currentIndex,
              onTap: (value) {
                hussein.changeIndex(value);
              },

              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive',
                ),
              ],

            ),

          );
        },

      ),
    );
  }

  Future<String> getName() async
  {
    return 'hussein said maloka ';
  }


}


