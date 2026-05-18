import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// Serviço para seleção de imagens da galeria ou câmera.
abstract interface class SelecaoImagemServico {
  Future<File?> selecionarDaGaleria();

  Future<File?> capturarDaCamera();
}

class SelecaoImagemServicoImpl implements SelecaoImagemServico {
  SelecaoImagemServicoImpl({ImagePicker? seletor})
      : _seletor = seletor ?? ImagePicker();

  final ImagePicker _seletor;

  @override
  Future<File?> selecionarDaGaleria() async {
    final imagem = await _seletor.pickImage(source: ImageSource.gallery);
    return imagem != null ? File(imagem.path) : null;
  }

  @override
  Future<File?> capturarDaCamera() async {
    final imagem = await _seletor.pickImage(source: ImageSource.camera);
    return imagem != null ? File(imagem.path) : null;
  }
}
