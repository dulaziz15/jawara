import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/routes/app_router.dart';
import 'package:jawara/core/models/channel_models.dart';
import 'package:jawara/core/repositories/channel_repository.dart';

@RoutePage()
class ChannelDaftarPage extends StatefulWidget {
  const ChannelDaftarPage({super.key});

  @override
  State<ChannelDaftarPage> createState() => _ChannelDaftarPageState();
}

class _ChannelDaftarPageState extends State<ChannelDaftarPage> {
  final ChannelRepository _repository = ChannelRepository();
  String _searchQuery = '';

  Widget _buildStatusBadge(String tipe) {
    Color backgroundColor;

    switch (tipe.toLowerCase()) {
      case 'tv':
        backgroundColor = Colors.blue.shade200;
        break;
      case 'radio':
        backgroundColor = Colors.green.shade200;
        break;
      default:
        backgroundColor = Colors.grey.shade300;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(tipe, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void _showDeleteDialog(ChannelModel channel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus channel'),
        content: Text('Apakah kamu yakin ingin menghapus "${channel.nama}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _repository.deleteChannel(channel.docId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ChannelModel "${channel.nama}" berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ChannelModel channel) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black54),
      onSelected: (value) {
        if (value == 'detail') {
          context.router.push(ChannelDetailRoute(channelId: channel.docId));
        } else if (value == 'edit') {
          context.router.push(ChannelEditRoute(channelId: channel.docId));
        } else if (value == 'delete') {
          _showDeleteDialog(channel);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'detail', child: Row(children: [SizedBox(width: 8), Text('Detail')])),
        const PopupMenuItem(value: 'edit', child: Row(children: [SizedBox(width: 8), Text('Edit')])),
        const PopupMenuItem(value: 'delete', child: Row(children: [SizedBox(width: 8), Text('Hapus')])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari berdasarkan nama...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List Data dari Firebase
          Expanded(
            child: StreamBuilder<List<ChannelModel>>(
              stream: _repository.getChannels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }

                // Filter berdasarkan search query
                final displayedChannels = snapshot.data
                        ?.where((channel) => channel.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList() ??
                    [];

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '${displayedChannels.length} data ditemukan',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: displayedChannels.isEmpty
                          ? Center(
                              child: Text(
                                'Data tidak ditemukan',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: displayedChannels.length,
                              itemBuilder: (context, index) {
                                final channel = displayedChannels[index];
                                return _buildDataCard(channel);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(ChannelModel channel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(channel.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Tipe: ${channel.tipe}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('A/N: ${channel.an}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 8),
                _buildActionButton(channel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}