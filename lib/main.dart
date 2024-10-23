import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final double maxSlide = 200.0;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  void toggle() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  void _onDragUpdate(DragUpdateDetails details) {
    _animationController.value += details.delta.dx / maxSlide;
    _animationController.value += details.delta.dx / maxSlide;
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.value < 0.5) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyDrawer(),
        GestureDetector(
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              double slide = maxSlide * _animationController.value;
              double scale = 1 - (_animationController.value * 0.3);
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale),
                child: MyChild(
                  toggle: toggle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final List<Map<IconData, String>> drawerItems = [
    {Icons.info: "News"},
    {Icons.star: "Favourites"},
    {Icons.map: "Map"},
    {Icons.settings: "Settings"},
    {Icons.person: "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flutter',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                Text(
                  'Europe',
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: drawerItems.map((entry) {
                    final key = entry.entries.first.key;
                    final value = entry.entries.first.value;
                    return ListTile(
                      leading: Icon(
                        key,
                        color: Colors.white,
                      ),
                      title: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyChild extends StatefulWidget {
  const MyChild({super.key, required this.toggle});
  final VoidCallback toggle;

  @override
  State<MyChild> createState() => _MyChildState();
}

class _MyChildState extends State<MyChild> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Flutter Demo Home Page"),
        leading: IconButton(onPressed: widget.toggle, icon: Icon(Icons.menu)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              child: RiveAnimation.network(
                'https://cdn.rive.app/animations/vehicles.riv',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
