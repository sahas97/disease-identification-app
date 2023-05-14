import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rice_disease_identification_app/Models/results_class.dart';
import 'package:rice_disease_identification_app/Pages/home.dart';
import 'package:rice_disease_identification_app/Pages/results.dart';
import 'package:rice_disease_identification_app/Pages/scan.dart';
import 'package:rice_disease_identification_app/services/services.dart';

void main() => runApp(const BottomNavigation());

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  Services services = Services();
  int selectedIndex = 0;
  Result? result;
  bool isLoading = true;

  final List<String> screenNames = ['Information', 'Scan', 'result'];
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _scanNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _resultNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    try {
      result = await services.getResultsServices();
    } catch (error) {
      debugPrint(error.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  screenNames[selectedIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.black,
              ),
              backgroundColor: Colors.white,
              bottomNavigationBar: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    left: 25.0,
                    right: 25.0,
                    bottom: 10.0,
                  ),
                  child: GNav(
                    onTabChange: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    selectedIndex: selectedIndex,
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Colors.black,
                    color: Colors.white,
                    activeColor: Colors.white,
                    tabBackgroundColor: Colors.grey.shade800,
                    gap: 10,
                    tabs: const [
                      GButton(
                        icon: Icons.home,
                        text: "Home",
                      ),
                      GButton(
                        icon: Icons.camera_alt,
                        text: "Scan",
                      ),
                      GButton(
                        icon: Icons.assessment,
                        text: "Result",
                      ),
                    ],
                  ),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  Offstage(
                    offstage: selectedIndex != 0,
                    child: Navigator(
                      key: _homeNavigatorKey,
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute(
                          builder: (BuildContext context) => const HomePage(),
                        );
                      },
                    ),
                  ),
                  Offstage(
                    offstage: selectedIndex != 1,
                    child: Navigator(
                      key: _scanNavigatorKey,
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute(
                          builder: (BuildContext context) => ScanPage(
                            navigatorKey: _scanNavigatorKey,
                          ),
                        );
                      },
                    ),
                  ),
                  Offstage(
                    offstage: selectedIndex != 2,
                    child: Navigator(
                      key: _resultNavigatorKey,
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute(
                          builder: (BuildContext context) => result != null
                              ? ResultPage(
                                  result: result!,
                                )
                              : Container(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
