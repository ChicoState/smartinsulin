class UserLogService {
  static final List<Map<String, dynamic>> glucoseData = [];
  static final List<Map<String, dynamic>> insulinData = [];
  static final List<Map<String, dynamic>> notesData = [];
  static final List<Map<String, dynamic>> mealData = [];

  static void clearAll() {
    glucoseData.clear();
    insulinData.clear();
    notesData.clear();
    mealData.clear();
  }
}
