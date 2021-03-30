import 'package:alloc/app/app_core.dart';
import 'package:alloc/app/modules/carteira/backup.dart';
import 'package:alloc/app/modules/carteira/backup_model.dart';
import 'package:alloc/app/modules/carteira/carteira_controller.dart';
import 'package:alloc/app/shared/dtos/alocacao_dto.dart';
import 'package:alloc/app/shared/dtos/ativo_dto.dart';
import 'package:alloc/app/shared/enums/tipo_ativo_enum.dart';
import 'package:alloc/app/shared/exceptions/application_exception.dart';
import 'package:alloc/app/shared/models/abstract_event.dart';
import 'package:alloc/app/shared/models/ativo_model.dart';
import 'package:alloc/app/shared/models/evento_aplicacao_renda_variavel.dart';
import 'package:alloc/app/shared/services/ativo_service.dart';
import 'package:alloc/app/shared/services/event_service.dart';
import 'package:alloc/app/shared/utils/logger_util.dart';
import 'package:alloc/app/shared/utils/string_util.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'ativo_controller.g.dart';

@Injectable()
class AtivoController = _AtivoControllerBase with _$AtivoController;

abstract class _AtivoControllerBase with Store {
  CarteiraController _carteiraController = Modular.get();
  AlocacaoDTO _alocacaoAtual;
  IEventService _eventService = Modular.get<EventService>();
  IAtivoService _ativoService = Modular.get<AtivoService>();

  @observable
  String error = "";

  DateTime data = DateTime.now();
  @observable
  String papel;
  double qtd;
  double preco;

  @action
  Future<bool> comprar() async {
    try {
      if (!papelValido) {
        error = "Papel não encontrado.";
        return false;
      }

      if (preco == 0 || preco == null) {
        error = "Informe a cotação!";
        return false;
      }

      AbstractEvent aplicacaoEvent = createEventAplicacaoRendaVariavel();
      await _eventService.saveAplicacaoRendaVariavel(aplicacaoEvent);
      await AppCore.notifyAddDelAtivo();
      return true;
    } on ApplicationException catch (e) {
      error = e.toString();
    } catch (e) {
      error = "Falha ao finalizar compra!";
      LoggerUtil.error(e);
    }
    return false;
  }

  AbstractEvent createEventAplicacaoRendaVariavel() {
    return AplicacaoRendaVariavel.acao(null, DateTime.now(), _carteiraController.carteira.id,
        AppCore.usuario.id, preco * qtd, getIdSuperiores(), papel, qtd);
  }

  String getTipo(String papel) {
    if (allAcoes().where((e) => e == papel).isNotEmpty) return TipoAtivo.ACAO.code;
    if (allFiis().where((e) => e == papel).isNotEmpty) return TipoAtivo.FIIS.code;
    if (allETFsBR().where((e) => e == papel).isNotEmpty) return TipoAtivo.ETF.code;
    throw ApplicationException("Tipo não encontrado.");
  }

  @computed
  bool get papelValido {
    return AppCore.allPapeis.where((e) => e == papel).isNotEmpty;
  }

  @action
  void setPapel(String papel) {
    this.papel = papel;
  }

  List<String> getSugestoes(String text) {
    if (text.trim().isEmpty || text.trim().length < 2) return null;
    return AppCore.allPapeis
        .where((e) => e.toUpperCase().indexOf(text.trim().toUpperCase()) >= 0)
        .toList();
  }

  List<String> getIdSuperiores() {
    if (_alocacaoAtual != null) {
      List<String> result = [_alocacaoAtual.id];

      AlocacaoDTO superior = _alocacaoAtual;
      while (superior != null) {
        if (StringUtil.isEmpty(superior.idSuperior)) {
          break;
        } else {
          result.add(superior.idSuperior);
          superior = _getAlocacaoDTO(superior.idSuperior);
        }
      }
      return result;
    } else {
      return [];
    }
  }

