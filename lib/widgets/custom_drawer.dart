import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/foto.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'ToolBox App',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: Icon(Icons.wc),
            title: Text('Predecir Género'),
            onTap: () => Navigator.pushReplacementNamed(context, '/gender'),
          ),
          ListTile(
            leading: Icon(Icons.cake),
            title: Text('Predecir Edad'),
            onTap: () => Navigator.pushReplacementNamed(context, '/age'),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Universidades'),
            onTap: () => Navigator.pushReplacementNamed(context, '/universities'),
          ),
          ListTile(
            leading: Icon(Icons.cloud),
            title: Text('Clima en RD'),
            onTap: () => Navigator.pushReplacementNamed(context, '/weather'),
          ),
          ListTile(
            leading: Icon(Icons.catching_pokemon),
            title: Text('Pokemon'),
            onTap: () => Navigator.pushReplacementNamed(context, '/pokemon'),
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('Noticias WP'),
            onTap: () => Navigator.pushReplacementNamed(context, '/wordpress'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            onTap: () => Navigator.pushReplacementNamed(context, '/about'),
          ),
        ],
      ),
    );
  }
}
