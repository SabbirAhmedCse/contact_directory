import '../../../police_contacts/domain/entities/contact.dart';

class ScoredContact {
  final Contact contact;
  final int score;
ScoredContact(this.contact, this.score);
}

bool isFuzzyMatch(String source, String query) {
  if (source.isEmpty || query.isEmpty) return false;
  return source.contains(
    query.substring(0, query.length > 3 ? 3 : query.length),
  );
}

String extractValidBdNumbers(String? input) {
  if (input == null || input.isEmpty) return '';

  String cleaned = input.replaceAll(RegExp(r'[^0-9,]'), '');

  List<String> parts = cleaned.split(',');

  List<String> validNumbers = [];

  for (String number in parts) {
    number = number.trim();

    // If number is 10 digits and missing leading 0
    if (number.length == 10 && number.startsWith('1')) {
      number = '0$number';
    }

    // Check valid BD number
    if (number.length == 11 && number.startsWith('01')) {
      validNumbers.add(number);
    }
  }

  return validNumbers.join(', ');
}
