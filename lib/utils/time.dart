String formattedPostedAgo (DateTime time){
  Duration t = time.difference(DateTime.now()).abs();

  if (t.inDays >= 365){
    return '${(t.inDays / 365).round()}y';
  } else if (t.inDays >= 30) {
    return '${(t.inDays / 365).round()}m';
  }else if (t.inDays >= 1){
    return '${(t.inDays)}d';
  }else if (t.inHours >= 1){
    return '${t.inHours}h';
  }else{
    return '${t.inMinutes}m';
  }
}