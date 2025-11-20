import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/iuran_model.dart';
import 'package:jawara/core/models/channel_models.dart'; 

class MasterRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _iuranMasterCollection = 
      FirebaseFirestore.instance.collection('iuran_master');
  final CollectionReference _channelCollection = 
      FirebaseFirestore.instance.collection('channels');

  // ==========================================================
  // IURAN MASTER (CRUD Penuh)
  // ==========================================================
  Future<void> addIuranMaster(IuranModel iuran) async => await _iuranMasterCollection.add(iuran.toMap());
  
  // R: Get Iuran Master (Stream)
  Stream<List<IuranModel>> getIuranMaster() {
    return _iuranMasterCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IuranModel.fromMap({...data, 'id': doc.id}); 
      }).toList();
    });
  }
  
  Future<void> updateIuranMaster(IuranModel iuran) async => await _iuranMasterCollection.doc(iuran.id.toString()).update(iuran.toMap());
  Future<void> deleteIuranMaster(String iuranId) async => await _iuranMasterCollection.doc(iuranId).delete();


  // ==========================================================
  // CHANNEL (CRUD Penuh)
  // ==========================================================
  Future<void> addChannel(Channel channel) async => await _channelCollection.add(channel.toMap());
  
  // R: Get Channels (Stream)
  Stream<List<Channel>> getChannels() {
    return _channelCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Catatan: Asumsi Model Channel memiliki fromMap/toMap
        return Channel.fromMap({...data, 'id': doc.id}); 
      }).toList();
    });
  }
  
  Future<void> updateChannel(Channel channel) async => await _channelCollection.doc(channel.id.toString()).update(channel.toMap());
  Future<void> deleteChannel(String channelId) async => await _channelCollection.doc(channelId).delete();
}