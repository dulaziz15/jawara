import 'package:jawara/core/models/finance_models.dart';

class DashboardKeuanganModel {
  final double totalPendapatan;
  final double totalPengeluaran;
  final int jumlahTransaksi;
  final List<MonthlyData> pendapatanPerBulan;
  final List<MonthlyData> pengeluaranPerBulan;
  final double saldoAkhir;

  DashboardKeuanganModel({
    required this.totalPendapatan,
    required this.totalPengeluaran,
    required this.jumlahTransaksi,
    required this.pendapatanPerBulan,
    required this.pengeluaranPerBulan,
    required this.saldoAkhir,
  });
}
