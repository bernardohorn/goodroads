import 'package:flutter/material.dart';

/// Campo de texto padronizado.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.rotulo,
    this.controlador,
    this.dica,
    this.obrigatorio = false,
    this.ocultarTexto = false,
    this.validador,
    this.tipoTeclado,
    this.onChanged,
  });

  final String rotulo;
  final TextEditingController? controlador;
  final String? dica;
  final bool obrigatorio;
  final bool ocultarTexto;
  final String? Function(String?)? validador;
  final TextInputType? tipoTeclado;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: ocultarTexto,
      keyboardType: tipoTeclado,
      validator: validador,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
      ),
    );
  }
}
