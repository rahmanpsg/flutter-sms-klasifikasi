class Preprocessing {
  String removeUrl(String text) {
    return text.replaceAll(new RegExp(r"https?://\S+|www\.\S+"), '');
  }

  String removePunc(String text) {
    return text.replaceAll(new RegExp(r'[^\w\s]+'), '');
  }

  String caseFolding(String text) {
    return text.toLowerCase();
  }
}
