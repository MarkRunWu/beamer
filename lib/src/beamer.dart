import 'package:flutter/widgets.dart';

import 'beam_location.dart';
import 'beamer_router_delegate.dart';
import 'beamer_route_information_parser.dart';
import 'beamer_provider.dart';

/// Central place for creating, accessing and modifying a Router subtree.
class Beamer extends StatefulWidget {
  Beamer({
    Key key,
    @required this.beamLocations,
    this.routerDelegate,
  })  : assert(beamLocations != null),
        super(key: key);

  // TODO give this to delegate also, to enable beamToNamed later on
  /// [BeamLocation]s that this Beamer handles.
  final List<BeamLocation> beamLocations;

  /// Responsible for beaming, updating and rebuilding the page stack.
  ///
  /// Normally, this never needs to be set
  /// unless extending [BeamerRouterDelegate] with custom implementation.
  final BeamerRouterDelegate routerDelegate;

  /// Access Beamer's [routerDelegate].
  static BeamerRouterDelegate of(BuildContext context) {
    try {
      return Router.of(context).routerDelegate;
    } catch (e) {
      assert(BeamerProvider.of(context) != null,
          'There was no Router nor BeamerProvider in current context. If using MaterialApp.builder, wrap the MaterialApp.router in BeamerProvider to which you pass the same routerDelegate as to MaterialApp.router.');
      return BeamerProvider.of(context).routerDelegate;
    }
  }

  @override
  State<StatefulWidget> createState() => BeamerState();
}

class BeamerState extends State<Beamer> {
  BeamerRouterDelegate _routerDelegate;

  BeamerRouterDelegate get routerDelegate => _routerDelegate;
  BeamLocation get currentLocation => _routerDelegate.currentLocation;

  @override
  void initState() {
    super.initState();
    _routerDelegate ??= widget.routerDelegate ??
        BeamerRouterDelegate(beamLocations: widget.beamLocations);
  }

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: _routerDelegate,
      routeInformationParser: BeamerRouteInformationParser(),
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(
          location: currentLocation.uri.toString(),
        ),
      ),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

extension BeamTo on BuildContext {
  void beamTo(BeamLocation location, {bool beamBackOnPop = false}) {
    Beamer.of(this).beamTo(location, beamBackOnPop: beamBackOnPop);
  }
}

extension BeamToNamed on BuildContext {
  void beamToNamed(String uri, {bool beamBackOnPop = false}) {
    Beamer.of(this).beamToNamed(uri, beamBackOnPop: beamBackOnPop);
  }
}

extension BeamBack on BuildContext {
  void beamBack() {
    Beamer.of(this).beamBack();
  }
}

extension UpdateCurrentLocation on BuildContext {
  void updateCurrentLocation({
    String pathBlueprint,
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, dynamic> data = const <String, dynamic>{},
    bool rewriteParameters = false,
  }) {
    Beamer.of(this).updateCurrentLocation(
      pathBlueprint: pathBlueprint,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      data: data,
      rewriteParameters: rewriteParameters,
    );
  }
}
