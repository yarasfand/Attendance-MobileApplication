import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/constants/AppColor_constants.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import '../../../constants/constants.dart';
import 'empConstants.dart';
import 'mobile.dart';

class EmpAbsentReports extends StatefulWidget {
  const EmpAbsentReports({super.key});

  @override
  State<EmpAbsentReports> createState() => _EmpAbsentReportsState();
}

class _EmpAbsentReportsState extends State<EmpAbsentReports> {
  final TextEditingController _searchController = TextEditingController();
  var screenSize;

  List<Map<String, dynamic>> dummyData = List.generate(
    30,
    (index) => {
      'Name': 'Name $index',
      'Card No': 'Card $index',
      'Status': index % 2 == 0 ? 'Present' : 'Absent',
      'Working Hours': '${index + 1} hours',
    },
  );

  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData.addAll(dummyData);
  }

  // For pdf
  Future<void> _createPdf(List<Map<String, dynamic>> data) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfFont headingFont = PdfStandardFont(PdfFontFamily.helvetica, 15);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    void addLineSeparator(double yPosition) {
      page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1),
        Offset(50, yPosition),
        Offset(550, yPosition),
      );
    }

    void addText(String text, double yPosition, PdfFont font) {
      page.graphics.drawString(
        text,
        font,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(50, yPosition, 500, 20),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    }

    // Calculate the position for the table and heading
    double companyNameY = 30;
    double currentDateY = companyNameY + 30;
    double reportDateY = currentDateY + 20;
    double reportTitleY = reportDateY + 20;
    double tableY = reportTitleY + 20;
    double logoY = page.getClientSize().height - 150.0; // Adjust as needed

    // Add Company Name to the page
    addText(
      "Pioneer Time System",
      companyNameY,
      headingFont,
    );

    // Add Current Date to the page
    DateTime currentDate = DateTime.now();
    String formattedCurrentDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    addText(
      formattedCurrentDate,
      currentDateY,
      normalFont,
    );

    // Add Report Date to the page
    String reportStartDate = "25 Aug 2023";
    String reportEndDate = "25 Aug 2023";
    addText(
      "$reportStartDate - $reportEndDate",
      reportDateY,
      normalFont,
    );

    // Add Report Title and Total Records to the page
    String reportTitle = "Report Title";
    int totalRecords = data.length;
    addText(
      "$reportTitle - $totalRecords Records",
      reportTitleY,
      normalFont,
    );

    // Create the table with 4 columns
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);

    // Add headers to the table
    final List<PdfGridRow> headers = grid.headers.add(1);
    final PdfGridRow header = headers[0];
    header.cells[0].value = "Name";
    header.cells[1].value = "Card No.";
    header.cells[2].value = "Status";
    header.cells[3].value = "Working Hours";

    // Center align and make headers bold
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style.stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.left,
        );
        row.cells[j].style.font = PdfStandardFont(
          PdfFontFamily.helvetica,
          20,
          style: PdfFontStyle.bold,
        );
      }
    }

    // Center align data in all cells and increase the size
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style.stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.left,
        );
        row.cells[j].style.font = PdfStandardFont(PdfFontFamily.helvetica, 18);
      }
    }

    // Add data from the list to the table
    for (final item in data) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = item['Name'];
      row.cells[1].value = item['Card No'];
      row.cells[2].value = item['Status'];
      row.cells[3].value = item['Working Hours'];
    }

    // Draw the table on the PDF page
    grid.draw(page: page, bounds: Rect.fromLTWH(50, tableY, 500, 0));

    // Add line separator at the bottom
    final double bottomPosition = page.getClientSize().height - 50.0;
    addLineSeparator(bottomPosition);

    // Add contact details and email below the line
    final double contactDetailsY = bottomPosition + 10.0;
    final double emailY = contactDetailsY + 20.0;
    addText("Contact Details: 123456789", contactDetailsY, normalFont);
    addText("Email: company@example.com", emailY, normalFont);

    // Add image logo from assets
    final ByteData byteData =
        await rootBundle.load('assets/images/pioneer_logo_app.png');
    final Uint8List imageBytes = byteData.buffer.asUint8List();
    final PdfImage logoImage = PdfBitmap(imageBytes);
    page.graphics.drawImage(
      logoImage,
      Rect.fromLTWH(
          50, logoY + 100, 100, 50), // Adjust position and size as needed
    );

    // Save and launch the PDF
    final List<int> bytes = await document.save();
    document.dispose();
    empSaveAndLaunchFile(bytes, "absent_reports.pdf");
  }

  // For excel
  Future<void> _createExcel(List<Map<String, dynamic>> data) async {
    // Create a new Excel workbook
    final xls.Workbook workbook = xls.Workbook();

    // Add a worksheet to the workbook
    final xls.Worksheet worksheet = workbook.worksheets[0];

    // Define column headers
    worksheet.getRangeByIndex(1, 1).setText("Name");
    worksheet.getRangeByIndex(1, 2).setText("Card No");
    worksheet.getRangeByIndex(1, 3).setText("Status");
    worksheet.getRangeByIndex(1, 4).setText("Working Hours");

    // Populate data from the list
    for (int i = 0; i < data.length; i++) {
      final row = worksheet.getRangeByIndex(i + 2, 1);
      row.setText(data[i]['Name']);
      worksheet.getRangeByIndex(i + 2, 2).setText(data[i]['Card No']);
      worksheet.getRangeByIndex(i + 2, 3).setText(data[i]['Status']);
      worksheet.getRangeByIndex(i + 2, 4).setText(data[i]['Working Hours']);
    }

    // Save the workbook as a stream of bytes
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Get the application's documents directory
    final String path = (await getApplicationSupportDirectory()).path;

    // Define the file name and path
    final String fileName = '$path/absent_reports.xlsx';

    // Write the bytes to a file
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);

    // Open the file using the OpenFile package
    try {
      OpenFile.open(fileName);
    } catch (e) {
      print("Error opening file: $e");
    }
  }

  void filterData(String query) {
    setState(() {
      filteredData = dummyData.where((data) {
        final lowerQuery = query.toLowerCase();
        return data['Name'].toLowerCase().contains(lowerQuery) ||
            data['Card No'].toLowerCase().contains(lowerQuery) ||
            data['Status'].toLowerCase().contains(lowerQuery) ||
            data['Working Hours'].toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> _generatePdfFromData() async {
    await _createPdf(dummyData);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: kIconThemeData,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Absent Report',
          style: EmpkAppBarTextTheme,
        ),
        centerTitle: true,

      ),
      body: ListView(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.02),
                  child: const Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      filterData(query);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          // Divider
          const Divider(),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          // DataTable
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: DataTable(
              dividerThickness: 1.0,
              columnSpacing: screenSize.width * 0.02,
              headingRowColor:
                  MaterialStateProperty.all<Color>(AppColors.primaryColor),
              columns: const [
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '   Card No',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '     Status',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Working Hours',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              rows: filteredData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data['Name'])),
                  DataCell(Text(data['Card No'])),
                  DataCell(Text(data['Status'])),
                  DataCell(
                    Text(
                      data['Working Hours'],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
