// Lokasi: lib/core/services/data_migrator.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// --- IMPORT SEMUA MODEL DUMMY ANDA (SESUAIKAN PATH!) ---
// Asumsi path: lib/core/models/...
import 'package:jawara/core/models/pengguna_models.dart';
import 'package:jawara/core/models/family_models.dart'; 
import 'package:jawara/core/models/tagihan_model.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';
import 'package:jawara/core/models/iuran_models.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/core/models/channel_models.dart';
import 'package:jawara/core/models/activity_models.dart'; 
import 'package:jawara/core/models/mutasi_model.dart';


final FirebaseFirestore _db = FirebaseFirestore.instance;

// Fungsi utama yang menjalankan semua migrasi
Future<void> migrateDummyDataToFirestore() async {
  print("--- STARTING DATA MIGRATION TO FIRESTORE ---");
  
  // Catatan: Pastikan Anda sudah login saat menjalankan skrip ini!

  try {
    // 1. MIGRASI USERS (Master Data)
    // // Menggunakan NIK sebagai Document ID (ID Dokumen)
    // final usersCollection = _db.collection('users');
    // print('Migrating users...');
    // for (var user in daftarPengguna) {
    //   await usersCollection.doc(user.nik).set(user.toMap()); 
    // }
    // print('✅ Users migration complete.');

    // // 2. MIGRASI FAMILY
    // // Menggunakan NIK sebagai Document ID (ID Dokumen)
    // final familyCollection = _db.collection('families');
    // print('Migrating families...');
    // for (var family in FamilyModel.dummyFamilies) {
    //   await familyCollection.doc(family.noKk).set(family.toMap()); 
    // }
    // print('✅ Families migration complete.');

    // // 3. MIGRASI IURAN MASTER (Master Konfigurasi)
    // final iuranMasterCollection = _db.collection('iuran');
    // print('Migrating iuran master...');
    // for (var iuran in dummyIuran) {
    //   await iuranMasterCollection.doc(iuran.docId).set(iuran.toMap());
    // }
    // print('✅ Iuran master migration complete.');
    
    // // 4. MIGRASI CHANNEL (Master Konfigurasi)
    // final channelCollection = _db.collection('channels');
    // print('Migrating channels...');
    // for (var channel in dummyChannels) {
    //   await channelCollection.doc(channel.docId).set(channel.toMap());
    // }
    // print('✅ Channels migration complete.');

    // // 5. MIGRASI TAGIHAN
    // final tagihanCollection = _db.collection('tagihan');
    // print('Migrating tagihan...');
    // for (var tagihan in dummyTagihan) {
    //   await tagihanCollection.doc(tagihan.docId).set(tagihan.toMap());
    // }
    // print('✅ Tagihan migration complete.');

    // // 6. MIGRASI PEMASUKAN
    // final pemasukanCollection = _db.collection('pemasukan');
    // print('Migrating pemasukan...');
    // for (var pemasukan in dummyPemasukan) {
    //   await pemasukanCollection.doc(pemasukan.docId).set(pemasukan.toMap());
    // }
    // print('✅ Pemasukan migration complete.');

    // // 7. MIGRASI PENGELUARAN
    // final pengeluaranCollection = _db.collection('pengeluaran');
    // print('Migrating pengeluaran...');
    // for (var pengeluaran in dummyPengeluaran) {
    //   await pengeluaranCollection.doc(pengeluaran.docId).set(pengeluaran.toMap());
    // }
    // print('✅ Pengeluaran migration complete.');

    // // 8. MIGRASI BROADCAST
    // final broadcastCollection = _db.collection('broadcasts');
    // print('Migrating broadcasts...');
    // for (var broadcast in dummyBroadcast) {
    //   await broadcastCollection.doc(broadcast.docId).set(broadcast.toMap());
    // }
    // print('✅ Broadcasts migration complete.');
    
    // // 9. MIGRASI KEGIATAN
    // final kegiatanCollection = _db.collection('kegiatan');
    // print('Migrating kegiatan...');
    // for (var kegiatan in dummyKegiatan) {
    //   await kegiatanCollection.doc(kegiatan.docId).set(kegiatan.toMap());
    // }
    // print('✅ Kegiatan migration complete.');

    // // 10. MIGRASI ACTIVITIES (LOG)
    // final activityCollection = _db.collection('activities');
    // print('Migrating activities...');
    // for (var activity in daftarAktivitas) {
    //   await activityCollection.doc(activity.docId).set(activity.toMap());
    // }
    // print('✅ Activities migration complete.');

  final mutasiActivity = _db.collection('mutasi');
    print('Migrating mutasi...');
    for (var mutasi in MutasiDataProvider.dummyDataMutasi) {
      await mutasiActivity.doc(mutasi.docId).set(mutasi.toMap());
    }
    print('✅ Activities migration complete.');


    print("--- ALL DATA MIGRATION SUCCESSFUL! ---");

  } catch (e) {
    print("!!! DATA MIGRATION FAILED: $e");
    print("Pastikan Anda sudah login dan Security Rules mengizinkan write!");
  }
}