import 'package:firebase_database/firebase_database.dart';

class ShoppingServices {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child(
    'shopping_list',
  );

  void addShoppingItem(String itemName) {
    _database.push().set({'name': itemName});
  }

  Future<void> removeShoppingItem(String key) async {
    await _database.child(key).remove();
  }

  Stream<Map<String, String>> getShoppingList() {
    return _database.onValue.map((event) {
      final Map<String, String> items = {};
      DataSnapshot snapshot = event.snapshot;

      print('Snapshot data : ${snapshot.value}');

      if (snapshot.value != null && snapshot.value is Map<Object?, Object?>) {
        final values = Map<String, dynamic>.from(snapshot.value as Map);

        values.forEach((key, value) {
          if (value is Map && value.containsKey('name')) {
            print('key : $key'); // Print the key
            print('Value : $value'); // Print the value
            items[key] = value['name'] as String;
          }
        });
      }
      return items; // Menambahkan return untuk memastikan Stream memiliki nilai
    });
  }
}
