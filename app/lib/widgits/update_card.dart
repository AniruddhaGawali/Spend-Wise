import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:spendwise/widgits/buttet_points.dart';

class UpdateCard extends StatefulWidget {
  const UpdateCard({super.key});

  @override
  State<UpdateCard> createState() => _UpdateCardState();
}

class _UpdateCardState extends State<UpdateCard> {
  String _version = "";
  bool _downloaded = true;
  String _update = "";
  List? _description;

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update is Downloaded'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'The update is downloaded and ready to be installed.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Please install it manually.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FilledButton.tonal(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child: Text(
                'Approve',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    setState(() {
      _version = version;
    });

    Map update = await checkUpdate();

    if (update.isNotEmpty) {
      if (_version != update['version']) {
        setState(() {
          _update = update['update_link'];
          _description = update['description'];
        });
      }
    }
  }

  // ignore: non_constant_identifier_names
  Future<Map> checkUpdate() async {
    final url = "${dotenv.env['API_URL']}";

    http.Response response = await http.get(Uri.parse("$url/version"));

    Map<String, dynamic> result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result['latestUpdate'][0];
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Container(
          padding: const EdgeInsets.all(50),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                "SpendWise",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "v$_version",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  _description != null
                      ? Column(
                          children: [
                            Text("New Update Features",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.w600)),
                            ..._description!
                                .map((e) => BulletsPoints(
                                      text: e,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ))
                                .toList()
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FilledButton.icon(
                  onPressed: _update.isNotEmpty
                      ? () {
                          FileDownloader.downloadFile(
                            url: _update,
                            onProgress: (fileName, progress) {
                              setState(() {
                                _downloaded = false;
                              });
                            },
                            onDownloadCompleted: (fileName) {
                              setState(() {
                                _downloaded = true;
                              });
                              _showMyDialog();
                            },
                          );
                        }
                      : null,
                  icon: _downloaded
                      ? Icon(MdiIcons.update)
                      : SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(
                            strokeCap: StrokeCap.butt,
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                  label: _downloaded
                      ? const Text("Update")
                      : const Text("Downloading"))
            ],
          ),
        ),
      ],
    );
  }
}
