import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPreview extends StatefulWidget {
  const ImagePickerPreview({super.key});

  @override
  State<ImagePickerPreview> createState() => _ImagePickerPreviewState();
}

class _ImagePickerPreviewState extends State<ImagePickerPreview> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Bukti Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Preview gambar
        Center(
          child: _image == null
              ? const Text(
                  'Belum ada foto dipilih',
                  style: TextStyle(color: Colors.black54),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        const SizedBox(height: 10),

        // Tombol pilih gambar
        Center(
          child: OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image, color: Color(0xFF6C63FF)),
            label: const Text(
              "Pilih Foto Bukti Pengeluaran",
              style: TextStyle(color: Color(0xFF6C63FF)),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF6C63FF)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
