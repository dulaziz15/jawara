import 'package:flutter/material.dart';
import 'aspirasi.dart';

Widget detailRow(String label, Widget value, {bool expand = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        expand ? Expanded(child: value) : value,
      ],
    ),
  );
}

Widget statusBadge(String status) {
  // ... (kode statusBadge Anda tetap sama)
  final color = switch (status.toLowerCase()) {
    'pending' => Colors.yellow.shade200,
    'diproses' => Colors.blue.shade200,
    'selesai' => Colors.green.shade200,
    _ => Colors.grey.shade300,
  };
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      status,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );
}

void showDetailModal(BuildContext context, AspirationData item) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Detail Aspirasi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          detailRow('Judul', Text(item.judul), expand: true),
          detailRow('Deskripsi', Text(item.deskripsi), expand: true),
          detailRow('Status', statusBadge(item.status), expand: false),
          detailRow('Dibuat oleh', Text(item.pengirim), expand: true),
          detailRow('Tanggal', Text(item.tanggal), expand: true),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(), // Hanya menutup popup
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}
