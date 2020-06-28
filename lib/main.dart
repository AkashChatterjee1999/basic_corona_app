import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as ht;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new home_page(),
    );
  }
}
class home_page extends StatefulWidget {
  @override
  _home_pageState createState() => _home_pageState();
}

class corona_class{
  int NewConfirmed;
  int TotalConfirmed;
  int NewDeaths;
  int TotalDeaths;
  int NewRecovered;
  int TotalRecovered;
  corona_class(int a,int b,int c,int d,int e,int f){
    this.NewConfirmed = a;
    this.TotalConfirmed = b;
    this.NewDeaths = c;
    this.TotalDeaths = d;
    this.NewRecovered = e;
    this.TotalRecovered = f;
  }
  static corona_class parseJson(Map<String,dynamic> Json){
    int a = Json["Global"]['NewConfirmed'];
    int b = Json["Global"]['TotalConfirmed'];
    int c = Json["Global"]['NewDeaths'];
    int d = Json["Global"]['TotalDeaths'];
    int e = Json["Global"]['NewRecovered'];
    int f = Json["Global"]['TotalRecovered'];
    corona_class ob = new corona_class(a, b, c, d, e, f);
    return ob;
  }
}

class _home_pageState extends State<home_page> {
  @override
  Future<corona_class> data;
  void initState(){
    super.initState();
    data = fetch_data();
  }
  Future<corona_class> fetch_data() async{
    var response = await ht.get('https://api.covid19api.com/summary');
    if(response.statusCode==200){ //Status code 200 means everything correct
      return corona_class.parseJson(json.decode(response.body));
    }
    else
      throw Exception("Trouble getting Data");
  }
  Widget build(BuildContext rahul3tier) {
    return Scaffold(
      body:FutureBuilder<corona_class>(
        future: data,
        builder: (rahul3tier,snapshot){
          if(snapshot.hasData) {
            var repo = snapshot.data;
            return Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SizedBox(height: 40.0,),
                    Row(
                        children: <Widget>[
                          SizedBox(width: 20.0),
                          Text("COVID-19 Tracker", style: TextStyle(
                              color: Colors.red, fontSize: 20.0),)
                        ]
                    ),
                    SizedBox(height: 30.0,),
                    __build_card__(
                        "Newly Confirmed", repo.NewRecovered, Colors.red),
                    SizedBox(height: 30.0,),
                    __build_card__(
                        "Total Confirmed", repo.TotalConfirmed, Colors.orange),
                    SizedBox(height: 30.0,),
                    __build_card__("New Deaths", repo.NewDeaths, Colors.black),
                    SizedBox(height: 30.0,),
                    __build_card__("Total Deaths", repo.TotalDeaths, Colors.blue),
                    SizedBox(height: 30.0,),
                    __build_card__("New Recovered", repo.NewRecovered, Colors.green),
                    SizedBox(height: 30.0,),
                    __build_card__("Total Recovered", repo.TotalRecovered, Colors.cyan),
                    SizedBox(height: 40.0,),
                  ],
                )
              );
            }
            else if(snapshot.hasError){
              return Center(child: Text("Error Getting data",style:TextStyle(fontSize: 25.0)));
            }
            return Center(child: new CircularProgressIndicator());
          }
          )
    );
  }
  Widget __build_card__(String type,int no,Color c){
    return Container(
      height: 120.0,
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0,),
          Text(type,style: TextStyle(color:c,fontSize: 20.0,fontStyle: FontStyle.italic),),
          SizedBox(height:20.0),
          Text(no.toString(),style: TextStyle(color:c,fontSize: 50.0),)
        ],
      ),
    );
  }
}

