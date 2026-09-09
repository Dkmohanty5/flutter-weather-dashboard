class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/forecast',
      page: () => const ForecastScreen(),
    ),
    GetPage(
      name: '/search',
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: '/details',
      page: () => const DetailsScreen(),
    ),
  ];
}
