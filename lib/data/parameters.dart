import 'package:hive/hive.dart';
import 'package:selector/data/hive_ids.dart';
import 'package:selector/data/enums.dart';

@HiveType(typeId: hiveParametersId)
class Parameters extends HiveObject {
  static const boxName = 'selector-parameters';

  @HiveField(0)
  GridViewType gridViewType = GridViewType.normal;

  Parameters() {
    // Get the box
    Hive.openBox(boxName).then((box) {
      // Get the parameters
      var parameters = box.get(0) as Parameters?;
      if (parameters != null) {
        gridViewType = parameters.gridViewType;
      }
    });
  }
}
