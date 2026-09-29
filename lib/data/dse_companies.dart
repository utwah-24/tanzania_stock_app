import 'package:tanzania_stocks_app/models/listed_company.dart';

// DSE public company directory, retrieved 2026-09-12.
// https://dse.co.tz/listed/company/list
// Directory membership does not establish current trading availability.
// Source profiles and logo URLs are recorded in assets/companies/sources.json.
const dseCompanies = [
  ListedCompany(
    symbol: 'AFRIPRISE',
    name: 'Afriprise Investment',
    logoAsset: 'assets/companies/afriprise.png',
  ),
  ListedCompany(
    symbol: 'CRDB',
    name: 'CRDB Bank',
    logoAsset: 'assets/companies/crdb.jpg',
  ),
  ListedCompany(
    symbol: 'DCB',
    name: 'DCB Commercial Bank',
    logoAsset: 'assets/companies/dcb.jpeg',
  ),
  ListedCompany(
    symbol: 'DSE',
    name: 'Dar es Salaam Stock Exchange',
    logoAsset: 'assets/companies/dse.png',
  ),
  ListedCompany(
    symbol: 'EABL',
    name: 'East African Breweries',
    logoAsset: 'assets/companies/eabl.jpg',
  ),
  ListedCompany(
    symbol: 'JATU',
    name: 'JATU',
    logoAsset: 'assets/companies/jatu.png',
  ),
  ListedCompany(
    symbol: 'JHL',
    name: 'Jubilee Holdings',
    logoAsset: 'assets/companies/jhl.jpg',
  ),
  ListedCompany(
    symbol: 'KA',
    name: 'Kenya Airways',
    logoAsset: 'assets/companies/ka.jpg',
  ),
  ListedCompany(
    symbol: 'KCB',
    name: 'KCB Group',
    logoAsset: 'assets/companies/kcb.png',
  ),
  ListedCompany(
    symbol: 'MBP',
    name: 'Maendeleo Bank',
    logoAsset: 'assets/companies/mbp.png',
  ),
  ListedCompany(
    symbol: 'MCB',
    name: 'Mwalimu Commercial Bank',
    logoAsset: 'assets/companies/mcb.png',
  ),
  ListedCompany(
    symbol: 'MKCB',
    name: 'Mkombozi Commercial Bank',
    logoAsset: 'assets/companies/mkcb.png',
  ),
  ListedCompany(
    symbol: 'MUCOBA',
    name: 'Mucoba Bank',
    logoAsset: 'assets/companies/mucoba.png',
  ),
  ListedCompany(
    symbol: 'NICO',
    name: 'National Investment Company',
    logoAsset: 'assets/companies/nico.png',
  ),
  ListedCompany(
    symbol: 'NMB',
    name: 'NMB Bank',
    logoAsset: 'assets/companies/nmb.png',
  ),
  ListedCompany(
    symbol: 'NMG',
    name: 'Nation Media Group',
    logoAsset: 'assets/companies/nmg.png',
  ),
  ListedCompany(
    symbol: 'PAL',
    name: 'Precision Air Services',
    logoAsset: 'assets/companies/pal.jpg',
  ),
  ListedCompany(
    symbol: 'SWALA',
    name: 'Swala Oil and Gas',
    logoAsset: 'assets/companies/swala.png',
  ),
  ListedCompany(
    symbol: 'SWIS',
    name: 'Swissport Tanzania',
    logoAsset: 'assets/companies/swis.png',
  ),
  ListedCompany(
    symbol: 'TBL',
    name: 'Tanzania Breweries',
    logoAsset: 'assets/companies/tbl.jpg',
  ),
  ListedCompany(
    symbol: 'TCC',
    name: 'Tanzania Cigarette Company',
    logoAsset: 'assets/companies/tcc.png',
  ),
  ListedCompany(symbol: 'TCPLC', name: 'Tanga Cement'),
  ListedCompany(
    symbol: 'TOL',
    name: 'TOL Gases',
    logoAsset: 'assets/companies/tol.jpg',
  ),
  ListedCompany(
    symbol: 'TPCC',
    name: 'Tanzania Portland Cement',
    logoAsset: 'assets/companies/tpcc.png',
  ),
  ListedCompany(
    symbol: 'TTP',
    name: 'Tanzania Tea Packers (TATEPA)',
    logoAsset: 'assets/companies/ttp.jpg',
  ),
  ListedCompany(
    symbol: 'USL',
    name: 'Uchumi Supermarkets',
    logoAsset: 'assets/companies/usl.jpg',
  ),
  ListedCompany(
    symbol: 'VODA',
    name: 'Vodacom Tanzania',
    logoAsset: 'assets/companies/voda.jpg',
  ),
  ListedCompany(
    symbol: 'YETU',
    name: 'Yetu Microfinance Bank',
    logoAsset: 'assets/companies/yetu.png',
  ),
];
