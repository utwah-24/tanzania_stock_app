import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/data/latest_news.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.article});

  final NewsArticle article;

  Future<void> _readMore(BuildContext context) async {
    try {
      if (await launchUrl(
        Uri.parse(article.url),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {
      // Keep the detail page available if the browser cannot be opened.
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Could not open the article. Please try again.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.typography.sans;

    return Scaffold(
      backgroundColor: colors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Match the source photo's proportions so the expanded image is
          // fully visible. Flutter's sliver handles continuous scroll motion.
          final imageHeight = constraints.maxWidth / article.imageAspectRatio;
          return CustomScrollView(
            key: const ValueKey('news-detail-scroll'),
            slivers: [
              SliverAppBar(
                key: const ValueKey('news-image-header'),
                pinned: true,
                expandedHeight: imageHeight + kToolbarHeight,
                backgroundColor: colors.background,
                foregroundColor: colors.foreground,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leadingWidth: 64,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: shadcn.SecondaryButton(
                    key: const ValueKey('news-detail-back'),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(
                      shadcn.LucideIcons.arrowLeft,
                      size: 20,
                      semanticLabel: 'Back',
                    ),
                  ),
                ),
                title: Text(
                  'Latest News',
                  style: text.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      child: Image.asset(
                        article.imageAsset,
                        key: const ValueKey('news-detail-image'),
                        width: constraints.maxWidth,
                        height: imageHeight,
                        fit: BoxFit.contain,
                        semanticLabel:
                            'Article photo from ${article.publisher}',
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: imageHeight,
                          color: colors.muted,
                          alignment: Alignment.center,
                          child: Icon(
                            shadcn.LucideIcons.newspaper,
                            size: 48,
                            color: colors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          shadcn.SecondaryBadge(child: Text(article.category)),
                          Text(
                            article.publisher,
                            style: text.copyWith(
                              color: colors.mutedForeground,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Semantics(
                        header: true,
                        child: Text(
                          article.title,
                          style: text.copyWith(
                            color: colors.foreground,
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'By ${article.author}',
                        style: text.copyWith(
                          color: colors.foreground,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${article.dateLabel} • ${article.readTime}',
                        style: text.copyWith(
                          color: colors.mutedForeground,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Divider(color: colors.border, height: 1),
                      ),
                      Text(
                        'At a glance',
                        style: text.copyWith(
                          color: colors.foreground,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final paragraph in article.summary)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            paragraph,
                            style: text.copyWith(
                              color: colors.foreground,
                              fontSize: 16,
                              height: 1.65,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(24, 6, 24, 24),
                  child: shadcn.Card(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Summary of reporting by ${article.publisher}. '
                          'Read the full story on their website.',
                          style: text.copyWith(
                            color: colors.mutedForeground,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        shadcn.PrimaryButton(
                          key: const ValueKey('news-read-more'),
                          onPressed: () => _readMore(context),
                          trailing: const Icon(
                            shadcn.LucideIcons.arrowUpRight,
                            size: 18,
                          ),
                          child: const Text('Read more'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
