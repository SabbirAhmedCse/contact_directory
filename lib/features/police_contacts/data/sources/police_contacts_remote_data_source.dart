import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/contact.dart';
import '../../domain/entities/units.dart';
import '../../domain/repositories/police_contacts_repository.dart';

class PoliceContactsRemoteDataSource implements PoliceContactsRepository {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('police_contacts');

  PoliceContactsRemoteDataSource();

  @override
  Future<List<Contact>> getContacts() async {
    final DataSnapshot snapshot = await ref.get();
    final List<Contact> contacts = <Contact>[];

    final Object? value = snapshot.value;
    if (value is Map<Object?, Object?>) {
      value.forEach((Object? key, Object? raw) {
        if (raw is Map<Object?, Object?>) {
          final data = Map<String, dynamic>.from(raw as Map);
          contacts.add(
            Contact(
              id: data['id']?.toInt() ?? 0,
              unit: data['unit']?.toString() ?? '',
              subUnit: data['subUnit']?.toString() ?? '',
              subSubUnit: data['subSubUnit']?.toString() ?? '',
              designation: data['designation']?.toString() ?? '',
              mobileNumber: data['mobileNumber']?.toString() ?? '',
              email: data['email']?.toString() ?? '',
              phone: data['phone']?.toString() ?? '',
              isActive: data['isActive'] == true,
              isDeleted: data['isDeleted'] == true,
              createdOn: data['createdOn'] != null ? DateTime.parse(data['createdOn']) : DateTime.now(),
              createdBy: data['createdBy']?.toString() ?? '',
              updatedOn: data['updatedOn'] != null ? DateTime.parse(data['updatedOn']) : DateTime.now(),
              updatedBy: data['updatedBy']?.toString() ?? '',
              deletedOn: data['deletedOn'] != null ? DateTime.parse(data['deletedOn']) : DateTime(0),
              deletedBy: data['deletedBy']?.toString() ?? '',
              isFavorite: data['isFavorite'] == true,
            ),
          );
        }
      });
    }

    return contacts;
  }

  @override
  Future<void> addContact(Contact contact) async {
    await ref.child(contact.id.toString()).set(<String, dynamic>{
      'id': contact.id,
      'unit': contact.unit,
      'subUnit': contact.subUnit,
      'subSubUnit': contact.subSubUnit,
      'designation': contact.designation,
      'mobileNumber': contact.mobileNumber,
      'email': contact.email,
      'phone': contact.phone,
      'isActive': contact.isActive,
      'isDeleted': contact.isDeleted,
      'createdOn': contact.createdOn.toIso8601String(),
      'createdBy': contact.createdBy,
      'updatedOn': contact.updatedOn.toIso8601String(),
      'updatedBy': contact.updatedBy,
    });
  }

  @override
  Future<List<Unit>> getUnits() {
    // TODO: implement getUnits
    throw UnimplementedError();
  }
}

