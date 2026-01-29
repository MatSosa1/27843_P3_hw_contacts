import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hw_contacts/domain/entities/contact.dart';
import 'package:hw_contacts/domain/repositories/contact_repository.dart';
import 'package:hw_contacts/application/usecases/add_contact_usecase.dart';

// 1. Mock del Repositorio
class MockContactRepository extends Mock implements ContactRepository {}

void main() {
  setUpAll(() {
    // Necesario para que Mocktail acepte la clase Contact en los argumentos
    registerFallbackValue(Contact(id: 0, name: '', phone: '', email: ''));
  });

  group('Contact Entity Test', () {
    test('Debe crear una instancia válida de Contact', () {
      final contact = Contact(
        id: 1,
        name: 'Juan',
        phone: '123456',
        email: 'juan@test.com',
      );

      expect(contact.id, 1);
      expect(contact.name, 'Juan');
      expect(contact.isFavorite, false); // Valor por defecto
    });
  });

  group('AddContactUsecase Test', () {
    late MockContactRepository mockRepo;
    late AddContactUsecase useCase;

    setUp(() {
      mockRepo = MockContactRepository();
      useCase = AddContactUsecase(mockRepo);
    });

    test('Debe llamar a addContact del repositorio', () async {
      // Arrange
      final contact = Contact(id: 0, name: 'Test', phone: '111', email: 'a@a.com');
      when(() => mockRepo.addContact(any())).thenAnswer((_) async {});

      // Act
      await useCase.call(contact);

      // Assert
      verify(() => mockRepo.addContact(contact)).called(1);
    });
  });
}