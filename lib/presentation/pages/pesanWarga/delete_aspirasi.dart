import 'package:flutter/material.dart';
import 'aspirasi.dart';

void showDeleteConfirmation(
  BuildContext context,
  AspirationData item,
  VoidCallback onDelete,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: Text(
        'Apakah Anda yakin ingin menghapus aspirasi "${item.judul}"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
