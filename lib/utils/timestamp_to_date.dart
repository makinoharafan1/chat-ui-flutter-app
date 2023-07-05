import 'package:intl/intl.dart';

String timestampToDate(DateTime lastMessageDate, DateTime currentDate) {
  late String date;
  
  if (lastMessageDate.year == currentDate.year &&
                lastMessageDate.month == currentDate.month &&
                lastMessageDate.day == currentDate.day) {
              final timeFormat = DateFormat.Hm();
              date = timeFormat.format(lastMessageDate);
  }
  else if (currentDate.difference(lastMessageDate).inDays < 7) {
    final dayFormat = DateFormat.EEEE("ru");
    date = dayFormat.format(lastMessageDate);  
  }
  else {
    final dayFormat = DateFormat.MMMd("ru");
    date = dayFormat.format(lastMessageDate); 
  }
  
  return date;
}
