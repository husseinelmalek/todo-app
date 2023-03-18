


import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/layout/shop_app/cubit/shop_cubit.dart';
import 'package:untitled/models/shop_app/favorites_data_model.dart';
import 'package:untitled/models/shop_app/search_model.dart';
import 'package:untitled/modules/news_app/web_view/web_view_screen.dart';
import 'package:untitled/modules/todo_app/details/details.dart';

import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';
import 'package:untitled/shared/styles/colors.dart';



Widget defaultButton({
  double width =double.infinity,
  Color background= Colors.blue,

  required Function()? function,
  bool isUpperCase =true,
  required String text,

}) =>  Container(
  width: width,

   height: 40.0,
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(10.0),
  color: background,
),
  child: MaterialButton(

    onPressed: function,
    child: Text(
      isUpperCase ? text.toUpperCase() :text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),

  ),
);
Widget defaultTextField ({
  required TextEditingController controller,
required String label,
  required IconData prefix,
  IconData? suffix,
  required TextInputType type,
  bool isPassword =false,
   ValueChanged? onChange,
  Function(dynamic)? onSubmit,
  Function()? onTap,

  required FormFieldValidator validate,
  Function()? suffixPressed,




}) =>TextFormField(
  controller: controller,
  decoration: InputDecoration(
    labelText: label,

    border: OutlineInputBorder(),
    prefixIcon: Icon(
     prefix,
    ),
    suffixIcon: suffix !=null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
          suffix,
        ),
    ) : null,
  ),
  keyboardType: type,
  obscureText: isPassword,
  onChanged: onChange,
  onTap:onTap ,
  onFieldSubmitted: onSubmit,

  validator:validate,
);


Widget buildTaskItem(Map model , context) =>InkWell(
  onTap: () {
    navigateTo(context, Details(title:model['title'], time: model['time'], date: model['date']));
  },
  child:   Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(

      padding: const EdgeInsets.all(16.0),

      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child:Text('${model['time']}'),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],



            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateDatabase(status: 'done', id: model['id']);
              },



              icon: Icon(

                Icons.check_box,

                color:model['status'].toString() == 'new' ? Colors.orange : model['status'].toString() == 'done'? Colors.blue : Colors.red ,

              )

          ),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateDatabase(status: 'archive', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: model['status'].toString() == 'new' ? Colors.orange : model['status'].toString() == 'done'? Colors.blue : Colors.red,
              )
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
    AppCubit.get(context).deleteDatabase(id: model['id']);
    },

  ),
);

Widget myDivider()=> Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    height: 1.0,
    width: double.infinity,
    color: Colors.grey,
  ),
);

Widget taskBuilder({required List<Map> tasks}) => ConditionalBuilder(
condition: tasks.length > 0,
builder: (context) => ListView.separated(
itemBuilder: ( context, index) => buildTaskItem(tasks[index] , context),
separatorBuilder:(context, index) => myDivider(),
itemCount: tasks.length),
fallback: (context) => Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.menu,
size: 100.0,
color: Colors.grey,
),
Text('Not new tasks found , try again',
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 20,
color: Colors.grey,
),
),
],
),
),
);

Widget buildArticleItem(article,context) => InkWell(
  onTap: () {
    navigateTo(context, WebViewScreen(url: article['url'],));
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0),

            image: DecorationImage(

              image: NetworkImage('${article['urlToImage']}'),

              fit: BoxFit.cover,

            ),

          ),

        ),

        SizedBox(

          width: 15.0,

        ),

        Expanded(

          child: Container(

            height: 120.0,

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,



              children: [

                Expanded(

                  child: Text(

                    '${article['title']}',

                    style: Theme.of(context).textTheme.bodyText1,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,



                  ),

                ),

                Text('${article['publishedAt']}',



                  style: TextStyle(

                    fontSize: 18.0,

                    fontWeight: FontWeight.w400,

                    color: Colors.grey,

                  ),



                ),



              ],

            ),

          ),

        ),

      ],

    ),

  ),
);
Widget articleBuilder(list,context,{isSearch=false}) => ConditionalBuilder(
  condition:list.length > 0 ,
  builder: (context) => ListView.separated(
      physics:const BouncingScrollPhysics(),
      itemBuilder: (context, index) => buildArticleItem(list[index],context),
      separatorBuilder: (context, index) => myDivider(),
      itemCount: list.length),
  fallback: (context) => isSearch ? Container() : Center(child: CircularProgressIndicator()),);


void navigateTo(context,widget) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget)
);
void navigateAndFinish(context,widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
  (route) => false,
);

void showToast({
  required String text,
required ToastStates state,

}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastStates state){
Color color;
  switch(state)
  {
    case ToastStates.SUCCESS:
      color= Colors.green;
    break;
    case ToastStates.ERROR:
      color= Colors.red;
    break;
    case ToastStates.WARNING:
      color= Colors.amber;
    break;

  }
return color;
}

Widget buildListItem(ProductS favoritesData,context,{bool? isOld=true}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(image: NetworkImage(favoritesData.image),
              width: 120.0,
              height: 120.0,
            ),
            if(favoritesData.discount !=0 && isOld!)
              Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text('DISCOUNT',
                  style: TextStyle(
                    fontSize: 8.0,
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ),
        SizedBox(width: 20.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                favoritesData.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 1.3,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '${favoritesData.price}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: defaultColor,
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  if(favoritesData.discount !=0 && isOld!)
                    Text(
                      '${favoritesData.oldPrice}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                      onPressed: (){
                        ShopCubit.get(context).changeFavorites(favoritesData.id!);

                      },
                      icon:CircleAvatar(
                        backgroundColor:ShopCubit.get(context).favorites[favoritesData.id] ==true ? defaultColor : Colors.grey,
                        //ShopCubit.get(context).favorites[model.id] ==true ? defaultColor : Colors.grey,
                        child: Icon(Icons.favorite_border,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    ),
  ),
);

AppBar defaultAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,

})=> AppBar(
  titleSpacing: 5,
leading: IconButton(onPressed: () =>Navigator.pop(context) ,
icon: Icon(Icons.arrow_back_ios,
size: 16.0
),
),
title: Text(title),
actions: actions,

);
