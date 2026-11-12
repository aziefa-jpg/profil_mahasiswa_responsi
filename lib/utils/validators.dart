class Validators {
  static String? validateTittle(String? value) {
    if (value == null || value.trim().isEmpty){
      return 'Judul catatan tidak boleh kosong';
    }
    final sanitized = sanitize(value.trim());
    if (sanitized.length < 3) {
      return 'Judul minimal 3 karakter';
    }
    if (sanitized.length > 50) {
      return 'Judul maksimal 50 karakter';
    }
    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Isi catatan tidak boleh kosong';
    }
    final sanitized = sanitize(value.trim());
    if (sanitized.length < 10) {
      return 'Isi catatn minimal 10 karakter';
    }
    if (sanitized.length > 1000) {
      return 'Isi catatan maksimal 1000 karakter';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || sanitize(value.trim()).isEmpty){
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String sanitize(String input) {
    return input
    .replaceAll('<', '')
    .replaceAll('>', '')
    .replaceAll('"', '')
    .replaceAll("'", '');
  }
}