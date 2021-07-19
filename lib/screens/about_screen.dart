import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  static const String id = 'about_screen';
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_left),
        ),
        title: Text('About'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('images/avatar_icon.png'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'K.A.Shabesa',
              style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 35.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
              width: 300.0,
              child: Divider(
                color: Colors.blue[900],
                thickness: 2,
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: IconButton(
                  color: Colors.black,
                  icon: FaIcon(FontAwesomeIcons.github),
                  onPressed: () {
                    setState(() {
                      _launchURL('https://github.com/shabesa');
                    });
                  },
                ),
                title: Text(
                  'shabesa',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'Source Sans Pro',
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: IconButton(
                  color: Colors.blue,
                  icon: FaIcon(FontAwesomeIcons.linkedin),
                  onPressed: () {
                    setState(() {
                      _launchURL(
                          'https://www.linkedin.com/in/k-a-shabesa-ab05751aa/');
                    });
                  },
                ),
                title: Text(
                  'K.A.Shabesa',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'Source Sans Pro',
                    fontSize: 20.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchURL(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}
