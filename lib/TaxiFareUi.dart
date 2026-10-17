import 'package:flutter/material.dart';

class TaxiFareUi extends StatefulWidget {
  const TaxiFareUi({super.key});

  @override
  State<TaxiFareUi> createState() => _TaxiFareUiState();
}

class _TaxiFareUiState extends State<TaxiFareUi> {
  final TextEditingController _distanceCtrl = TextEditingController();
  final TextEditingController _timeCtrl = TextEditingController();

  double _fare = 0.0;
  bool _showError = false;

  static const Color _yellow = Color(0xFFFFC107);

  // อัตราค่าโดยสาร: [ขอบบนของช่วง (กม.), ราคาต่อกม.]
  static const List<List<double>> _tiers = [
    [10, 6.50], // กม.ที่ 2-10
    [20, 7.00], // กม.ที่ 10-20
    [40, 8.00], // กม.ที่ 20-40
    [60, 8.50], // กม.ที่ 40-60
    [80, 9.00], // กม.ที่ 60-80
    [double.infinity, 10.50], // เกิน 80 กม.
  ];

  double _calculateFare(double distance, double trafficMinutes) {
    double total = 35.0; // กิโลเมตรแรก 35 บาท
    double lower = 1.0;

    for (final tier in _tiers) {
      if (distance <= lower) break;
      final upper = tier[0];
      final rate = tier[1];
      final km = (distance < upper ? distance : upper) - lower;
      total += km * rate;
      lower = upper;
    }

    total += trafficMinutes * 3.0; // รถติดนาทีละ 3 บาท
    return total;
  }

  void _onCalculate() {
    FocusScope.of(context).unfocus();
    final distance = double.tryParse(_distanceCtrl.text.trim());
    final time = double.tryParse(_timeCtrl.text.trim());

    if (distance == null || time == null) {
      setState(() {
        _showError = true;
        _fare = 0.0;
      });
      return;
    }

    setState(() {
      _showError = false;
      _fare = _calculateFare(distance, time);
    });
  }

  void _onCancel() {
    FocusScope.of(context).unfocus();
    setState(() {
      _distanceCtrl.clear();
      _timeCtrl.clear();
      _fare = 0.0;
      _showError = false;
    });
  }

  @override
  void dispose() {
    _distanceCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFD0C4E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFD0C4E0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _yellow,
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Taxi Fare',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(
              child: Image.asset('assets/images/taxi.png', width: 120, height: 120),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'คำนวณค่าโดยสารแท็กซี่',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const Text('ระยะทาง (กิโลเมตร) 🚖',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _distanceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('กรุณากรอกระยะทาง'),
            ),
            const SizedBox(height: 14),
            const Text('เวลารถติด (นาที) ⏰',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _timeCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('กรุณากรอกเวลารถติด'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _onCalculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _yellow,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('คำนวณค่าโดยสาร'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('ยกเลิก'),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECB3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text('ค่าโดยสารแท็กซี่', style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    _fare.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const Text('บาท', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _showError
          ? Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const SafeArea(
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.yellow, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'กรุณากรอกข้อมูลให้ครบถ้วน',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}