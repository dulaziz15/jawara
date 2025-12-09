import 'package:flutter/material.dart';
import 'package:jawara/core/models/family_models.dart'; // Sesuaikan path import

class KeluargaDetailDialog extends StatelessWidget {
  final FamilyModel item;
  final VoidCallback onEditPressed;

  const KeluargaDetailDialog({
    super.key,
    required this.item,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detail Keluarga',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 16),

            // Content menggunakan data FamilyModel
            _buildDetailRow('No KK', item.noKk),
            const SizedBox(height: 12),
            _buildDetailRow('Nama Keluarga', item.namaKeluarga),
            const SizedBox(height: 12),
            _buildDetailRow('NIK Kepala', item.nikKepalaKeluarga),
            const SizedBox(height: 12),
            _buildDetailRow('Alamat', item.alamatRumah),
            const SizedBox(height: 12),
            _buildDetailRow('Kepemilikan', item.statusKepemilikanRumah),
            const SizedBox(height: 12),
            _buildDetailRow('Status Domisili', item.statusDomisiliKeluarga),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tutup'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onEditPressed();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}