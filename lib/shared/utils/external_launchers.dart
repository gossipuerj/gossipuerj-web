import "package:url_launcher/url_launcher.dart";

Future<void> openInstagram(String handle) async {
  final sanitized = handle.replaceAll("@", "");
  final uri = Uri.parse("https://instagram.com/$sanitized");
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
