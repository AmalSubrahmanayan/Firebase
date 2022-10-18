import 'package:firebase/screens/adduser/controller/add_newuser_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/textfeild_widgets.dart';
import '../model/user_deltails_model.dart';

enum ActionType { addScreen, editscreen }

class ScreenAddUser extends StatelessWidget {
  const ScreenAddUser({
    super.key,
    required this.type,
    this.student,
  });
  final ActionType type;
  final DetailsModel? student;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AddNewUserProvider>(context, listen: false);

    if (type == ActionType.editscreen) {
      data.nameController.text = student!.name.toString();
      data.ageController.text = student!.age.toString();
      data.domainController.text = student!.domain.toString();
      data.mobController.text = student!.mobileNumber.toString();
    } else {
      data.nameController.clear();
      data.ageController.clear();
      data.domainController.clear();
      data.mobController.clear();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: data.formKey,
            child: Column(
              children: [
                Textfeildwidget(
                  readOnly: false,
                  text: 'First Name',
                  icon: Icons.nest_cam_wired_stand,
                  controller: data.nameController,
                  validator: (String? value) =>
                      data.validation(value, 'Enter your Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Textfeildwidget(
                  readOnly: false,
                  keyboardType: TextInputType.number,
                  text: 'Age',
                  icon: Icons.ac_unit_sharp,
                  controller: data.ageController,
                  validator: (String? value) =>
                      data.validation(value, 'Enter your Age'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Textfeildwidget(
                  readOnly: false,
                  text: 'domain',
                  icon: Icons.format_list_bulleted_rounded,
                  controller: data.domainController,
                  validator: (String? value) =>
                      data.validation(value, 'Enter your Domain'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Textfeildwidget(
                  readOnly: false,
                  keyboardType: TextInputType.phone,
                  text: 'Mobile Number',
                  icon: Icons.numbers,
                  controller: data.mobController,
                  validator: (String? value) =>
                      data.validation(value, 'Enter your Mobile Number'),
                ),
                const SizedBox(
                  height: 32,
                ),
                TextButton.icon(
                  onPressed: () async {
                    if (type == ActionType.editscreen) {
                      data.updateStudents(student!.uid!, context);
                      await data.getAllStudents(context);
                    } else {
                      if (data.formKey.currentState!.validate()) {
                        data.addNewUser(context);
                        await data.getAllStudents(context);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.recommend,
                    color: Colors.black,
                    size: 30,
                  ),
                  label: Text(
                    type == ActionType.addScreen ? 'Register' : 'save',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
