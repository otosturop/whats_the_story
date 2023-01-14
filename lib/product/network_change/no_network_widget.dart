import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import './network_change_manager.dart';

class NoNetworkWidget extends StatefulWidget {
  const NoNetworkWidget({super.key});

  @override
  State<NoNetworkWidget> createState() => _NoNetworkWidgetState();
}

class _NoNetworkWidgetState extends State<NoNetworkWidget> {
  late final INetworkChangeManager _networkChangeManager;
  NetworkResult? _networkResult;

  @override
  void initState() {
    super.initState();
    _networkChangeManager = NetworkChangeManager();
    fetchFirstResult();
    _networkChangeManager.handleNetworkChange((result) {
      _updateView(result);
    });
  }

  Future<void> fetchFirstResult() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final result = await _networkChangeManager.checkNetworkFirstTime();
      _updateView(result);
    });
  }

  void _updateView(NetworkResult result) {
    setState(() {
      _networkResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: context.durationLow,
      crossFadeState: _networkResult == NetworkResult.off ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        height: context.dynamicHeight(0.075),
        color: Colors.black,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No internet",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
      secondChild: const SizedBox(),
    );
  }
}
