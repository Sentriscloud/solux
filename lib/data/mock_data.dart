import '../models/token.dart';
import '../models/transaction.dart';
import '../models/validator.dart';
import '../models/contact.dart';
import '../theme/app_colors.dart';

const mockAddress       = 'srx1q9xf3mkl...k3a7';
const mockAddressMasked = 'srx1 •••• k3a7';
const mockTotalUsd      = 1870.00;
const mockTotalSrx      = 12500.0;

final mockTokens = [
  const Token(symbol: 'SRX',  name: 'Sentrix',         balance: 12500, usd: 1250.00, change: 2.4,   color: AppColors.violet),
  const Token(symbol: 'SNTX', name: 'Sentrix Utility', balance: 50000, usd: 120.00,  change: -0.8,  color: AppColors.accentCyan),
  const Token(symbol: 'SRTX', name: 'Sentrix Stable',  balance: 500,   usd: 500.00,  change: 0.01,  color: AppColors.pink),
];

final mockTxs = [
  const Tx(type: TxType.receive, title: 'Received SRX',       sub: 'From srx1...b2c4 · 10:32 AM', amount: '+500 SRX',  usd: '+\$50.00',    color: AppColors.success),
  const Tx(type: TxType.send,    title: 'Sent SRX',            sub: 'To srx1...d9e1 · Yesterday',  amount: '-200 SRX',  usd: '-\$20.00',    color: AppColors.danger),
  const Tx(type: TxType.swap,    title: 'Swapped SRX → SNTX', sub: 'Via DEX · Apr 9',              amount: '-100 SRX',  usd: '+5,000 SNTX', color: AppColors.indigo),
  const Tx(type: TxType.stake,   title: 'Staking reward',      sub: 'Validator · Apr 8',            amount: '+12 SRX',   usd: '+\$1.20',    color: AppColors.violet),
];

final mockTxsExtended = [
  // Today
  const Tx(type: TxType.receive, title: 'Received SRX',        sub: 'From srx1...b2c4',  amount: '+500 SRX',   usd: '+\$50.00',    color: AppColors.success, date: 'Today',     time: '10:32 AM', status: 'Confirmed', fee: '0.001 SRX', hash: '0xabc...123'),
  const Tx(type: TxType.send,    title: 'Sent SRX',             sub: 'To srx1...d9e1',    amount: '-200 SRX',   usd: '-\$20.00',    color: AppColors.danger,  date: 'Today',     time: '08:15 AM', status: 'Confirmed', fee: '0.001 SRX', hash: '0xdef...456'),
  // Yesterday
  const Tx(type: TxType.swap,    title: 'Swapped SRX → SNTX',  sub: 'Via DEX',           amount: '-100 SRX',   usd: '+5,000 SNTX', color: AppColors.warning, date: 'Yesterday', time: '15:20 PM', status: 'Confirmed', fee: '0.002 SRX', hash: '0xghi...789'),
  const Tx(type: TxType.stake,   title: 'Staking reward',       sub: 'Validator node',    amount: '+12 SRX',    usd: '+\$1.20',     color: AppColors.violet,  date: 'Yesterday', time: '00:00 AM', status: 'Confirmed', fee: '0 SRX',     hash: '0xjkl...012'),
  const Tx(type: TxType.send,    title: 'Sent SNTX',            sub: 'To srx1...f3g4',    amount: '-1000 SNTX', usd: '-\$2.40',     color: AppColors.danger,  date: 'Yesterday', time: '12:10 PM', status: 'Confirmed', fee: '0.001 SRX', hash: '0xmno...345'),
  // Apr 9
  const Tx(type: TxType.receive, title: 'Received SRTX',        sub: 'From srx1...h5i6',  amount: '+100 SRTX',  usd: '+\$100.00',   color: AppColors.success, date: 'Apr 9',     time: '09:45 AM', status: 'Confirmed', fee: '0.001 SRX', hash: '0xpqr...678'),
  const Tx(type: TxType.swap,    title: 'Swapped SRTX → SRX',  sub: 'Via DEX',           amount: '-50 SRTX',   usd: '+4.8 SRX',    color: AppColors.warning, date: 'Apr 9',     time: '14:30 PM', status: 'Confirmed', fee: '0.002 SRX', hash: '0xstu...901'),
  // Apr 8
  const Tx(type: TxType.stake,   title: 'Staked SRX',           sub: 'Validator node',    amount: '-500 SRX',   usd: '-\$50.00',    color: AppColors.violet,  date: 'Apr 8',     time: '11:00 AM', status: 'Confirmed', fee: '0.001 SRX', hash: '0xvwx...234'),
];

final mockValidators = [
  const Validator(name: 'Sentrix Node 1', commission: '5%',  uptime: '99.8%', selected: true),
  const Validator(name: 'Galaxy Stake',   commission: '7%',  uptime: '99.2%', selected: false),
  const Validator(name: 'Nusantara Pool', commission: '10%', uptime: '98.5%', selected: false),
];

final mockContacts = [
  const Contact(initials: 'AH', name: 'Ahmad', address: 'srx1...a1b2', color: AppColors.success),
  const Contact(initials: 'BY', name: 'Budi',  address: 'srx1...c3d4', color: AppColors.accentCyan),
  const Contact(initials: 'RD', name: 'Rudi',  address: 'srx1...e5f6', color: AppColors.warning),
  const Contact(initials: 'SN', name: 'Sinta', address: 'srx1...g7h8', color: AppColors.violet),
  const Contact(initials: 'DW', name: 'Dewi',  address: 'srx1...i9j0', color: AppColors.pink),
];
