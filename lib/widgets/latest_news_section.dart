import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/data/latest_news.dart';
import 'package:tanzania_stocks_app/screens/news_detail.dart';

class LatestNewsSection extends StatelessWidget {
  const LatestNewsSection({super.key, this.showHeader = true, this.itemLimit});

  final bool showHeader;
  final int? itemLimit;

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    final articles = latestNews.take(itemLimit ?? latestNews.length).toList();
    return shadcn.Card(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Latest News',
                    style: theme.typography.sans.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.cardForeground,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                shadcn.TextButton(
                  density: shadcn.ButtonDensity.compact,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LatestNewsPage(),
                    ),
                  ),
                  child: Text(
                    'View all',
                    style: theme.typography.sans.copyWith(
                      fontSize: 14,
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
          for (var index = 0; index < articles.length; index++) ...[
            if (index > 0) const SizedBox(height: 20),
            _NewsRow(article: articles[index]),
          ],
        ],
      ),
    );
  }
}

class _NewsRow extends StatelessWidget {
  const _NewsRow({required this.article});
  final NewsArticle article;

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => NewsDetailPage(article: article)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    return Semantics(
      button: true,
      label: '${article.title}, ${article.dateLabel}, ${article.publisher}',
      excludeSemantics: true,
      onTap: () => _open(context),
      child: shadcn.Clickable(
        key: ValueKey(article.url),
        onPressed: () => _open(context),
        decoration: WidgetStateProperty.resolveWith(
          (states) => BoxDecoration(
            color:
                states.contains(WidgetState.pressed) ||
                    states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.focused)
                ? colors.muted
                : colors.card,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                article.imageAsset,
                width: 76,
                height: 82,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 76,
                  height: 82,
                  color: colors.muted,
                  child: Icon(
                    Icons.article_outlined,
                    color: colors.mutedForeground,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.typography.sans.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                      color: colors.cardForeground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${article.dateLabel} • ${article.publisher}',
                    style: theme.typography.sans.copyWith(
                      fontSize: 12,
                      height: 1.4,
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LatestNewsPage extends StatelessWidget {
  const LatestNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Latest News'),
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        surfaceTintColor: Colors.transparent,
      ),
      body: const SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: LatestNewsSection(showHeader: false),
        ),
      ),
    );
  }
}
