class ServiceEntity {
  final String id;
  final String title;
  final String description;
  final String? iconUrl;
  final String? serviceNote;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    this.iconUrl,
    this.serviceNote,
  });
}