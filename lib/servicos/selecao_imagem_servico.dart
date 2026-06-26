import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Tamanho máximo permitido para upload de imagens (10 MB).
const tamanhoMaximoImagemBytes = 10 * 1024 * 1024;

/// Resultado da seleção ou captura de imagem.
sealed class ResultadoSelecaoImagem {
  const ResultadoSelecaoImagem();
}

final class ImagemSelecionada extends ResultadoSelecaoImagem {
  const ImagemSelecionada(this.arquivo);

  final File arquivo;
}

final class SelecaoCancelada extends ResultadoSelecaoImagem {
  const SelecaoCancelada();
}

final class ImagemMuitoGrande extends ResultadoSelecaoImagem {
  const ImagemMuitoGrande(this.tamanhoMb);

  final double tamanhoMb;
}

final class ErroSelecaoImagem extends ResultadoSelecaoImagem {
  const ErroSelecaoImagem(this.mensagem);

  final String mensagem;
}

/// Serviço para seleção de imagens da galeria ou câmera.
abstract interface class SelecaoImagemServico {
  Future<ResultadoSelecaoImagem> selecionarDaGaleria();

  Future<ResultadoSelecaoImagem> capturarDaCamera();
}

class SelecaoImagemServicoImpl implements SelecaoImagemServico {
  SelecaoImagemServicoImpl({ImagePicker? seletor})
      : _seletor = seletor ?? ImagePicker();

  final ImagePicker _seletor;

  @override
  Future<ResultadoSelecaoImagem> selecionarDaGaleria() async {
    try {
      final imagem = await _seletor.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return _validarImagem(imagem);
    } catch (e) {
      debugPrint('[GoodRoads] Erro ao selecionar imagem da galeria: $e');
      return ErroSelecaoImagem(
        e.toString().contains('permission')
            ? 'Permissão de galeria negada. Habilite nas configurações.'
            : 'Não foi possível acessar a galeria.',
      );
    }
  }

  @override
  Future<ResultadoSelecaoImagem> capturarDaCamera() async {
    try {
      final imagem = await _seletor.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return _validarImagem(imagem);
    } catch (e) {
      debugPrint('[GoodRoads] Erro ao capturar imagem da câmera: $e');
      return ErroSelecaoImagem(
        e.toString().contains('permission') || e.toString().contains('camera')
            ? 'Permissão de câmera negada ou câmera indisponível.'
            : 'Não foi possível acessar a câmera.',
      );
    }
  }

  Future<ResultadoSelecaoImagem> _validarImagem(XFile? xFile) async {
    if (xFile == null) return const SelecaoCancelada();

    final arquivo = File(xFile.path);
    if (!arquivo.existsSync()) {
      debugPrint('[GoodRoads] Arquivo de imagem não encontrado: ${xFile.path}');
      return const ErroSelecaoImagem('Arquivo de imagem não encontrado.');
    }

    final tamanho = await arquivo.length();
    if (tamanho > tamanhoMaximoImagemBytes) {
      final tamanhoMb = tamanho / 1024 / 1024;
      debugPrint(
        '[GoodRoads] Imagem excede o limite de 10 MB '
        '(tamanho: ${tamanhoMb.toStringAsFixed(1)} MB).',
      );
      return ImagemMuitoGrande(tamanhoMb);
    }

    return ImagemSelecionada(arquivo);
  }
}
