import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/routes/app_router.dart';
import 'package:jawara/presentation/pages/Channel/channel_detail.dart'; // import halaman detail

class Channel {
  final int id;
  final int no;
  final String nama;
  final String tipe;
  final String an;
  final String thumbnail;

  const Channel({
    required this.id,
    required this.no,
    required this.nama,
    required this.tipe,
    required this.an,
    required this.thumbnail,
  });
}

@RoutePage()
class ChannelDaftarPage extends StatefulWidget {
  const ChannelDaftarPage({super.key});

  @override
  State<ChannelDaftarPage> createState() => _ChannelDaftarPageState();
}

class _ChannelDaftarPageState extends State<ChannelDaftarPage> {
  final List<Channel> _dataChannel = const [
    Channel(
      id: 1,
      no: 1,
      nama: 'Transfer via BCA',
      tipe: 'Bank',
      an: 'RT Jawara Karangploso',
      thumbnail: '-',
    ),
    Channel(
      id: 2,
      no: 2,
      nama: 'Copay Ketua RT',
      tipe: 'Exadilet',
      an: 'Budi Santoso',
      thumbnail: '-',
    ),
    Channel(
      id: 3,
      no: 3,
      nama: 'QRIS Resmi RT 08',
      tipe: 'QRIS',
      an: 'RW 08 Karangploso',
      thumbnail: '-',
    ),
  ];

  // Pagination
  int currentPage = 1;
  final int itemsPerPage = 10;

  List<Channel> get paginatedChannels {
    int start = (currentPage - 1) * itemsPerPage;
    int end = (start + itemsPerPage > _dataChannel.length)
        ? _dataChannel.length
        : (start + itemsPerPage);
    return _dataChannel.sublist(start, end);
  }

  void _nextPage() {
    if (currentPage * itemsPerPage < _dataChannel.length) {
      setState(() => currentPage++);
    }
  }

  void _prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
    }
  }

  Widget _buildPagination() {
  int totalPages = (_dataChannel.length / itemsPerPage).ceil();

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Tombol Previous
      IconButton(
        onPressed: _prevPage,
        icon: const Icon(Icons.chevron_left),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.grey, width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      const SizedBox(width: 8),

      // Nomor halaman
      for (int i = 1; i <= totalPages; i++)
        GestureDetector(
          onTap: () {
            setState(() {
              currentPage = i;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: i == currentPage ? Colors.deepPurple : Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              '$i',
              style: TextStyle(
                color: i == currentPage ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

      const SizedBox(width: 8),

      // Tombol Next
      IconButton(
        onPressed: _nextPage,
        icon: const Icon(Icons.chevron_right),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.grey, width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    ],
  );
}

  void _showDeleteDialog(Channel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: Text('Apakah kamu yakin ingin menghapus "${user.nama}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pengguna "${user.nama}" berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Channel channel) {
  return PopupMenuButton<String>(
    icon: const Icon(Icons.more_vert, color: Colors.black54),
    onSelected: (value) {
      if (value == 'detail') {
        context.router.push(DetailChannelRoute(channelId: channel.id));
      } else if (value == 'edit') {
        context.router.push(ChannelEditRoute(channelId: channel.id));
      }
      else if(value == 'delete'){
        _showDeleteDialog(channel);
      }
    },
    itemBuilder: (context) => [
      const PopupMenuItem(
        value: 'detail',
        child: Row(children: [
          Icon(Icons.visibility, size: 18, color: Colors.blue),
          SizedBox(width: 8),
          Text('Detail'),
        ]),
      ),
      const PopupMenuItem(
        value: 'edit',
        child: Row(children: [
          Icon(Icons.edit, size: 18, color: Colors.orange),
          SizedBox(width: 8),
          Text('Edit'),
        ]),
      ),
      const PopupMenuItem(
        value: 'delete',
        child: Row(children: [
          Icon(Icons.delete, size: 18, color: Colors.red),
          SizedBox(width: 8),
          Text('Hapus'),
        ]),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              // === Data Table ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 24,
                    dataRowHeight: 56,
                    headingRowHeight: 45,
                    border: const TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    columns: const [
                      DataColumn(label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('NAMA', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('TIPE', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('A/N', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: paginatedChannels.map(
                      (ch) => DataRow(
                        cells: [
                          DataCell(Text(ch.no.toString())),
                          DataCell(Text(ch.nama)),
                          DataCell(Text(ch.tipe)),
                          DataCell(Text(ch.an)),
                          DataCell(_buildActionButton(ch)),
                        ],
                      ),
                    ).toList(),
                  ),
                ),
              ),

              // === Pagination ===
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _buildPagination(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
