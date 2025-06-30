import 'package:flutter/material.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';

class PlastikInfoCard extends StatelessWidget {
  final String? imageId;
  final String title;
  final String? subtitle;
  final IconData iconData;

  const PlastikInfoCard({
    super.key,
    this.imageId,
    required this.title,
    this.subtitle,
    this.iconData = Icons.delete_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child:
                (imageId != null && imageId!.isNotEmpty)
                    ? Image.network(
                      Appwrite.getImageUrl(
                        Appwrite.bucketImagesTrash,
                        imageId!,
                      ),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (context, child, progress) =>
                              progress == null
                                  ? child
                                  : Container(
                                    width: 70,
                                    height: 70,
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                    )
                    : Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(iconData, color: Colors.green[600], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      subtitle ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.green[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
