import '../entities/units.dart';
import '../repositories/contact_repository.dart';

class GetUnits {
  final ContactRepository repository;

  GetUnits(this.repository);

  Future<List<Unit>> call() {
    return repository.getUnits();
  }
}

