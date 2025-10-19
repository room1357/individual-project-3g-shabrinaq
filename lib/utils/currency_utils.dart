// lib/utils/currency_utils.dart

String formatCurrency(double amount) {
  // Format ke Rupiah dengan pemisah ribuan
  String formatted = amount.toStringAsFixed(0);
  
  // Tambahkan pemisah ribuan (titik)
  formatted = formatted.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );
  
  return 'Rp $formatted';
}