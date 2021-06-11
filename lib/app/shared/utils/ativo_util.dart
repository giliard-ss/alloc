import 'package:alloc/app/shared/dtos/ativo_dto.dart';

import 'geral_util.dart';

class AtivoUtil {
  static List<AtivoDTO> agruparAtivosPorPapel(List<AtivoDTO> ativos) {
    Map<String, AtivoDTO> temp = {};
    for (AtivoDTO ativo in ativos) {
      String key = ativo.papel;

      if (temp.containsKey(key)) {
        AtivoDTO ativoTemp = temp[key];
        ativoTemp.totalAplicado += ativo.totalAplicado;
        ativoTemp.qtd += ativo.qtd;
        temp[key] = ativoTemp;
      } else {
        temp[key] = ativo;
      }
    }
    return List<AtivoDTO>.from(GeralUtil.mapToList(temp));
  }
}
