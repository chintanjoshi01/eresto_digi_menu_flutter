import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LoggerService extends GetxService {
  late Logger _logger;

  Future<LoggerService> init() async {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to display
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        dateTimeFormat: DateTimeFormat.dateAndTime, // Show Time (Like Go)
      ),
    );
    _logger.i("🚀 Logger Service Initialized");
    return this;
  }

  // --- Log Levels ---

  // 1. Debug (For development data)
  void d(String message) {
    _logger.d(message);
  }

  // 2. Info (General app flow, like "Login Started")
  void i(String message) {
    _logger.i(message);
  }

  // 3. Warning (Something weird happened, but app didn't crash)
  void w(String message) {
    _logger.w(message);
  }

  // 4. Error (Critical failures in try/catch)
  void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
