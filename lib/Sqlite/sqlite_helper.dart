import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EmployeeDatabaseHelper {
  Database? _database;
  static EmployeeDatabaseHelper? _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static EmployeeDatabaseHelper get instance {
    _instance ??= EmployeeDatabaseHelper();
    return _instance!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'pioneer.db');
    return await openDatabase(path, version: 7, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS employee (
        id INTEGER PRIMARY KEY,
        corporate_id TEXT
      )
    ''');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS employeeProfileData (
            empCode TEXT PRIMARY KEY,
            profilePic TEXT,
            empName TEXT,
            emailAddress TEXT
          )
    ''');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS employeeAttendanceData (
        empCode TEXT PRIMARY KEY,
        location TEXT,
        lat TEXT,
        long TEXT,
        dateTime TEXT
      )
    ''');
      print("Tables created successfully");
    } catch (e) {
      print('Error creating database tables: $e');
    }
  }

  Future<void> insertEmployee(int id, String corporateId) async {
    final db = await database;
    await db.insert('employee', {'id': id, 'corporate_id': corporateId});
    print("data inserted in employee table");
  }

  Future<void> printProfileData() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> result = await db.query('employeeProfileData');
      print('Employee Profile Data:');
      result.forEach((row) {
        print(
            'EmpCode: ${row['empCode']}, EmpName: ${row['empName']}, EmailAddress: ${row['emailAddress']}');
      });
    } catch (e) {
      print("Error printing profile data: $e");
    }
  }

  Future<Map<String, dynamic>> getProfileDataById() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'employeeProfileData',
      columns: ['empCode', 'profilePic', 'empName', 'emailAddress'],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future<void> insertProfileData(String empCode, String profilePic,
      String empName, String emailAddress) async {
    final db = await database;
    await db.insert(
      'employeeProfileData',
      {
        'empCode': empCode,
        'profilePic': profilePic,
        'empName': empName,
        'emailAddress': emailAddress,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Data inserted in profile table");
  }

  Future<void> deleteProfileData() async {
    try {
      final db = await database;
      await db.delete('employeeProfileData');
      print('All data deleted from profile table');
    } catch (e) {
      print('Error deleting profile data: $e');
    }
  }

  Future<Map<String, dynamic>> getEmployeeProfileData() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('employeeProfileData');

    if (result.isNotEmpty) {
      return {
        'empCode':
            result.first['empCode'] as String, // Treat empCode as a string
        'profilePic': result.first['profilePic'] as String,
        'empName': result.first['empName'] as String,
        'emailAddress': result.first['emailAddress'] as String,
      };
    } else {
      // or any other default values
      return {
        'empCode': '',
        'profilePic': '',
        'empName': '',
        'emailAddress': '',
      };
    }
  }

  Future<void> deleteAllEmployeeData() async {
    final db = await database;
    await db.delete('employee'); // Change to delete from 'employee' table
    print("All data deleted from employee table");
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await database;
    return await db.query('employee');
  }

  Future<int> getLoggedInEmployeeId() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('employee');
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return 0; // or any other default value
    }
  }

  Future<Map<String, dynamic>?> getFirstEmployee() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('employee', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<String?> getCoorporateId() async {
    final firstEmployee = await getFirstEmployee();
    return firstEmployee != null
        ? firstEmployee['corporate_id'] as String
        : null;
  }

  Future<void> insertAttendanceData(
      String empCode, String lat, String long, String location, DateTime dateTime) async {

    final db = await database;
    await db.insert(
      'employeeAttendanceData',
      {'empCode': empCode, 'location': location, 'long': long, 'lat': lat , 'dateTime': dateTime},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Data inserted in employeeAttendanceData table");
  }

  Future<Map<String, dynamic>> getAttendanceData() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'employeeAttendanceData',
      columns: ['empCode', 'location', 'long', 'lat', 'dateTime'],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future<void> deleteAttendenceData() async {
    try {
      final db = await database;
      await db.delete('employeeAttendanceData');
      print('All data deleted from EmpAttend table');
    } catch (e) {
      print('Error deleting profile data: $e');
    }
  }

  Future<void> printAttendData() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> result =
          await db.query('employeeAttendanceData');
      print('Employee Profile Data:');

      result.forEach((row) {
        print(
            'empCode: ${row['empCode']}, lat: ${row['lat']}, long: ${row['long']} , location: ${row['location']}, dateTime: ${row['dateTime']} ');
      });
    } catch (e) {
      print("Error printing Attendance data: $e");
    }
  }
}
