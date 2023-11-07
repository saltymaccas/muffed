import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const String version = '0.8.0+9';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      final String appName = packageInfo.appName;
      final String packageName = packageInfo.packageName;
      final String version = packageInfo.version;
      final String buildNumber = packageInfo.buildNumber;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text('Muffed', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Image.asset('assets/icon.png', width: 180, height: 180),
            Text('Version $version',
                style: Theme.of(context).textTheme.bodyMedium),
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
