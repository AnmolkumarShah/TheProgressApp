import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/place_holder_image.dart';
import 'package:progress2/Helper/send_notification.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Helper/text_form_field_helper.dart';
import 'package:progress2/Model/meeting_event.dart';
import 'package:progress2/Provider/member_provider.dart';
import 'package:provider/provider.dart';

class AddProjectScreen extends StatefulWidget {
  AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  List<PlatformFile>? selectedFiles;
  List<String>? urls;
  final Input _title = Input(label: "Meeting Title");
  final Input _meetingUrl = Input(label: "Meeting Url");

  final TextEditingController _textController = TextEditingController(text: "");
  bool _loading = false;
  bool _saveLoader = false;

  pickFiles() async {
    List<PlatformFile> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      allowMultiple: true,
    );
    if (result != null) {
      files = result.files;

      setState(() {
        selectedFiles = files;
      });
    } else {
      files = [];
    }
  }

  save() async {
    if (selectedFiles == null || urls == null || urls!.isEmpty) {
      setState(() {
        urls = [image];
      });
      showSnakeBar(context, "No Image is Selected");
    }
    if (_title.isEmpty() ||
        _textController.value.text == "" ||
        _meetingUrl.isEmpty()) {
      showSnakeBar(context, "Enter All Fields Properly");
      return;
    }

    setState(() {
      _saveLoader = true;
    });

    Meeting temp = Meeting(
      date: DateTime.now(),
      desc: _textController.value.text.trim(),
      title: _title.value(),
      meetingUrl: _meetingUrl.value(),
      urls: urls,
      by: Provider.of<MemberProvider>(context, listen: false).member.id,
    );

    bool res = await temp.save();
    if (value == true) sendNotification(_meetingUrl.value(), _title.value());
    if (res == true) {
      showSnakeBar(context, "Saved Successfully");
      reset();
    } else {
      showSnakeBar(context, "Error In Saving");
    }
    setState(() {
      _saveLoader = false;
    });
  }

  reset() {
    _title.setValue("");
    _textController.clear();
    _meetingUrl.setValue("");
    setState(() {
      selectedFiles = null;
    });
  }

  uploadFile() async {
    setState(() {
      _loading = true;
    });
    List<String> temp = [];
    await Future.forEach<PlatformFile>(selectedFiles!, (file) async {
      String destination = "files/${file.name}";
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask task = ref.putFile(File(file.path!));

        final snapshot = await task.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        temp.add(urlDownload);
        showSnakeBar(context,
            " ${selectedFiles!.indexOf(file) + 1} of ${selectedFiles!.length} File Uploaded ");
      } catch (e) {
        showSnakeBar(context, "Error In File Upload ${e.toString()}");
      }
    });

    if (temp.isEmpty) {
      urls!.add(image);
    }

    setState(() {
      _loading = false;
      urls = temp;
    });
  }

  bool value = false;
  setValue(val) {
    setState(() {
      value = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () => AdminStartUp());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Add Meeting")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectedFiles != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShowSelectedFile(files: selectedFiles!),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              key: const Key("Anmol"),
                              onPressed: reset,
                              child: const Icon(Icons.delete),
                              backgroundColor: Colors.red,
                            ),
                            const SizedBox(width: 20),
                            _loading == true
                                ? const Loader()
                                : FloatingActionButton(
                                    key: const Key("shah"),
                                    onPressed: uploadFile,
                                    child: const Icon(Icons.upload),
                                    backgroundColor: Colors.blue,
                                  ),
                          ],
                        )
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child: DottedBorder(
                        color: Colors.black,
                        strokeWidth: 4,
                        radius: const Radius.circular(5),
                        dashPattern: const [8, 4],
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: pickFiles,
                            icon: const Icon(Icons.search),
                            label: const Text("Select Files"),
                          ),
                        ),
                      ),
                    ),
              _title.builder(),
              _meetingUrl.builder(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  minLines: 9,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Write Your Description Here",
                  ),
                ),
              ),
              ListTile(
                leading: const Text("Notify All Members"),
                trailing: Switch(value: this.value, onChanged: setValue),
              ),
              _saveLoader == true
                  ? const Loader()
                  : ElevatedButton.icon(
                      onPressed: save,
                      icon: const Icon(Icons.save),
                      label: const Text("Save"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowSelectedFile extends StatelessWidget {
  ShowSelectedFile({Key? key, required this.files}) : super(key: key);
  List<PlatformFile> files;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider(
        items: files.map((e) {
          return SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                File(e.path!),
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 200,
          // aspectRatio: 20 / ,
          // viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          // onPageChanged: callbackFunction,
          scrollDirection: Axis.horizontal,
          viewportFraction: 0.5,
        ),
      ),
    );
  }
}

class AdminStartUp extends StatelessWidget {
  AdminStartUp({Key? key}) : super(key: key);

  final Input _email = Input(label: "Email");
  final Input _pass = Input.password(label: "Password");

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> loginDetailStream =
        FirebaseFirestore.instance.collection("login").snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: loginDetailStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        List<Map<String, dynamic>> data = snapshot.data!.docs
            .map((e) => {'email': e['email'], 'password': e['password']})
            .toList();
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _email.builder(),
              _pass.builder(),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                bool loginResult = data.any((e) {
                  if (e['email'] == _email.value() &&
                      e['password'] == _pass.value()) {
                    return true;
                  } else {
                    return false;
                  }
                });

                if (loginResult == false) {
                  showSnakeBar(context, "Email or Password not Matched");
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  showSnakeBar(context, "Welcome Admin");
                  Navigator.pop(context);
                }
              },
              child: const Text("Login"),
            )
          ],
        );
      },
    );
  }
}
