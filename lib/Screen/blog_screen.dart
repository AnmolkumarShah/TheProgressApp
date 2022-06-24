import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/place_holder_image.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Helper/text_form_field_helper.dart';
import 'package:progress2/Model/blog_event.dart';
import 'package:progress2/Model/meeting_event.dart';
import 'package:progress2/Provider/member_provider.dart';
import 'package:progress2/Screen/admin_add_meeting.dart';
import 'package:provider/provider.dart';

class AddBlogScreen extends StatefulWidget {
  AddBlogScreen({Key? key}) : super(key: key);

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  List<PlatformFile>? selectedFiles;
  List<String>? urls;
  final Input _title = Input(label: "Blog Title");
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
    if (_title.isEmpty() || _textController.value.text == '') {
      showSnakeBar(context, "Enter All Fields Properly");
      return;
    }

    setState(() {
      _saveLoader = true;
    });

    Blog temp = Blog(
      date: DateTime.now(),
      text: _textController.value.text,
      title: _title.value(),
      urls: urls,
      by: Provider.of<MemberProvider>(context, listen: false).member.id,
    );

    bool res = await temp.save();
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

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () => AdminStartUp());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Write A Blog")),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  minLines: 9,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Write Your Blog Here",
                  ),
                ),
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
