import 'package:dio/dio.dart';

import '../../../../compartilhado/modelos/resultado.dart';
import '../../../../nucleo/erros/falha.dart';
import '../../dominio/entidades/ocorrencia_entidade.dart';
import '../../dominio/repositorios/ocorrencias_repositorio.dart';
import '../fontes_dados/ocorrencias_remota_fonte.dart';
import '../modelos/ocorrencia_modelo.dart';

/// Implementação do repositório de ocorrências conectada à API REST.
class OcorrenciasRepositorioImpl implements OcorrenciasRepositorio {
  OcorrenciasRepositorioImpl({required OcorrenciasRemotaFonte remota})
      : _remota = remota;

  final OcorrenciasRemotaFonte _remota;

  @override
  Future<Resultado<List<OcorrenciaEntidade>>> listar() async {
    try {
      final modelos = await _remota.listar();
      return Sucesso(modelos.map((m) => m.toEntidade()).toList());
    } on DioException catch (e) {
      return Erro(_mapearErroDio(e));
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }

  Future<Resultado<List<OcorrenciaEntidade>>> listarProximas({
    required double latitude,
    required double longitude,
    double raioKm = 10,
  }) async {
    try {
      final modelos = await _remota.listarProximas(
        latitude: latitude,
        longitude: longitude,
        raioKm: raioKm,
      );
      return Sucesso(modelos.map((m) => m.toEntidade()).toList());
    } on DioException catch (e) {
      return Erro(_mapearErroDio(e));
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }

  @override
  Future<Resultado<OcorrenciaEntidade>> obterPorId(String id) async {
    try {
      final modelo = await _remota.obterPorId(id);
      return Sucesso(modelo.toEntidade());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Erro(FalhaDesconhecida('Ocorrência não encontrada.'));
      }
      return Erro(_mapearErroDio(e));
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }

  @override
  Future<Resultado<OcorrenciaEntidade>> criar(
    OcorrenciaEntidade ocorrencia,
  ) async {
    try {
      final modelo = OcorrenciaModelo(
        id: ocorrencia.id,
        titulo: ocorrencia.titulo,
        descricao: ocorrencia.descricao,
        latitude: ocorrencia.latitude,
        longitude: ocorrencia.longitude,
        status: ocorrencia.status,
        criadoEm: ocorrencia.criadoEm,
        tipoProblema: ocorrencia.tipoProblema,
        urgencia: ocorrencia.urgencia,
        municipio: ocorrencia.municipio,
      );
      final criado = await _remota.criar(modelo);
      return Sucesso(criado.toEntidade());
    } on DioException catch (e) {
      return Erro(_mapearErroDio(e));
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }

  @override
  Future<Resultado<OcorrenciaEntidade>> atualizar(
    OcorrenciaEntidade ocorrencia, {
    String? observacao,
  }) async {
    try {
      final atualizado = await _remota.atualizarStatus(
        id: ocorrencia.id,
        status: ocorrencia.status,
        observacao: observacao,
      );
      return Sucesso(atualizado.toEntidade());
    } on DioException catch (e) {
      return Erro(_mapearErroDio(e));
    } catch (_) {
      return const Erro(FalhaDesconhecida());
    }
  }

  Falha _mapearErroDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const FalhaRede();
    }
    final mensagem = e.response?.data;
    if (mensagem is Map && mensagem['erro'] is String) {
      return FalhaDesconhecida(mensagem['erro'] as String);
    }
    final codigo = e.response?.statusCode;
    if (codigo == 401) {
      return const FalhaTokenExpirado();
    }
    if (codigo != null && codigo >= 500) {
      return const FalhaServidor();
    }
    return const FalhaDesconhecida();
  }
}
