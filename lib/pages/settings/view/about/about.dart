import 'package:flutter/material.dart';
import 'package:muffed/router/router.dart';
import 'package:url_launcher/url_launcher.dart';

const String version = '0.8.5+14';

class AboutPage extends MPage<void> {
  const AboutPage();

  @override
  Widget build(BuildContext context) {
    return const _AboutView();
  }
}

class _AboutView extends StatelessWidget {
  const _AboutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('Muffed', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Image.asset('assets/icon.png', width: 180, height: 180),
            const Text(version),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('GitHub'),
              subtitle: const Text('github.com/freshfieldreds/muffed'),
              leading: const Icon(Icons.code),
              onTap: () {
                launchUrl(
                  Uri.parse('https://github.com/freshfieldreds/muffed'),
                );
              },
            ),
            ListTile(
              title: const Text('Lemmy Community'),
              subtitle: const Text('sh.itjust.works/c/muffed'),
              leading: const Icon(Icons.group),
              onTap: () {
                launchUrl(Uri.parse('https://sh.itjust.works/c/muffed'));
              },
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: const Text('freshfieldreds@gmail.com'),
              leading: const Icon(Icons.email),
              onTap: () {
                launchUrl(Uri.parse('mailto:freshfieldreds@gmail.com'));
              },
            ),
            ListTile(
              title: const Text('Licences'),
              leading: const Icon(Icons.library_books),
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