  @action
  Future<bool> vender() async {
    try {
      //List<AtivoModel> list = Backup.getAllAtivos();

      //_ativoService.save(list, true);

      //AppCore.allAtivos.forEach((e) => _ativoService.delete(e, [], false));
      //await _excluirTodosAtivos();
      //await _restaurarBackup();
      //await AppCore.notifyAddDelAtivo();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  _excluirTodosAtivos() async {
    for (AtivoDTO ativo in AppCore.allAtivos) await _ativoService.delete(ativo, [], false);
    return AppCore.notifyAddDelAtivo();
  }

  _restaurarBackup() async {
    List<BackupModel> list = Backup.getAllAtivos();
    List<AplicacaoRendaVariavel> variaveis = [];

    list.where((e) => e.tipo == "ACAO").forEach((backup) {
      AplicacaoRendaVariavel aplicacao = AplicacaoRendaVariavel.acao(
          null,
          backup.data,
          backup.idCarteira,
          backup.idUsuario,
          backup.preco * backup.qtd,
          backup.superiores,
          backup.papel,
          backup.qtd);
      variaveis.add(aplicacao);
    });

    list.where((e) => e.tipo == "FII").forEach((backup) {
      AplicacaoRendaVariavel aplicacao = AplicacaoRendaVariavel.fiis(
          null,
          backup.data,
          backup.idCarteira,
          backup.idUsuario,
          backup.preco * backup.qtd,
          backup.superiores,
          backup.papel,
          backup.qtd);
      variaveis.add(aplicacao);
    });

    // list.where((e) => e.tipo == "ETF").forEach((backup) {
    //   AplicacaoRendaVariavel aplicacao = AplicacaoRendaVariavel.etf(
    //       null,
    //       backup.data,
    //       backup.idCarteira,
    //       backup.idUsuario,
    //       backup.preco * backup.qtd,
    //       backup.superiores,
    //       backup.papel,
    //       backup.qtd);
    //   variaveis.add(aplicacao);
    // });

    // for (AplicacaoRendaVariavel ap in variaveis) {
    //   if (ap.superiores == null || ap.superiores == []) {
    //     await _eventService.saveNovaAplicacaoVariavelFromCarteira(ap, ap.carteiraId, false);
    //   } else {
    //     await _eventService.saveNovaAplicacaoVariavelFromAlocacao(ap, ap.superiores[0], false);
    //   }
    // }
    // return AppCore.notifyAddDelAtivo();
  }

  AlocacaoDTO _getAlocacaoDTO(String id) {
    return AppCore.getAlocacaoById(id);
  }

  void setAlocacaoAtual(String idAlocacao) {
    if (!StringUtil.isEmpty(idAlocacao)) {
      _alocacaoAtual = _getAlocacaoDTO(idAlocacao);
    }
  }

  List<String> allETFsBR() {
    return [
      'BBSD11',
      'XBOV11',
      'IVVB11',
      'BOVA11',
      'BRAX11',
      'ECOO11',
      'SMAL11',
      'BOVV1 ',
      'DIVO11',
      'FIND11',
      'FIXA11',
      'GOVE11',
      'IMAB11',
      'MATB11',
      'ISUS11',
      'PIBB11',
      'SPXI11',
    ];
  }

  List<String> allFiis() {
    return [
      'CXCO11',
      'GTWR11',
      'HCST11',
      'HMOC11',
      'HREC11',
      'HUSC11',
      'IFIE11',
      'MALL11',
      'MGHT11',
      'MORE11',
      'CNES11',
      'FAED11',
      'HBRH11',
      'HCRI11',
      'HCTR11',
      'HSLG11',
      'HTMX11',
      'IBFF11',
      'CTXT11',
      'CVBI11',
      'CXCE11B',
      'DEVA11',
      'FATN11',
      'FCFL11',
      'FMOF11',
      'MVFI11',
      'BRHT11B',
      'BPFF11',
      'BPML11',
      'BRCO11',
      'BRCR11',
      'BREV11',
      'BRIP11',
      'DLMT11',
      'EVBI11',
      'GCRI11',
      'BRLA11',
      'CXRI11',
      'FAMB11B',
      'FEXC11',
      'FLMA11',
      'GESE11B',
      'HBCR11',
      'HFOF11',
      'HUSI11',
      'JBFO11',
      'TFOF11',
      'FOFT11',
      'JFLL11',
      'JRDM11',
      'KEVE11',
      'KISU11',
      'KNIP11',
      'KNSC11',
      'LOFT11B',
      'ONEF11',
      'ORPD11',
      'OUFF11',
      'OUJP11',
      'OULG11',
      'AFOF11',
      'EGYR11',
      'RBHY11',
      'RBIR11',
      'RVBI11',
      'SEQR11',
      'TEPP11',
      'RECT11',
      'RELG11',
      'RMAI11',
      'RRCI11',
      'SOLR11',
      'TBOF11',
      'ALZR11',
      'ATWN11',
      'BCIA11',
      'CJFI11',
      'BCRI11',
      'HGBS11',
      'HGCR11',
      'HOSI11',
      'BTWR11',
      'BBFO11',
      'DMAC11',
      'DOMC11',
      'BBPO11',
      'BBRC11',
      'BCFF11',
      'BICR11',
      'MGCR11',
      'BLMG11',
      'BLMR11',
      'FIGS11',
      'FIIB11',
      'FLCR11',
      'FLRP11',
      'BTAL11',
      'BTCR11',
      'BTSG11',
      'CARE11',
      'CEOC11',
      'CJCT11',
      'HBTT11',
      'HGIC11',
      'ELDO11B',
      'LVBI11',
      'ERCR11',
      'ESTQ11',
      'MTOF11',
      'PNDL11',
      'GGRC11',
      'GSFI11',
      'NCHB11',
      'PATL11',
      'RBRM11',
      'RBRS11',
      'RBRY11',
      'RCRB11',
      'RCRI11B',
      'RSPD11',
      'MINT11',
      'MOFF11',
      'REIT11',
      'PATB11',
      'PORD11',
      'PQAG11',
      'PQDP11',
      'PRTS11',
      'RBBV11',
      'RBCB11',
      'RBED11',
      'RBFF11',
      'RBGS11',
      'RBLG11',
      'RBRR11',
      'TCIN11',
      'VINO11',
      'VISC11',
      'AFCR11',
      'AIEC11',
      'ANCR11B',
      'RDPD11',
      'RECR11',
      'VSHO11',
      'VSLH11',
      'VTPA11',
      'VTPL11',
      'VTVI11',
      'VTXI11',
      'AQLL11',
      'RZAK11',
      'SALI11',
      'SHDP11B',
      'SJAU11',
      'TGAR11',
      'TORD11',
      'TRNT11',
      'VIDS11',
      'VVPR11',
      'VXXV11',
      'WPLZ11',
      'YUFI11',
      'ZIFI11',
      'CPTS11',
      'FPAB11',
      'FVPQ11',
      'GALG11',
      'HAAA11',
      'HSRE11',
      'FINF11',
      'FISD11',
      'LUGG11',
      'URPR11',
      'VERE11',
      'VGIP11',
      'VGIR11',
      'VIFI11',
      'VILG11',
      'DAMT11B',
      'STRX11',
      'HPDP11',
      'HRDF11',
      'HSAF11',
      'HSML11',
      'IRDM11',
      'RBCO11',
      'RBDS11',
      'ARCT11',
      'ATCR11',
      'BBFI11B',
      'BBIM11',
      'DOVL11B',
      'FISC11',
      'HGLG11',
      'HGPO11',
      'HGRE11',
      'LATR11B',
      'PABY11',
      'PATC11',
      'PVBI11',
      'QAGR11',
      'QIFF11',
      'SPVJ11',
      'VSEC11',
      'VTLT11',
      'BMII11',
      'BVAR11',
      'LFTT11',
      'MAXR11',
      'MBRF11',
      'MCCI11',
      'RZTR11',
      'VOTS11',
      'VRTA11',
      'XPCI11',
      'XPCM11',
      'XPHT11',
      'CXTL11',
      'FCAS11',
      'RFOF11',
      'RNDP11',
      'SADI11',
      'SAIC11B',
      'BLCP11',
      'BTLG11',
      'HGFF11',
      'HGRU11',
      'HLOG11',
      'LASC11',
      'LGCP11',
      'RBIV11',
      'RBRD11',
      'RBRF11',
      'RBRL11',
      'RBRP11',
      'SHOP11',
      'VLJS11',
      'VLOL11',
      'WTSP11B',
      'CBOP11',
      'FPNG11',
      'PBLV11',
      'SARE11',
      'ARFI11B',
      'BZLI11',
      'KINP11',
      'KNCR11',
      'KNHY11',
      'MFAI11',
      'MFII11',
      'MGFF11',
      'NVHO11',
      'NVIF11B',
      'SFND11',
      'SHPH11',
      'SPAF11',
      'TRXB11',
      'TRXF11',
      'TSNC11',
      'MXRF11',
      'TOUR11',
      'ATSA11',
      'KNRI11',
      'SPTW11',
      'EDGA11',
      'FIIP11B',
      'FIVN11',
      'BMLC11',
      'BNFS11',
      'RCFF11',
      'TCPF11',
      'EDFO11B',
      'GRLV11',
      'PLRI11',
      'ABCP11',
      'JPPA11',
      'JPPC11',
      'KNRE11',
      'OURE11',
      'PLCR11',
      'ARRI11',
      'BARI11',
      'DRIT11B',
      'FTCE11B',
      'FVBI11',
      'GCFF11',
      'BRIM11',
      'HABT11',
      'CFHI11',
      'ERPA11',
      'PRSN11B',
      'PRSV11',
      'SCPF11',
      'SDIL11',
      'BPRP11',
      'RNGO11',
      'THRA11',
      'TORM13',
      'VCJR11',
      'CRFF11',
      'EURO11',
      'BLMO11',
      'JSRE11',
      'JTPR11',
      'KFOF11',
      'NEWL11',
      'NEWU11',
      'NPAR11',
      'NSLU11',
      'RBTS11',
      'RBVA11',
      'RBVO11',
      'RCFA11',
      'ALMI11',
      'CPFF11',
      'VPSI11',
      'XPHT12',
      'XPIN11',
      'XPLG11',
      'XPML11',
      'XPPR11',
      'XPSF11',
      'XTED11',
    ];
  }

  List<String> allAcoes() {
    return [
      'AALR3',
      'ABCB4',
      'ABEV3',
      'ADHM3',
      'AERI3',
      'AFLT3',
      'AGRO3',
      'AHEB3',
      'AHEB5',
      'AHEB6',
      'ALPA3',
      'ALPA4',
      'ALPK3',
      'ALSO3',
      'ALUP11',
      'ALUP3',
      'ALUP4',
      'AMAR3',
      'AMBP3',
      'ANDG3B',
      'ANDG4B',
      'ANIM3',
      'APER3',
      'APTI3',
      'APTI4',
      'ARZZ3',
      'ASAI3',
      'ATMP3',
      'ATOM3',
      'AURA33',
      'AVLL3',
      'AZEV3',
      'AZEV4',
      'AZUL4',
      'B3SA3',
      'BAHI3',
      'BALM3',
      'BALM4',
      'BAUH4',
      'BAZA3',
      'BBAS3',
      'BBDC3',
      'BBDC4',
      'BBML3',
      'BBRK3',
      'BBSE3',
      'BDLL3',
      'BDLL4',
      'BEEF3',
      'BEES3',
      'BEES4',
      'BFRE11',
      'BFRE12',
      'BGIP3',
      'BGIP4',
      'BIDI11',
      'BIDI3',
      'BIDI4',
      'BIOM3',
      'BKBR3',
      'BMEB3',
      'BMEB4',
      'BMGB4',
      'BMIN3',
      'BMIN4',
      'BMKS3',
      'BMOB3',
      'BNBR3',
      'BOAS3',
      'BOBR3',
      'BOBR4',
      'BPAC11',
      'BPAC3',
      'BPAC5',
      'BPAN4',
      'BPAR3',
      'BPAT33',
      'BPHA3',
      'BRAP3',
      'BRAP4',
      'BRDT3',
      'BRFS3',
      'BRGE11',
      'BRGE12',
      'BRGE3',
      'BRGE5',
      'BRGE6',
      'BRGE7',
      'BRGE8',
      'BRIV3',
      'BRIV4',
      'BRKM3',
      'BRKM5',
      'BRKM6',
      'BRML3',
      'BRPR3',
      'BRQB3',
      'BRSR3',
      'BRSR5',
      'BRSR6',
      'BSEV3',
      'BSLI3',
      'BSLI4',
      'BTOW3',
      'BTTL3',
      'BTTL4',
      'CALI3',
      'CALI4',
      'CAMB3',
      'CAMB4',
      'CAML3',
      'CARD3',
      'CASH3',
      'CASN3',
      'CASN4',
      'CATA3',
      'CATA4',
      'CBEE3',
      'CCPR3',
      'CCRO3',
      'CCXC3',
      'CEAB3',
      'CEBR3',
      'CEBR5',
      'CEBR6',
      'CEDO3',
      'CEDO4',
      'CEEB3',
      'CEEB5',
      'CEEB6',
      'CEED3',
      'CEED4',
      'CEGR3',
      'CEPE3',
      'CEPE5',
      'CEPE6',
      'CESP3',
      'CESP5',
      'CESP6',
      'CGAS3',
      'CGAS5',
      'CGRA3',
      'CGRA4',
      'CIEL3',
      'CLSC3',
      'CLSC4',
      'CMIG3',
      'CMIG4',
      'CMIN3',
      'CMSA3',
      'CMSA4',
      'CNSY3',
      'CNTO3',
      'COCE3',
      'COCE5',
      'COCE6',
      'COGN3',
      'CORR3',
      'CORR4',
      'CPFE3',
      'CPLE3',
      'CPLE5',
      'CPLE6',
      'CPRE3',
      'CRDE3',
      'CREM3',
      'CRFB3',
      'CRIV3',
      'CRIV4',
      'CRPG3',
      'CRPG5',
      'CRPG6',
      'CSAB3',
      'CSAB4',
      'CSAN3',
      'CSED3',
      'CSMG3',
      'CSNA3',
      'CSRN3',
      'CSRN5',
      'CSRN6',
      'CTCA3',
      'CTKA3',
      'CTKA4',
      'CTNM3',
      'CTNM4',
      'CTSA3',
      'CTSA4',
      'CTSA8',
      'CURY3',
      'CVCB3',
      'CYRE3',
      'DASA3',
      'DIRR3',
      'DMMO3',
      'DMVF3',
      'DOHL3',
      'DOHL4',
      'DTCY3',
      'DTCY4',
      'DTEX3',
      'EALT3',
      'EALT4',
      'ECOR3',
      'ECPR3',
      'ECPR4',
      'EEEL3',
      'EEEL4',
      'EGIE3',
      'EKTR3',
      'EKTR4',
      'ELEK3',
      'ELEK4',
      'ELET3',
      'ELET5',
      'ELET6',
      'ELMD3',
      'ELPL3',
      'EMAE3',
      'EMAE4',
      'EMBR3',
      'ENAT3',
      'ENBR3',
      'ENEV3',
      'ENGI11',
      'ENGI3',
      'ENGI4',
      'ENJU3',
      'ENMA3B',
      'ENMA6B',
      'ENMT3',
      'ENMT4',
      'EQPA3',
      'EQPA5',
      'EQPA6',
      'EQPA7',
      'EQTL3',
      'ESPA3',
      'ESTR3',
      'ESTR4',
      'ETER3',
      'EUCA3',
      'EUCA4',
      'EVEN3',
      'EZTC3',
      'FBMC3',
      'FBMC4',
      'FESA3',
      'FESA4',
      'FHER3',
      'FIGE3',
      'FIGE4',
      'FLEX3',
      'FLRY3',
      'FNCN3',
      'FRAS3',
      'FRIO3',
      'FRTA3',
      'FTRT3B',
      'GBIO33',
      'GEPA3',
      'GEPA4',
      'GFSA3',
      'GGBR3',
      'GGBR4',
      'GMAT3',
      'GNDI3',
      'GOAU3',
      'GOAU4',
      'GOLL4',
      'GPAR3',
      'GPCP3',
      'GPCP4',
      'GPIV33',
      'GRND3',
      'GSHP3',
      'GUAR3',
      'HAGA3',
      'HAGA4',
      'HAPV3',
      'HBOR3',
      'HBRE3',
      'HBSA3',
      'HBTS5',
      'HETA3',
      'HETA4',
      'HGTX3',
      'HOOT3',
      'HOOT4',
      'HYPE3',
      'IDVL3',
      'IDVL4',
      'IGBR3',
      'IGSN3',
      'IGTA3',
      'INEP3',
      'INEP4',
      'INNT3',
      'INTB3',
      'IRBR3',
      'ITEC3',
      'ITSA3',
      'ITSA4',
      'ITUB3',
      'ITUB4',
      'JALL3',
      'JBDU3',
      'JBDU4',
      'JBSS3',
      'JFEN3',
      'JHSF3',
      'JOPA3',
      'JOPA4',
      'JPSA3',
      'JSLG3',
      'KEPL3',
      'KLBN11',
      'KLBN3',
      'KLBN4',
      'LAME3',
      'LAME4',
      'LAVV3',
      'LCAM3',
      'LEVE3',
      'LHER3',
      'LHER4',
      'LIGT3',
      'LINX3',
      'LIPR3',
      'LJQQ3',
      'LLIS3',
      'LOGG3',
      'LOGN3',
      'LPSB3',
      'LREN3',
      'LTEL3B',
      'LUPA3',
      'LUXM3',
      'LUXM4',
      'LWSA3',
      'MAPT3',
      'MAPT4',
      'MBLY3',
      'MDIA3',
      'MDNE3',
      'MEAL3',
      'MELK3',
      'MERC3',
      'MERC4',
      'MGEL3',
      'MGEL4',
      'MGLU3',
      'MILS3',
      'MMAQ3',
      'MMAQ4',
      'MMXM3',
      'MNDL3',
      'MNPR3',
      'MOAR3',
      'MOSI3',
      'MOVI3',
      'MRFG3',
      'MRSA3B',
      'MRSA5B',
      'MRSA6B',
      'MRVE3',
      'MSPA3',
      'MSPA4',
      'MSRO3',
      'MTIG3',
      'MTIG4',
      'MTRE3',
      'MTSA3',
      'MTSA4',
      'MULT3',
      'MWET3',
      'MWET4',
      'MYPK3',
      'NAFG3',
      'NAFG4',
      'NEMO3',
      'NEMO5',
      'NEMO6',
      'NEOE3',
      'NGRD3',
      'NORD3',
      'NRTQ3',
      'NTCO3',
      'NUTR3',
      'ODER4',
      'ODPV3',
      'OFSA3',
      'OGXP3',
      'OIBR3',
      'OIBR4',
      'OMGE3',
      'OPCT3',
      'ORVR3',
      'OSXB3',
      'PARD3',
      'PATI3',
      'PATI4',
      'PCAR3',
      'PCAR4',
      'PDGR3',
      'PDTC3',
      'PEAB3',
      'PEAB4',
      'PETR3',
      'PETR4',
      'PETZ3',
      'PFRM3',
      'PGMN3',
      'PINE3',
      'PINE4',
      'PLAS3',
      'PLPL3',
      'PMAM3',
      'PNVL3',
      'PNVL4',
      'POMO3',
      'POMO4',
      'POSI3',
      'POWE3',
      'PPAR3',
      'PPLA11',
      'PRIO3',
      'PRNR3',
      'PSSA3',
      'PTBL3',
      'PTCA11',
      'PTCA3',
      'PTNT3',
      'PTNT4',
      'QUAL3',
      'QUSW3',
      'QVQP3B',
      'RADL3',
      'RAIL3',
      'RANI3',
      'RANI4',
      'RAPT3',
      'RAPT4',
      'RCSL3',
      'RCSL4',
      'RDNI3',
      'RDOR3',
      'REDE3',
      'RENT3',
      'RLOG3',
      'RNEW11',
      'RNEW3',
      'RNEW4',
      'ROMI3',
      'RPAD3',
      'RPAD5',
      'RPAD6',
      'RPMG3',
      'RRRP3',
      'RSID3',
      'RSUL3',
      'RSUL4',
      'SANB11',
      'SANB3',
      'SANB4',
      'SAPR11',
      'SAPR3',
      'SAPR4',
      'SBSP3',
      'SCAR3',
      'SEDU3',
      'SEER3',
      'SEQL3',
      'SGPS3',
      'SHOW3',
      'SHUL3',
      'SHUL4',
      'SIMH3',
      'SLCE3',
      'SLED3',
      'SLED4',
      'SMFT3',
      'SMLS3',
      'SMTO3',
      'SNSY3',
      'SNSY5',
      'SNSY6',
      'SOMA3',
      'SOND3',
      'SOND5',
      'SOND6',
      'SPRI3',
      'SPRI5',
      'SPRI6',
      'SPRT3B',
      'SQIA3',
      'STBP3',
      'STKF3',
      'STTR3',
      'SULA11',
      'SULA3',
      'SULA4',
      'SUZB3',
      'TAEE11',
      'TAEE3',
      'TAEE4',
      'TASA3',
      'TASA4',
      'TCNO3',
      'TCNO4',
      'TCSA3',
      'TECN3',
      'TEKA3',
      'TEKA4',
      'TELB3',
      'TELB4',
      'TEND3',
      'TESA3',
      'TFCO4',
      'TGMA3',
      'TIET11',
      'TIET3',
      'TIET4',
      'TIMS3',
      'TKNO3',
      'TKNO4',
      'TOTS3',
      'TOYB3',
      'TOYB4',
      'TPIS3',
      'TRIS3',
      'TRPL3',
      'TRPL4',
      'TUPY3',
      'TXRX3',
      'TXRX4',
      'UCAS3',
      'UGPA3',
      'UNIP3',
      'UNIP5',
      'UNIP6',
      'USIM3',
      'USIM5',
      'USIM6',
      'VALE3',
      'VAMO3',
      'VIVA3',
      'VIVR3',
      'VIVT3',
      'VIVT4',
      'VLID3',
      'VSPT3',
      'VSPT4',
      'VULC3',
      'VVAR3',
      'WEGE3',
      'WEST3',
      'WHRL3',
      'WHRL4',
      'WIZS3',
      'WLMM3',
      'WLMM4',
      'WSON33',
      'YDUQ3',
    ];
  }
}
