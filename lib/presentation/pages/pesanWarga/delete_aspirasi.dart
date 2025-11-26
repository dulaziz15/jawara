import 'package:flutter/material.dart';
import '../../../core/models/aspirasi_models.dart';

void showDeleteConfirmation(BuildContext context, AspirasiModels item) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus aspirasi "${item.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}