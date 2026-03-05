import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_drawer.dart';

class AboutScreen extends StatelessWidget {
  final String userPhotoAsset = 'assets/foto.png';
  final String contactName = 'Victor'; 
  final String contactEmail = 'victorr116@hotmail.com'; 
  final String contactPhone = '829-698-5598'; 

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de')),
      drawer: CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(userPhotoAsset),
              ),
              SizedBox(height: 20),
              Text(
                contactName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Desarrollador de Software',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blue),
                      title: Text(contactEmail),
                      onTap: () => _launchUrl('mailto:$contactEmail'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.green),
                      title: Text(contactPhone),
                      onTap: () => _launchUrl('tel:$contactPhone'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Disponible para trabajos y colaboraciones.',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
