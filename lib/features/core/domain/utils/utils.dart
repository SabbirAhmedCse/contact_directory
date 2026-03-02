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
