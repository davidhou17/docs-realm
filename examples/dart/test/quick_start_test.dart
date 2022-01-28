import 'package:test/test.dart';
import '../bin/models/car.dart';
import 'package:realm_dart/realm.dart';

void main() {
  group('CRUD Operations', () {
    test('Create Realm Object', () {
      var config = Configuration([Car.schema]);
      Realm realm = Realm(config);
      Car? addedCar;
      // :snippet-start: create-realm-object
      final car = Car('Tesla', 'Model S', miles: 42);
      realm.write(() {
        addedCar = realm.add(car); // :remove:
        // :uncomment-start:
        //realm.add(car);
        // :uncomment-end:
      });
      // :snippet-end:
      expect(addedCar == car, true);
      realm.write(() {
        realm.delete(car); // clean up
      });
    });

    test('Query All Realm Objects', () {
      var config = Configuration([Car.schema]);
      Realm realm = Realm(config);

      realm.write(() {
        realm.add(Car('Tesla', 'Model Y', miles: 42));
      });
      // :snippet-start: query-all-realm-objects
      var cars = realm.all<Car>();
      var myCar = cars[0];
      print('My car is ${myCar.make} ${myCar.model}');
      // :snippet-end:
      expect(myCar.miles, 42);
      expect(myCar.make, 'Tesla');
      expect(myCar.model, 'Model Y');
      realm.write(() {
        realm.deleteMany(cars); // clean up
      }); // clean up
    });
    test('Query Realm Objects with Filter', () {
      var config = Configuration([Car.schema]);
      Realm realm = Realm(config);
      realm.write(() {
        realm.add(Car('Tesla', 'Model Y', miles: 42));
        realm.add(Car('Toyota', 'Prius', miles: 99));
      });
      // :snippet-start: query-realm-objects-with-filter
      var cars = realm.all<Car>().query('make == "Tesla"');
      // :snippet-end:
      expect(cars.length, 1);
      expect(cars[0].make, 'Tesla');
      realm.write(() {
        realm.deleteMany(realm.all<Car>());
      }); // clean up
    });

    test('Query Realm Objects with Sort', () {
      var config = Configuration([Car.schema]);
      Realm realm = Realm(config);
      // :snippet-start: query-realm-objects-with-sort
      realm.write(() {
        realm.add(Car('BMW', 'Z4', miles: 42));
        realm.add(Car('Audi', 'A8', miles: 99));
        realm.add(Car('Mercedes', 'G-Wagon', miles: 2));
      });
      final sortedCars = realm.query<Car>('TRUEPREDICATE SORT(model ASC)');
      for (var car in sortedCars) {
        print(car.model);
      }
      // prints 'A8', 'G-Wagon', 'Z4'
      // :snippet-end:

      final resultNames = sortedCars.map((p) => p.model).toList();
      final sortedNames = [...resultNames]..sort();
      expect(resultNames, sortedNames);
      realm.write(() {
        realm.deleteMany(sortedCars);
      });
    });

    test('Update Realm Object', () {
      var config = Configuration([Car.schema]);
      Realm realm = Realm(config);

      final car = Car('Tesla', 'Model Y', miles: 42);
      realm.write(() {
        realm.add(car);
      });
      // :snippet-start: update-realm-object
      realm.write(() {
        car.miles = 99;
      });
      // :snippet-end:
      expect(car.miles, 99);
      expect(car.make, 'Tesla');
      expect(car.model, 'Model Y');
      realm.write(() {
        realm.delete(car); // clean up
      });
    });

    test('Delete One Realm Object', () {
      var config = Configuration([Car.schema]);
      Realm realm = Realm(config);

      final car = Car('Tesla', 'Model Y', miles: 42);
      realm.write(() {
        realm.add(car);
      });
      // :snippet-start: delete-one-realm-object
      realm.write(() {
        realm.delete(car);
      });
      // :snippet-end:
      var cars = realm.all<Car>();
      expect(cars.length, 0);
    });
    test('Delete Many Realm Objects', () {
      var config = Configuration([Car.schema]);
      Realm realm = Realm(config);

      realm.write(() {
        realm.add(Car('Tesla', 'Model Y', miles: 42));
        realm.add(Car('Toyota', 'Prius', miles: 99));
      });
      var cars = realm.all<Car>();
      // :snippet-start: delete-many-realm-objects
      realm.write(() {
        realm.deleteMany(cars);
      });
      // :snippet-end:
      expect(cars.length, 0);
    });
  });

  // group('Listen for Changes', () {
  //   var config = Configuration([Car.schema]);
  //   var realm = Realm(config);
  //   test('Listen to Entire Realm', () {
  //     // :snippet-start: listen-to-entire-realm
  //     // TODO(DOCSP-20543): add code example. sdk not yet ready as of 1/19 (i think)
  //     // :snippet-end:
  //   });
  //   test('Listen to Collection of Realm Objects', () {
  //     // :snippet-start: listen-to-collection-realm-objects
  //     // TODO(DOCSP-20543): add code example. sdk not yet ready as of 1/19 (i think)
  //     // :snippet-end:
  //   });
  //   test('Listen to Singe Realm Object', () {
  //     // :snippet-start: listen-to-single-realm-object
  //     // TODO(DOCSP-20543): add code example. sdk not yet ready as of 1/19 (i think)
  //     // :snippet-end:
  //   });
  //   // realm.close();
  //   // Realm.deleteRealm(config.path);
  // });
}