const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function deleteAllUsers(nextPageToken) {
  // 1. Ambil list user (maksimal 1000 per batch)
  const listUsersResult = await admin.auth().listUsers(1000, nextPageToken);

  const uids = listUsersResult.users.map((userRecord) => userRecord.uid);

  if (uids.length === 0) {
    console.log('Tidak ada user untuk dihapus.');
    return;
  }

  console.log(`Menghapus ${uids.length} user...`);

  // 2. Hapus user berdasarkan UID
  const deleteResult = await admin.auth().deleteUsers(uids);

  console.log(`Berhasil menghapus ${deleteResult.successCount} user.`);
  console.log(`Gagal menghapus ${deleteResult.failureCount} user.`);

  // 3. Jika masih ada sisa user, ulangi lagi (rekursif)
  if (listUsersResult.pageToken) {
    await deleteAllUsers(listUsersResult.pageToken);
  } else {
    console.log('SEMUA USER BERHASIL DIRESET!');
    process.exit();
  }
}

// Jalankan fungsi
deleteAllUsers()
  .catch((error) => {
    console.log('Error:', error);
    process.exit(1);
  });