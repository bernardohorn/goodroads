import 'package:dio/dio.dart';

/// Resumo estatístico retornado por GET /api/relatorios/resumo.
class ResumoRelatorioModelo {
  const ResumoRelatorioModelo({
    required this.porStatus,
    required this.porTipoProblema,
  });

  final List<ContagemStatusModelo> porStatus;
  final List<ContagemTipoModelo> porTipoProblema;

  factory ResumoRelatorioModelo.fromJson(Map<String, dynamic> json) {
    return ResumoRelatorioModelo(
      porStatus: (json['por_status'] as List<dynamic>)
          .map((e) => ContagemStatusModelo.fromJson(e as Map<String, dynamic>))
          .toList(),
      porTipoProblema: (json['por_tipo_problema'] as List<dynamic>)
          .map((e) => ContagemTipoModelo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  int totalGeral() =>
      porStatus.fold(0, (s, i) => s + i.quantidade);

  int contagemStatus(String status) =>
      porStatus
          .where((s) => s.status == status)
          .fold(0, (t, s) => t + s.quantidade);
}

class ContagemStatusModelo {
  const ContagemStatusModelo({required this.status, required this.quantidade});

  final String status;
  final int quantidade;

  factory ContagemStatusModelo.fromJson(Map<String, dynamic> json) {
    return ContagemStatusModelo(
      status: json['status'] as String,
      quantidade: (json['quantidade'] as num).toInt(),
    );
  }
}

class ContagemTipoModelo {
  const ContagemTipoModelo({
    required this.tipoProblema,
    required this.quantidade,
  });

  final String tipoProblema;
  final int quantidade;

  factory ContagemTipoModelo.fromJson(Map<String, dynamic> json) {
    return ContagemTipoModelo(
      tipoProblema: json['tipo_problema'] as String,
      quantidade: (json['quantidade'] as num).toInt(),
    );
  }
}

/// Fonte remota de relatórios administrativos.
class RelatoriosRemotaFonte {
  RelatoriosRemotaFonte(this._dio);

  final Dio _dio;

  Future<ResumoRelatorioModelo> obterResumo() async {
    final resposta =
        await _dio.get<Map<String, dynamic>>('/relatorios/resumo');
    return ResumoRelatorioModelo.fromJson(resposta.data!);
  }
}
