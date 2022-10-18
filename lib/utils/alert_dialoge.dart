import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../screens/profile/controller/profile_controller.dart';

class SimpleDialogWidget {
  static void alertDialog(context) {
    final data = Provider.of<ProfileProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () async {
                  await data.getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.image),
                label: const Text('Add image'),
              ),
              TextButton.icon(
                onPressed: () async {
                  data.getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Pick image'),
              )
            ],
          ),
        ]);
      },
    );
  }
}
