import 'package:rxdart/rxdart.dart';
import 'package:jawara/core/models/finance_models.dart';
import 'package:jawara/core/repositories/dashboard_keuangan_repository.dart';

class DashboardKeuanganService {
  final DashboardKeuanganRepository repo = DashboardKeuanganRepository();

  Stream<FinanceData> getDashboardData(int tahun, {int? bulan}) {
    // jika bulan == null → kembalikan data tahunan (12 bulan)
    if (bulan == null) {
      final totalIncome = repo.getTotalPemasukan();
      final totalExpense = repo.getTotalPengeluaran();
      final transactionCount = repo.getJumlahTransaksi();

      final monthlyIncome = List.generate(12, (i) => repo.pemasukanPerBulan(i + 1, tahun));
      final monthlyExpense = List.generate(12, (i) => repo.pengeluaranPerBulan(i + 1, tahun));

      // gabungkan semua stream
      return CombineLatestStream.list([
        totalIncome,
        totalExpense,
        transactionCount,
        ...monthlyIncome,
        ...monthlyExpense,
      ]).map((values) {
        final double totalP = (values[0] as num).toDouble();
        final double totalK = (values[1] as num).toDouble();
        final int trx = (values[2] as num).toInt();

        final months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];

        final List<MonthlyData> incomeList = List.generate(
          12,
          (i) => MonthlyData(
            month: months[i],
            amount: (values[3 + i] as num).toDouble(),
          ),
        );

        final List<MonthlyData> expenseList = List.generate(
          12,
          (i) => MonthlyData(
            month: months[i],
            amount: (values[15 + i] as num).toDouble(),
          ),
        );

        return FinanceData(
          totalIncome: totalP,
          totalExpense: totalK,
          transactionCount: trx,
          monthlyIncome: incomeList,
          monthlyExpense: expenseList,
          incomeByCategory: [],     // kosong dulu
          expenseByCategory: [],    // kosong dulu
        );
      });
    }

    // Jika bulan dipilih → ambil data hanya untuk bulan itu
    final pemasukanBulan = repo.pemasukanPerBulan(bulan, tahun);
    final pengeluaranBulan = repo.pengeluaranPerBulan(bulan, tahun);
    final transaksiBulan = repo.getJumlahTransaksiPerBulan(bulan, tahun);

    return CombineLatestStream.list([pemasukanBulan, pengeluaranBulan, transaksiBulan]).map((vals) {
      final double income = (vals[0] as num).toDouble();
      final double expense = (vals[1] as num).toDouble();
      final int trx = (vals[2] as num).toInt();

      final months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];

      final List<MonthlyData> incomeList = List.generate(12, (i) => MonthlyData(month: months[i], amount: i == (bulan - 1) ? income : 0.0));
      final List<MonthlyData> expenseList = List.generate(12, (i) => MonthlyData(month: months[i], amount: i == (bulan - 1) ? expense : 0.0));

      return FinanceData(
        totalIncome: income,
        totalExpense: expense,
        transactionCount: trx,
        monthlyIncome: incomeList,
        monthlyExpense: expenseList,
        incomeByCategory: [],
        expenseByCategory: [],
      );
    });
  }
}
