// Publisher metadata verified from the article on 2026-09-14.
const latestNews = [
  NewsArticle(
    title: 'Billionaire Dangote launches oil refinery ‘people’s IPO’, Africa’s biggest',
    publisher: 'CNBC Africa',
    dateLabel: 'Sep 14, 2026',
    author: 'Isaac Anyaogu and Chijioke Ohuocha',
    category: 'Markets',
    readTime: 'About 3 min read',
    imageAspectRatio: 1.5,
    summary: [
      'Aliko Dangote has opened his Nigerian oil refinery to public investment through an IPO intended to help finance expansion. The share sale aims to bring ordinary investors into ownership of one of Africa’s largest industrial businesses.',
      'The base offer could raise about \$1.6 billion if fully subscribed. That figure could reach roughly \$2.1 billion if demand exceeds the initial offer and the company issues additional shares. Investors can participate with a minimum purchase of 10 shares.',
      'The refinery began operations in 2024 and has changed Nigeria’s position in the fuel market. Expansion plans would lift daily processing capacity from 700,000 barrels to 1.4 million by 2029. The IPO follows an earlier private placement for institutional investors.',
    ],
    imageAsset: 'assets/news/dangote-refinery-ipo.jpg',
    url: 'https://www.cnbcafrica.com/2026/nigerian-billionaire-dangote-launches-oil-refinery-ipo-africas-biggest-share-sale',
  ),
  NewsArticle(
    title: 'Tanzania Commercial Bank nears stock exchange listing as government reviews public firms',
    publisher: 'The Citizen',
    dateLabel: 'Sep 10, 2026',
    author: 'Gadiosa Lamtey',
    category: 'National',
    readTime: '4 min read',
    imageAspectRatio: 2,
    summary: [
      'Tanzania Commercial Bank is approaching a possible listing on the Dar es Salaam Stock Exchange. The government has placed the bank among public institutions that could reach the market in the near term, with internal procedures still to be completed.',
      'The wider review groups state-owned institutions by their readiness to list. The aim is to attract investment, strengthen transparency and give citizens and other investors more opportunities to participate in public enterprises.',
      'A listing would give participating companies another way to raise capital for expansion. The review forms part of broader reforms intended to improve the performance of government investments and public institutions.',
    ],
    imageAsset: 'assets/news/tcb-listing.jpg',
    url: 'https://www.thecitizen.co.tz/tanzania/news/national/tanzania-commercial-bank-nears-stock-exchange-listing-as-government-reviews-public-firms-5589192',
  ),
];

class NewsArticle {
  const NewsArticle({
    required this.title,
    required this.publisher,
    required this.dateLabel,
    required this.author,
    required this.category,
    required this.readTime,
    required this.imageAspectRatio,
    required this.summary,
    required this.imageAsset,
    required this.url,
  });
  final String title;
  final String publisher;
  final String dateLabel;
  final String author;
  final String category;
  final String readTime;
  final double imageAspectRatio;
  final List<String> summary;
  final String imageAsset;
  final String url;
}
