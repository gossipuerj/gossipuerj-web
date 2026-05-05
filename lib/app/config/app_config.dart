class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.isDebug});

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment(
        "API_BASE_URL",
        defaultValue: "http://163.176.222.215:8080",
      ),
      isDebug: bool.fromEnvironment("dart.vm.product") == false,
    );
  }

  final String apiBaseUrl;
  final bool isDebug;
}
