import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String version = '0.8.2+11';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text('Muffed', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Image.asset('assets/icon.png', width: 180, height: 180),
            Text(version),
            SizedBox(height: 24),
            ListTile(
              title: Text('GitHub'),
              subtitle: Text('github.com/freshfieldreds/muffed'),
              leading: Icon(Icons.code),
              onTap: () {
                launchUrl(
                  Uri.parse('https://github.com/freshfieldreds/muffed'),
                );
              },
            ),
            ListTile(
              title: Text('Lemmy Community'),
              subtitle: Text('sh.itjust.works/c/muffed'),
              leading: Icon(Icons.group),
              onTap: () {
                launchUrl(Uri.parse('https://sh.itjust.works/c/muffed'));
              },
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text('freshfieldreds@gmail.com'),
              leading: Icon(Icons.email),
              onTap: () {
                launchUrl(Uri.parse('mailto:freshfieldreds@gmail.com'));
              },
            ),
            ListTile(
              title: Text('Licences'),
              leading: Icon(Icons.library_books),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Muffed',
                  applicationVersion: version,
                  applicationIcon: Image.asset(
                    'assets/icon.png',
                    width: 196,
                    height: 196,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
