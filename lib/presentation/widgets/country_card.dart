
import 'package:flutter/material.dart';
import 'package:country_info_sync/data/models/country_model.dart';

class CountryCard extends StatelessWidget {
  final CountryModel country;
  final VoidCallback onTap;

  const CountryCard({
    Key? key,
    required this.country,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: country.flag.isNotEmpty
            ? Image.network(
                country.flag,
                width: 48,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.flag,
                  size: 32,
                ),
              )
            : const Icon(Icons.flag, size: 32),
        title: Text(
          country.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${country.capital ?? ''} • ${country.continent}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: onTap,
        ),
      ),
    );
  }
}
