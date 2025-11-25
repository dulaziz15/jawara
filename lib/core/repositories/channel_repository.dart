import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/channel_models.dart';

class ChannelRepository {
  final CollectionReference _channelCollection = FirebaseFirestore.instance
      .collection('channels');

  // ==========================================================
  // CHANNEL (CRUD Penuh)
  // ==========================================================
  Future<void> addChannel(Channel channel) async =>
      await _channelCollection.add(channel.toMap());

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

  Future<void> updateChannel(Channel channel) async => await _channelCollection
      .doc(channel.id.toString())
      .update(channel.toMap());
  Future<void> deleteChannel(String channelId) async =>
      await _channelCollection.doc(channelId).delete();
}
