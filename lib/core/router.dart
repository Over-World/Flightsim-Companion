import 'package:go_router/go_router.dart';

import 'settings.dart';

import '../features/aircraft/aircraft_edit_screen.dart';
import '../features/aircraft/aircraft_list_screen.dart';
import '../features/airports/airport_detail_screen.dart';
import '../features/airports/airport_search_screen.dart';
import '../features/fly/fly_screen.dart';
import '../features/logbook/logbook_screen.dart';
import '../features/notes/notepad_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/plan/flight_editor_screen.dart';
import '../features/plan/plan_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/adaptive_shell.dart';

GoRoute _airportRoutes() => GoRoute(
  path: 'airports',
  builder: (context, state) => const AirportSearchScreen(),
  routes: [
    GoRoute(
      path: ':id',
      builder: (context, state) => AirportDetailScreen(
        airportId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);

GoRouter createRouter(SettingsController settings) => GoRouter(
  initialLocation: '/plan',
  redirect: (context, state) =>
      !settings.onboardingCompleted && state.matchedLocation != '/welcome'
      ? '/welcome'
      : null,
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/notes', builder: (context, state) => const NotepadScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AdaptiveShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/plan',
              builder: (context, state) => const PlanScreen(),
              routes: [
                _airportRoutes(),
                GoRoute(
                  path: 'flights/:id',
                  builder: (context, state) => FlightEditorScreen(
                    flightId: int.parse(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/fly',
              builder: (context, state) => const FlyScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/aircraft',
              builder: (context, state) => const AircraftListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  builder: (context, state) => const AircraftEditScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => AircraftEditScreen(
                    aircraftId: int.parse(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/logbook',
              builder: (context, state) => const LogbookScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
