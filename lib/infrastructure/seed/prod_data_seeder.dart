import 'package:injectable/injectable.dart';
import 'package:tracker/core/seed/data_seeder.dart';

@Environment('prod')
@LazySingleton(as: IDataSeeder)
class ProdDataSeeder implements IDataSeeder {
  @override
  Future<void> seed() async {}
}
