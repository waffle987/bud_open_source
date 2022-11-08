/// Logic to calculate the count from a Map that is retrieved from Firestore

int getCount({required Map? map}) {
  /// If no likes, return 0

  if (map == null) {
    return 0;
  }
  int count = 0;

  /// If the key is explicitly set to true, add a like

  for (var val in map.values) {
    if (val == true) {
      count += 1;
    }
  }
  return count;
}
