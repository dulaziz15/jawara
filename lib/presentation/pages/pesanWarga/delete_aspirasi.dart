import 'package:flutter/material.dart';
import 'aspirasi.dart';

void showDeleteConfirmation(
  BuildContext context,
  AspirationData item,
) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: Text(
        'Apakah Anda yakin ingin menghapus aspirasi "${item.judul}"?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop(); // Hanya menutup dialog
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop(); // Hanya menutup dialog
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
