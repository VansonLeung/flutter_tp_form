
import 'package:logger/logger.dart';

class GLog {

  static final Logger _instance = Logger();

  static Logger getInstance() {
    return _instance;
  }

}