import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(DividendCalculatorApp());
}

class DividendCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dividend Calculator',
      theme: ThemeData(
        primaryColor: Color(0xFF8B0000),
        scaffoldBackgroundColor: Color(0xFFFFF5F5),
        textTheme: ThemeData.light().textTheme.copyWith(
          bodyLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'PlayfairDisplay'),
        ),
      ),
      home: HomePage(),
      routes: {
        '/about': (context) => AboutPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final investedController = TextEditingController();
  final rateController = TextEditingController();
  final monthsController = TextEditingController();

  double? monthlyDividend;
  double? totalDividend;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  void calculateDividend() {
    double invested = double.tryParse(investedController.text) ?? 0.0;
    double rate = double.tryParse(rateController.text) ?? 0.0;
    int months = int.tryParse(monthsController.text) ?? 0;

    if (months > 12) months = 12;

    setState(() {
      monthlyDividend = (rate / 100 / 12) * invested;
      totalDividend = monthlyDividend! * months;
    });
  }

  void resetFields() {
    investedController.clear();
    rateController.clear();
    monthsController.clear();
    setState(() {
      monthlyDividend = null;
      totalDividend = null;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and scale animation
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward(); // Start animation on load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000),
        title: Text('Dividend Calculator', style: TextStyle(fontFamily: 'PlayfairDisplay')),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE5E5), Color(0xFFFFCCCC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.red.shade200, blurRadius: 10)],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Image.asset('assets/images/calculator.png', height: 250), // Increased image size
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Elegant Calculator',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: investedController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Invested Fund Amount (RM)'),
                  ),
                  TextField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Annual Dividend Rate (%)'),
                  ),
                  TextField(
                    controller: monthsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Number of Months (1-12)'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: calculateDividend,
                        child: Text('Calculate', style: TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.black)), // Text color changed to black
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF801E1E),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: resetFields,
                        child: Text('Reset', style: TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.black)), // Text color changed to black
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF801E1E),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (monthlyDividend != null && totalDividend != null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Calculation:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Monthly Dividend = RM ${investedController.text} × ${rateController.text}% ÷ 12'),
                          SizedBox(height: 5),
                          Text('= RM ${monthlyDividend!.toStringAsFixed(2)}'),
                          SizedBox(height: 10),
                          Text('Total Dividend for ${monthsController.text} months ='),
                          Text('RM ${monthlyDividend!.toStringAsFixed(2)} × ${monthsController.text} = RM ${totalDividend!.toStringAsFixed(2)}'),
                        ],
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  final Uri githubUrl = Uri.parse('https://github.com/yayan4ever/dividend_calculator_app');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000),
        title: Text('About', style: TextStyle(fontFamily: 'PlayfairDisplay')),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD6D6), Color(0xFFFFB6B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/icon.png', height: 120), // Larger image for more emphasis
            ),
            SizedBox(height: 30),
            Text('Name: Nur Aqila Binti Azhar', style: TextStyle(fontSize: 16, fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold)),
            Text('Matric No: 2023367775', style: TextStyle(fontSize: 16, fontFamily: 'PlayfairDisplay')),
            Text('Course: CS251 BACHELOR OF COMPUTER SCIENCE (HONS.) NETCENTRIC COMPUTING', style: TextStyle(fontSize: 16, fontFamily: 'PlayfairDisplay')),
            SizedBox(height: 20),
            Text('© 2025 Nur Aqila Binti Azhar', style: TextStyle(fontSize: 14, fontFamily: 'PlayfairDisplay', fontStyle: FontStyle.italic)),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => launchUrl(githubUrl),
              child: Text(
                'View GitHub Repository',
                style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      ),
    );
  }
}
