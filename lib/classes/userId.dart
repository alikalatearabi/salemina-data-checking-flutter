class GlobalState {
  GlobalState._internal();

  static final GlobalState _instance = GlobalState._internal();

  factory GlobalState() {
    return _instance;
  }

  String _userId = '';

  String get userId => _userId;

  void setUserId(String id) {
    _userId = id;
  }
}
