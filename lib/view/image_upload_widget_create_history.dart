import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final TextEditingController imageController;
  final Function(XFile?) onImagePicked;

  const ImagePickerWidget({
    Key? key,
    required this.imageController,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        widget.imageController.text = pickedFile.path;
        widget.onImagePicked(pickedFile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Pick Image'),
        ),
        if (_imageFile != null) ...[
          SizedBox(width: 10),
          Text(_imageFile!.name),
        ],
      ],
    );
  }
}
