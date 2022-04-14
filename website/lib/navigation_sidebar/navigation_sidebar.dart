import 'package:beamer/beamer.dart';
import 'package:beamer_website/navigation_sidebar/navigation_button.dart';
import 'package:flutter/material.dart';

class NavigationSidebar extends StatefulWidget {
  const NavigationSidebar({Key? key}) : super(key: key);

  @override
  State<NavigationSidebar> createState() => _NavigationSidebarState();
}

class _NavigationSidebarState extends State<NavigationSidebar> {
  late BeamerDelegate _beamer;

  void _setStateListener() => setState(() {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _beamer = Beamer.of(context);
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _beamer.addListener(_setStateListener),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = _beamer.configuration.location!;
    return SizedBox(
      width: 256,
      child: Column(children: _buttons(path)),
    );
  }

  List<Widget> _buttons(String path) => [
        NavigationButton(
          text: 'Introduction',
          isSelected: path == '/' || path.contains('books'),
          onTap: () => _beamer.beamToNamed('/'),
        ),
        ExpandableNavigationButton(
          text: 'Quick Start',
          isSelected: path.contains('start'),
          onTap: () => _beamer.beamToNamed('/start'),
          children: [
            NavigationButton(
              text: 'Routes',
              isSelected: path.contains('routes'),
              onTap: () => Beamer.of(context).beamToNamed('/start/routes'),
            ),
            NavigationButton(
              text: 'Beaming',
              isSelected: path.contains('beaming'),
              onTap: () => Beamer.of(context).beamToNamed('/start/beaming'),
            ),
          ],
        ),
        ExpandableNavigationButton(
          text: 'Key Concepts',
          isSelected: path.contains('concepts'),
          onTap: () => _beamer.beamToNamed('/concepts'),
          children: [
            NavigationButton(
              text: 'BeamLocation',
              isSelected: path.contains('beam_location'),
              onTap: () =>
                  Beamer.of(context).beamToNamed('/concepts/beam-location'),
            ),
            NavigationButton(
              text: 'BeamerDelegate',
              isSelected: path.contains('delegate'),
              onTap: () => Beamer.of(context).beamToNamed('/concepts/delegate'),
            ),
            NavigationButton(
              text: 'BeamGuard',
              isSelected: path.contains('guard'),
              onTap: () => Beamer.of(context).beamToNamed('/concepts/guard'),
            ),
            NavigationButton(
              text: 'Nested Navigation',
              isSelected: path.contains('nested'),
              onTap: () => Beamer.of(context).beamToNamed('/concepts/nested'),
            ),
          ],
        ),
        ExpandableNavigationButton(
          text: 'Examples',
          isSelected: path.contains('examples'),
          onTap: () => _beamer.beamToNamed('/examples'),
        ),
      ];

  @override
  void dispose() {
    _beamer.removeListener(_setStateListener);
    super.dispose();
  }
}
