import 'package:shping_test/main_common.dart';
import 'package:shping_test/utils/environment.dart';

Future<void> main() async {
  await mainCommon(Environment.prod);
}
