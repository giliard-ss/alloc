import 'package:alloc/app/shared/models/ativo_model.dart';

class Backup {
  static List<AtivoModel> getAllAtivos() {
    List<AtivoModel> list = [];
    list.addAll(getAcoes());
    list.addAll(getETFs());
    list.addAll(getCriptomoedas());
    list.addAll(getRendaFixa());
    list.addAll(getFiis());
    return list;
  }

  static List<AtivoModel> getAcoes() {
    List<AtivoModel> list = [];
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'ITSA3',
        'eyyokB82WciaQB1vf0C4',
        0,
        50.0,
        10.7,
        ['k4PWKm6hMYie7veqQFRC', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-04-16 00:00:00.000'),
        'ACAO',
        10.7));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BBAS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        10.0,
        29.25,
        ['k4PWKm6hMYie7veqQFRC', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        29.25));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BBAS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        10.0,
        29.8,
        ['k4PWKm6hMYie7veqQFRC', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        29.8));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'ABEV3',
        'eyyokB82WciaQB1vf0C4',
        0,
        50.0,
        11.76,
        ['5TjHx2sXD9AEdrwuBFKx', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-03-25 00:00:00.000'),
        'ACAO',
        11.76));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TIMS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        19.0,
        15.2,
        ['T9nbLYIdKku21vrOxDrK', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-08-07 00:00:00.000'),
        'ACAO',
        15.2));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TIMS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        14.0,
        13.24,
        ['T9nbLYIdKku21vrOxDrK', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        13.24));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TIMS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        14.0,
        13.4,
        ['T9nbLYIdKku21vrOxDrK', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        13.4));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TIMS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        8.0,
        13.95,
        ['T9nbLYIdKku21vrOxDrK', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        13.95));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TAEE3',
        'eyyokB82WciaQB1vf0C4',
        0,
        31.0,
        9.58,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-08-07 00:00:00.000'),
        'ACAO',
        9.58));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TAEE3',
        'eyyokB82WciaQB1vf0C4',
        0,
        4.0,
        10.96,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        10.96));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'PETR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        7.0,
        26.94,
        ['5NMj9TTPC193GF61aW9x', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        26.94));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'PETR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        25.0,
        21.7,
        ['5NMj9TTPC193GF61aW9x', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        21.7));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'PETR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        25.0,
        22.62,
        ['5NMj9TTPC193GF61aW9x', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        22.62));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'PETR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        7.0,
        27.3,
        ['5NMj9TTPC193GF61aW9x', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        27.3));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VVAR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        11.0,
        17.18,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        17.18));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VVAR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        5.0,
        16.5,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-29 00:00:00.000'),
        'ACAO',
        16.5));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VVAR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        11.0,
        17.3,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        17.3));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TOTS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        7.0,
        25.62,
        ['MNs32gjC34boutWPgvpi', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        25.62));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'TOTS3',
        'eyyokB82WciaQB1vf0C4',
        0,
        7.0,
        25.35,
        ['MNs32gjC34boutWPgvpi', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        25.35));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'GOAU3',
        'eyyokB82WciaQB1vf0C4',
        0,
        20.0,
        9.2,
        ['MunK1do0QVQxty6yksxq', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        9.2));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'GOAU3',
        'eyyokB82WciaQB1vf0C4',
        0,
        18.0,
        9.53,
        ['MunK1do0QVQxty6yksxq', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        9.53));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'GOAU3',
        'eyyokB82WciaQB1vf0C4',
        0,
        18.0,
        9.86,
        ['MunK1do0QVQxty6yksxq', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        9.86));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'GOAU3',
        'eyyokB82WciaQB1vf0C4',
        0,
        22.0,
        8.99,
        ['MunK1do0QVQxty6yksxq', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        8.99));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CSMG3',
        'eyyokB82WciaQB1vf0C4',
        0,
        16.0,
        14.56,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        14.56));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CSMG3',
        'eyyokB82WciaQB1vf0C4',
        0,
        10.0,
        14.96,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        14.96));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'MRFG3',
        'eyyokB82WciaQB1vf0C4',
        0,
        14.0,
        13.94,
        ['5TjHx2sXD9AEdrwuBFKx', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        13.94));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'MRFG3',
        'eyyokB82WciaQB1vf0C4',
        0,
        14.0,
        14.14,
        ['5TjHx2sXD9AEdrwuBFKx', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        14.14));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CAML3',
        'eyyokB82WciaQB1vf0C4',
        0,
        19.0,
        10.4,
        ['5TjHx2sXD9AEdrwuBFKx', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        10.4));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CAML3',
        'eyyokB82WciaQB1vf0C4',
        0,
        19.0,
        10.52,
        ['5TjHx2sXD9AEdrwuBFKx', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        10.52));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'GUAR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        13.0,
        13.55,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        13.55));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'GUAR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        13.0,
        13.64,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        13.64));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'COGN3',
        'eyyokB82WciaQB1vf0C4',
        0,
        66.0,
        7.49,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-08-11 00:00:00.000'),
        'ACAO',
        7.49));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'COGN3',
        'eyyokB82WciaQB1vf0C4',
        0,
        23.0,
        4.77,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-29 00:00:00.000'),
        'ACAO',
        4.77));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'COGN3',
        'eyyokB82WciaQB1vf0C4',
        0,
        8.0,
        5.15,
        ['hHTDFUbbBlBNuaGQ6pKY', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        5.15));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'POSI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        54.0,
        5.45,
        ['MNs32gjC34boutWPgvpi', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-08-10 00:00:00.000'),
        'ACAO',
        5.45));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'POSI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        15.0,
        5.11,
        ['MNs32gjC34boutWPgvpi', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-29 00:00:00.000'),
        'ACAO',
        5.11));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'POSI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        36.0,
        4.67,
        ['MNs32gjC34boutWPgvpi', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        4.67));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'POSI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        36.0,
        4.69,
        ['MNs32gjC34boutWPgvpi', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        4.69));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'POSI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        19.0,
        5.33,
        ['MNs32gjC34boutWPgvpi', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        5.33));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'ENAT3',
        'eyyokB82WciaQB1vf0C4',
        0,
        25.0,
        11.6,
        ['5NMj9TTPC193GF61aW9x', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-08-10 00:00:00.000'),
        'ACAO',
        11.6));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'ENAT3',
        'eyyokB82WciaQB1vf0C4',
        0,
        11.0,
        10.42,
        ['5NMj9TTPC193GF61aW9x', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        10.42));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'SAPR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        33.0,
        5.65,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        5.65));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'SAPR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        16.0,
        5.07,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-01-06 00:00:00.000'),
        'ACAO',
        5.07));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'SAPR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        13.0,
        5.24,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-01-05 00:00:00.000'),
        'ACAO',
        5.24));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'SAPR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        50.0,
        4.18,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        4.18));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'SAPR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        50.0,
        4.33,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        4.33));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'SAPR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        33.0,
        5.68,
        ['l8tXzxSdHbxcikLCCRTb', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        5.68));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'RANI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        37.0,
        5.15,
        ['MunK1do0QVQxty6yksxq', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        5.15));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'RANI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        26.0,
        6.04,
        ['MunK1do0QVQxty6yksxq', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        6.04));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'RANI3',
        'eyyokB82WciaQB1vf0C4',
        0,
        38.0,
        5.04,
        ['MunK1do0QVQxty6yksxq', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        5.04));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'OIBR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        87.0,
        2.19,
        ['T9nbLYIdKku21vrOxDrK', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        2.19));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'OIBR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        200.0,
        1.93,
        ['T9nbLYIdKku21vrOxDrK', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2021-02-23 00:00:00.000'),
        'ACAO',
        1.93));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'OIBR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        88.0,
        2.15,
        ['T9nbLYIdKku21vrOxDrK', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-12-03 00:00:00.000'),
        'ACAO',
        2.15));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'IRBR3',
        'eyyokB82WciaQB1vf0C4',
        0,
        62.0,
        7.98,
        ['k4PWKm6hMYie7veqQFRC', 'MVtIfLy0mMwUTR4CW2Va'],
        DateTime.parse('2020-08-12 00:00:00.000'),
        'ACAO',
        7.98));
    return list;
  }

  static List<AtivoModel> getETFs() {
    List<AtivoModel> list = [];
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'IVVB11',
        'eyyokB82WciaQB1vf0C4',
        0,
        8.0,
        204.5,
        ['VgPIXGCMypkBQiA2FODr'],
        DateTime.parse('2020-11-19 00:00:00.000'),
        'ETF',
        204.5));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'IVVB11',
        'eyyokB82WciaQB1vf0C4',
        0,
        8.0,
        208.45,
        ['VgPIXGCMypkBQiA2FODr'],
        DateTime.parse('2020-12-01 00:00:00.000'),
        'ETF',
        208.45));
    return list;
  }

  static List<AtivoModel> getCriptomoedas() {
    List<AtivoModel> list = [];
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BTC',
        'eyyokB82WciaQB1vf0C4',
        0,
        0.00171414,
        291619.46,
        ['VgPIXGCMypkBQiA2FODr'],
        DateTime.parse('2021-02-19 00:00:00.000'),
        'CRIPTO',
        291619.46));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BTC',
        'eyyokB82WciaQB1vf0C4',
        0,
        0.00205066,
        299874.18,
        ['VgPIXGCMypkBQiA2FODr'],
        DateTime.parse('2021-02-19 00:00:00.000'),
        'CRIPTO',
        299874.18));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BTC',
        'eyyokB82WciaQB1vf0C4',
        0,
        0.0001929,
        259719.19,
        ['VgPIXGCMypkBQiA2FODr'],
        DateTime.parse('2021-02-13 00:00:00.000'),
        'CRIPTO',
        259719.19));
    return list;
  }

  static List<AtivoModel> getRendaFixa() {
    List<AtivoModel> list = [];
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'RFTESTE',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        10459.74,
        ['mtj2siJwQEn1kxpcks2V'],
        DateTime.parse('2020-03-13 00:00:00.000')));
    return list;
  }

  static List<AtivoModel> getFiis() {
    List<AtivoModel> list = [];
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VISC11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        114.69,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-13 00:00:00.000'),
        'FII',
        114.69));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VISC11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        109.8,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-13 00:00:00.000'),
        'FII',
        109.8));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VISC11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        75.0,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-18 00:00:00.000'),
        'FII',
        75.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VISC11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        110.5,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-13 00:00:00.000'),
        'FII',
        110.5));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VISC11',
        'eyyokB82WciaQB1vf0C4',
        0,
        2.0,
        113.73,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-11-24 00:00:00.000'),
        'FII',
        113.73));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VISC11',
        'eyyokB82WciaQB1vf0C4',
        0,
        2.0,
        107.6,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-08-13 00:00:00.000'),
        'FII',
        107.6));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'HGBS11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        169.0,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-19 00:00:00.000'),
        'FII',
        169.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'HGBS11',
        'eyyokB82WciaQB1vf0C4',
        0,
        3.0,
        209.18,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-11-24 00:00:00.000'),
        'FII',
        209.18));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'HGBS11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        210.0,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-21 00:00:00.000'),
        'FII',
        210.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'HGBS11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        207.6,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-08-13 00:00:00.000'),
        'FII',
        207.6));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'MALL11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        94.81,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-11-24 00:00:00.000'),
        'FII',
        94.81));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'MALL11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        58.0,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-19 00:00:00.000'),
        'FII',
        58.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'MALL11',
        'eyyokB82WciaQB1vf0C4',
        0,
        5.0,
        92.6,
        ['3FE6iMLBhc1nLc42M6yq', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-22 00:00:00.000'),
        'FII',
        92.6));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BTLG11',
        'eyyokB82WciaQB1vf0C4',
        0,
        2.0,
        92.0,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-04-15 00:00:00.000'),
        'FII',
        92.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BTLG11',
        'eyyokB82WciaQB1vf0C4',
        0,
        10.0,
        107.9,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-12-21 00:00:00.000'),
        'FII',
        107.9));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BTLG11',
        'eyyokB82WciaQB1vf0C4',
        0,
        6.0,
        104.8,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-22 00:00:00.000'),
        'FII',
        104.8));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'LVBI11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        94.0,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-18 00:00:00.000'),
        'FII',
        94.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'LVBI11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        83.21,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-18 00:00:00.000'),
        'FII',
        83.21));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'LVBI11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        100.49,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-17 00:00:00.000'),
        'FII',
        100.49));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'XPLG11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        99.0,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-18 00:00:00.000'),
        'FII',
        99.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'XPLG11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        96.05,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-18 00:00:00.000'),
        'FII',
        96.05));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'XPLG11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        84.0,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-18 00:00:00.000'),
        'FII',
        84.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'XPLG11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        113.6,
        ['KLQlBUkipawLNumkVKcG', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-13 00:00:00.000'),
        'FII',
        113.6));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CVBI11',
        'eyyokB82WciaQB1vf0C4',
        0,
        5.0,
        95.9,
        ['Ew5N2FTYlLbG274jL94B', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-28 00:00:00.000'),
        'FII',
        95.9));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CVBI11',
        'eyyokB82WciaQB1vf0C4',
        0,
        7.0,
        101.65,
        ['Ew5N2FTYlLbG274jL94B', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-12-04 00:00:00.000'),
        'FII',
        101.65));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CVBI11',
        'eyyokB82WciaQB1vf0C4',
        0,
        5.0,
        95.12,
        ['Ew5N2FTYlLbG274jL94B', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-23 00:00:00.000'),
        'FII',
        95.12));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'PORD11',
        'eyyokB82WciaQB1vf0C4',
        0,
        4.0,
        99.5,
        ['Ew5N2FTYlLbG274jL94B', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-22 00:00:00.000'),
        'FII',
        99.5));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'CPFF11',
        'eyyokB82WciaQB1vf0C4',
        0,
        9.0,
        80.45,
        ['Ew5N2FTYlLbG274jL94B', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-08-13 00:00:00.000'),
        'FII',
        80.45));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BRCR11',
        'eyyokB82WciaQB1vf0C4',
        0,
        7.0,
        91.15,
        ['4CBk2h2GyFRqyo8osnXm', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-28 00:00:00.000'),
        'FII',
        91.15));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BRCR11',
        'eyyokB82WciaQB1vf0C4',
        0,
        6.0,
        87.28,
        ['4CBk2h2GyFRqyo8osnXm', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-12-02 00:00:00.000'),
        'FII',
        87.28));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'BRCR11',
        'eyyokB82WciaQB1vf0C4',
        0,
        7.0,
        91.69,
        ['4CBk2h2GyFRqyo8osnXm', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-09-23 00:00:00.000'),
        'FII',
        91.69));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'RECT11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        74.5,
        ['4CBk2h2GyFRqyo8osnXm', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-19 00:00:00.000'),
        'FII',
        74.5));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'RECT11',
        'eyyokB82WciaQB1vf0C4',
        0,
        10.0,
        97.0,
        ['4CBk2h2GyFRqyo8osnXm', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-08-13 00:00:00.000'),
        'FII',
        97.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'HGRE11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        136.66,
        ['rm7Ef8nExmcJ0M4P1NR9', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-20 00:00:00.000'),
        'FII',
        136.66));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'HGRE11',
        'eyyokB82WciaQB1vf0C4',
        0,
        8.0,
        150.37,
        ['rm7Ef8nExmcJ0M4P1NR9', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-11-26 00:00:00.000'),
        'FII',
        150.37));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'HGRE11',
        'eyyokB82WciaQB1vf0C4',
        0,
        5.0,
        143.08,
        ['rm7Ef8nExmcJ0M4P1NR9', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-04-16 00:00:00.000'),
        'FII',
        143.08));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VINO11',
        'eyyokB82WciaQB1vf0C4',
        0,
        3.0,
        51.0,
        ['rm7Ef8nExmcJ0M4P1NR9', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-05-27 00:00:00.000'),
        'FII',
        51.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'RCRB11',
        'eyyokB82WciaQB1vf0C4',
        0,
        1.0,
        119.0,
        ['rm7Ef8nExmcJ0M4P1NR9', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-03-19 00:00:00.000'),
        'FII',
        119.0));
    list.add(AtivoModel(
        null,
        '5r0iVHL3Tmby4h5rh1YW',
        'VINO11',
        'eyyokB82WciaQB1vf0C4',
        0,
        5.0,
        51.0,
        ['rm7Ef8nExmcJ0M4P1NR9', 'nx7S0bxHXQQSeCBICLZZ'],
        DateTime.parse('2020-05-28 00:00:00.000'),
        'FII',
        51.0));
    return list;
  }
}
