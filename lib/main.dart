import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Rolling Game',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headline4:
              TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.amber),
        ),
      ),
      home: const MyHomePage(title: 'Dice Rolling Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _diceNumber = 1;
  final Random _random = Random();
  late AnimationController _controller;
  late Animation<double> _animation;

  // 新增变量以存储历史记录
  List<int> _diceHistory = [];
  int _totalRolls = 0; // 新增变量以存储总掷骰次数
  double _averageRoll = 0.0; // 新增变量以存储平均掷骰结果

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  void _rollDice() {
    setState(() {
      _diceNumber = _random.nextInt(6) + 1;
      _diceHistory.add(_diceNumber); // 记录每次掷骰子的结果
      _totalRolls++; // 增加掷骰次数
      _averageRoll =
          _diceHistory.reduce((a, b) => a + b) / _totalRolls; // 计算平均值
    });
    _controller.forward(from: 0);
  }

  // 新增方法以清空历史记录
  void _clearHistory() {
    setState(() {
      _diceHistory.clear();
      _totalRolls = 0; // 重置掷骰次数
      _averageRoll = 0.0; // 重置平均值
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple], // 使用渐变色背景
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Dice Number:',
                style: TextStyle(fontSize: 24, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateZ(_animation.value * 2 * pi), // 修改为绕Z轴旋转
                    child: child,
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_diceNumber',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontSize: 80,
                            color: Colors.black,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 新增显示历史记录的文本
              Text(
                'History: ${_diceHistory.join(', ')}',
                style: const TextStyle(fontSize: 18, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              // 新增显示总掷骰次数
              Text(
                'Total Rolls: $_totalRolls',
                style: const TextStyle(fontSize: 18, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              // 新增显示平均掷骰结果
              Text(
                'Average Roll: ${_averageRoll.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              // 新增清空历史记录的按钮
              ElevatedButton(
                onPressed: _clearHistory,
                child: const Text('Clear History'),
                style: ElevatedButton.styleFrom(primary: Colors.amber),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _rollDice,
        tooltip: 'Roll Dice',
        icon: const Icon(Icons.casino, color: Colors.black),
        label: const Text('Roll Dice', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
