import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/token.dart';
import '../models/transaction.dart';
import '../models/validator.dart';
import '../models/contact.dart';

final tokensProvider = Provider<List<Token>>((ref) => mockTokens);
final txsProvider    = Provider<List<Tx>>((ref) => mockTxs);
final validatorsProvider = StateProvider<List<Validator>>((ref) => mockValidators);
final contactsProvider   = Provider<List<Contact>>((ref) => mockContacts);

final totalUsdProvider = Provider<double>((ref) => mockTotalUsd);
final totalSrxProvider = Provider<double>((ref) => mockTotalSrx);
final addressProvider  = Provider<String>((ref) => mockAddress);

final balanceHiddenProvider = StateProvider<bool>((ref) => false);
