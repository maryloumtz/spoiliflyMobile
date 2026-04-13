import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/formatters.dart';
import 'package:flutter_application_1/src/core/models.dart';

class WorkCard extends StatelessWidget {
  const WorkCard({
    required this.work,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final WorkCardView work;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: compact
            ? Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PosterImage(
                      imageUrl: work.coverImage,
                      width: 88,
                      height: 118,
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: _CardBody(work: work, compact: true)),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PosterImage(
                    imageUrl: work.coverImage,
                    width: double.infinity,
                    height: 200,
                    radius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: _CardBody(work: work, compact: false),
                  ),
                ],
              ),
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({
    required this.imageUrl,
    required this.width,
    required this.height,
    this.radius = const BorderRadius.all(Radius.circular(22)),
  });

  final String imageUrl;
  final double width;
  final double height;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.white10,
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({required this.work, required this.compact});

  final WorkCardView work;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MetaPill(label: capitalize(work.type)),
            if (work.category != null) _MetaPill(label: work.category!.name),
            _MetaPill(label: '${work.releaseYear}'),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          work.title,
          style: TextStyle(
            fontSize: compact ? 18 : 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          work.description,
          maxLines: compact ? 3 : 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            height: 1.45,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...work.tags
                .take(compact ? 2 : 3)
                .map((tag) => _MetaPill(label: '#${tag.name}')),
            _MetaPill(label: '${work.spoilerCount} spoilers'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Dès ${formatPrice(work.lowestPriceCents)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Explorer',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
