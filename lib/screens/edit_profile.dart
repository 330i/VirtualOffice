import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Edit Profile'),
            ),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 75.0, vertical: 40),
                  width: 225,
                  height: 225,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://4.bp.blogspot.com/-0yA9cISY5WM/Wo0z6YjbDMI/AAAAAAAANqw/jAlP7Ge0wII4r0fwMEZESTyHXoAa9ef3gCLcBGAs/s1600/22580975_513736059005363_4184176973922172928_n.jpg'),
                      ),
                      boxShadow: [
                        BoxShadow(blurRadius: 7.0, color: Colors.black45)
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 100.0,
                  ),
                  width: 169,
                  height: 40,
                  child: FlatButton.icon(
                    color: Colors.blue,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: Text('Edit Profile Photo'),
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20.0),
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Edit Name"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          //open edit name
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.local_activity),
                        title: Text("Edit Hobbies"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          //open edit Hobbies
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    ),
  );
}
