import '../../domain/entities/contact.dart';

extension ContactPrimaryPhone on Contact {
  String get primaryPhone {
    if (mobileNumber != null && mobileNumber!.isNotEmpty) {
      return mobileNumber!;
    }
    return phone ?? '';
  }
}
