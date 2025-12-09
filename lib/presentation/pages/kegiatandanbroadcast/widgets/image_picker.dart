import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ImagePickerPreview extends StatefulWidget {
  final String type; // "gambar" atau "dokumen"
  const ImagePickerPreview({super.key, this.type = "gambar"});

  // --- STATIC VARIABLE AGAR BISA DIAKSES DARI BroadcastTambahPage ---
  static Map<String, File?> selectedFiles = {
    "gambar": null,
    "dokumen": null,
  };

  static void clearAll() {
    selectedFiles["gambar"] = null;
    selectedFiles["dokumen"] = null;
  }

  @override
  State<ImagePickerPreview> createState() => _ImagePickerPreviewState();
}

class _ImagePickerPreviewState extends State<ImagePickerPreview> {
  File? _localFile; // Untuk display di widget ini saja

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: widget.type == "gambar" ? FileType.image : FileType.custom,
      allowedExtensions: widget.type == "dokumen" ? ['pdf', 'doc', 'docx', 'xls', 'xlsx'] : null,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      
      setState(() {
        _localFile = file;
      });

      // SIMPAN KE STATIC VARIABLE
      ImagePickerPreview.selectedFiles[widget.type] = file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isImage = widget.type == "gambar";
    
    // Cek apakah ada file tersimpan (agar saat setState di parent tidak hilang)
    File? fileToShow = _localFile ?? ImagePickerPreview.selectedFiles[widget.type];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isImage ? "Maksimal ukuran 5MB" : "Dukungan PDF/DOC/XLS",
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 8),

        Center(
          child: fileToShow == null
              ? const Text("Belum ada file dipilih", style: TextStyle(color: Colors.black54))
              : isImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(fileToShow, width: 200, height: 200, fit: BoxFit.cover),
                    )
                  : Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.description, color: Colors.blue),
                          const SizedBox(width: 8),
                          Flexible(child: Text(fileToShow.path.split('/').last)),
                        ],
                      ),
                    ),
        ),
        const SizedBox(height: 10),

        Center(
          child: OutlinedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.file_present, color: Color(0xFF6C63FF)),
            label: const Text("Pilih file", style: TextStyle(color: Color(0xFF6C63FF))),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF6C63FF)),
            ),
          ),
        ),
      ],
    );
  }
}