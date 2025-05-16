import 'package:bundle_app/src/data/database_repository.dart';
import 'package:bundle_app/src/data/mock_database_repository.dart';
import 'package:bundle_app/src/main_app.dart';
import 'package:flutter/material.dart';

void main() {
  final DatabaseRepository db = MockDatabaseRepository();
  runApp(MainApp(db));
}
