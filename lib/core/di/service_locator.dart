// core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'service_locator.config.dart'; // الملف ده هيتولد ويحل المشكلة فوراً بعد الـ Build



final GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> setupServiceLocator() async {
  // 🌟 استدعاء الـ Extension بالشكل الصحيح والنظيف لـ injectable
  await sl.init();


}
