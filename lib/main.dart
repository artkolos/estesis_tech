import 'dart:async';

import 'package:estesis_tech/injection.dart';
import 'package:estesis_tech/presentation/app/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await configureDependencies();
      runApp(
        const Application(),
      );
    },
    (err, st) {
      Logger().e('Error $err;\n$st');
    },
  );
}
