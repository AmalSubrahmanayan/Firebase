import 'dart:io';

import 'package:firebase/screens/profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/alert_dialoge.dart';
import '../../../utils/core/constent_widgets.dart';
import '../../../widgets/textfeild_widgets.dart';
import '../../dashboard/controller/dashboard_provider.dart';

class ScreenProfile extends StatelessWidget {
  const ScreenProfile({
    super.key,
    required this.userId,
  });
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProfileProvider>(context, listen: false);
    final dashboard = Provider.of<DashBoardProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (dashboard.userModel == null) {
        return;
      } else {
        data.nameController.text = dashboard.userModel!.name.toString();
        data.emailController.text = dashboard.userModel!.email.toString();
        data.mobController.text = dashboard.userModel!.mob == "No Mobile Number"
            ? ''
            : dashboard.userModel!.mob.toString();

        Provider.of<ProfileProvider>(context, listen: false)
            .getProfileImage(userId);
        dashboard.getData();
        data.image = null;
        data.isEditing = false;
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () async {
              await data.signOutPage(context);
              data.image = null;
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: data.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Consumer(
                  builder: (BuildContext context, ProfileProvider value,
                      Widget? child) {
                    return value.isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(left: 30, top: 20),
                            child: CupertinoActivityIndicator(
                              color: Colors.black,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              SimpleDialogWidget.alertDialog(context);
                            },
                            child: Stack(
                              children: [
                                value.image == null
                                    ? value.downloadUrl == null
                                        ? CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 70,
                                            child: TextButton.icon(
                                              onPressed: () {
                                                SimpleDialogWidget.alertDialog(
                                                    context);
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'No Image',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              value.downloadUrl!,
                                            ),
                                            radius: 70,
                                          )
                                    : CircleAvatar(
                                        backgroundImage: FileImage(
                                          File(value.image!.path),
                                        ),
                                        radius: 70,
                                      ),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 110.0, left: 55),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                )
                              ],
                            ),
                          );
                  },
                ),
                ConstentWidget.kWidth32,
                Textfeildwidget(
                  readOnly: false,
                  validator: (value) =>
                      data.validation(value, "Enter Your Name"),
                  text: 'Enter Name',
                  icon: Icons.spatial_audio_rounded,
                  controller: data.nameController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      data.isEditing = true;
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ConstentWidget.kWidth20,
                Textfeildwidget(
                  keyboardType: TextInputType.phone,
                  readOnly: false,
                  validator: (value) => data.phoneValidation(value),
                  text:
                      dashboard.userModel?.mob.toString() != 'No Mobile Number'
                          ? 'Mobile Number'
                          : 'No Mobile Number',
                  icon: Icons.abc,
                  controller: data.mobController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      data.isEditing = true;
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ConstentWidget.kWidth20,
                Textfeildwidget(
                  readOnly: true,
                  validator: (value) {
                    return;
                  },
                  text: 'email id',
                  icon: Icons.email,
                  controller: data.emailController,
                ),
                ConstentWidget.kWidth32,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<ProfileProvider>(
                      builder: (BuildContext context, value, Widget? child) {
                        return value.isLoading
                            ? const CupertinoActivityIndicator(
                                color: Colors.cyan,
                              )
                            : TextButton.icon(
                                onPressed: () async {
                                  await data.submitUpdate(userId, context);
                                  dashboard.getData();
                                },
                                icon: const Icon(
                                  Icons.switch_account_rounded,
                                  color: Colors.black,
                                ),
                                label: const Text('Save'),
                              );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
