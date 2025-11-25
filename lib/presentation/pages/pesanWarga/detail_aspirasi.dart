import 'package:flutter/material.dart';
import '../../../core/models/model_aspirasi.dart';

void showDetailModal(BuildContext context, AspirationData item) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Detail Aspirasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Judul', item.judul),
            _detailRow('Deskripsi', item.deskripsi),
            _detailRowWithStatus('Status', item.status),
            _detailRow('Dikirim oleh', item.pengirim),
            _detailRow('Tanggal', item.tanggal),
          ],
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () => Navigator.of(dialogContext).pop(),
        //     child: const Text('Tutup'),
        //   ),
        // ],
      );
    },
  );
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 100,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

Widget _detailRowWithStatus(String label, String status) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'diproses':
      return Colors.blue;
    case 'selesai':
      return Colors.green;
    case 'ditolak':
      return Colors.red;
    default:
      return Colors.grey;
  }
}