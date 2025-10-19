// lib/utils/date_utils.dart

String formatDate(DateTime date) {
  List<String> months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
  ];
  
  return '${date.day} ${months[date.month]} ${date.year}';
}

String formatDateLong(DateTime date) {
  // Format: 14 Oktober 2025
  List<String> months = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  
  return '${date.day} ${months[date.month]} ${date.year}';
}