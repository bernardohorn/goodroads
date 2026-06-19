import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/botao_primario.dart';
import '../../../../compartilhado/widgets/campo_texto.dart';
import '../../../../nucleo/utilitarios/formatador_cpf.dart';
import '../../../../nucleo/utilitarios/validador.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../providers/autenticacao_provider.dart';

/// Página de registro de novo usuário.
class RegistroPagina extends ConsumerStatefulWidget {
  const RegistroPagina({super.key});

  @override
  ConsumerState<RegistroPagina> createState() => _RegistroPaginaState();
}

class _RegistroPaginaState extends ConsumerState<RegistroPagina> {
  final _formulario = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _dataNascCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarSenhaCtrl = TextEditingController();
  bool _aceitouTermos = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _cpfCtrl.dispose();
    _dataNascCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmarSenhaCtrl.dispose();
    super.dispose();
  }

  bool get _formularioValido =>
      _aceitouTermos &&
      _nomeCtrl.text.trim().isNotEmpty &&
      _cpfCtrl.text.trim().isNotEmpty &&
      _dataNascCtrl.text.trim().isNotEmpty &&
      _emailCtrl.text.trim().isNotEmpty &&
      _senhaCtrl.text.length >= 6 &&
      _confirmarSenhaCtrl.text == _senhaCtrl.text;

  Future<void> _registrar() async {
    if (!_formulario.currentState!.validate()) return;
    if (!_aceitouTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aceite os termos de uso para continuar.')),
      );
      return;
    }

    await ref.read(autenticacaoControladorProvider.notifier).registrar(
          nome: _nomeCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          senha: _senhaCtrl.text,
          cpf: FormatadorCpf.somenteDigitos(_cpfCtrl.text),
          dataNascimento: _dataNascCtrl.text.trim(),
        );

    if (ref.read(sessaoAutenticadaProvider) && mounted) {
      context.go(RotasNomes.inicio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final autenticacao = ref.watch(autenticacaoControladorProvider);

    ref.listen(autenticacaoControladorProvider, (_, proximo) {
      if (proximo.hasError && !proximo.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(proximo.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CampoTexto(
                  rotulo: 'Nome completo',
                  controlador: _nomeCtrl,
                  obrigatorio: true,
                  validador: (v) => Validador.obrigatorio(v, campo: 'Nome'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cpfCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                    _MascaraCpfFormatter(),
                  ],
                  decoration: const InputDecoration(labelText: 'CPF'),
                  validator: Validador.cpf,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dataNascCtrl,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                    LengthLimitingTextInputFormatter(10),
                    _MascaraDataFormatter(),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Data de nascimento',
                    hintText: 'dd/mm/aaaa',
                  ),
                  validator: Validador.dataNascimento,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                CampoTexto(
                  rotulo: 'E-mail',
                  controlador: _emailCtrl,
                  tipoTeclado: TextInputType.emailAddress,
                  validador: Validador.email,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                CampoTexto(
                  rotulo: 'Senha',
                  controlador: _senhaCtrl,
                  ocultarTexto: true,
                  validador: Validador.senha,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                CampoTexto(
                  rotulo: 'Confirmar senha',
                  controlador: _confirmarSenhaCtrl,
                  ocultarTexto: true,
                  validador: (v) =>
                      Validador.confirmarSenha(v, _senhaCtrl.text),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _aceitouTermos,
                  onChanged: (v) => setState(() => _aceitouTermos = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Concordo com os termos de uso'),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Text(
                    'CPF e data de nascimento são armazenados localmente. '
                    'O backend ainda não persiste esses campos (requer migration).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 24),
                BotaoPrimario(
                  rotulo: 'Criar conta',
                  carregando: autenticacao.isLoading,
                  aoPressionar: _formularioValido ? _registrar : null,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go(RotasNomes.login),
                  child: const Text('Já tenho conta — Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MascaraCpfFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final texto = FormatadorCpf.aplicarMascara(newValue.text);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class _MascaraDataFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digitos.length && i < 8; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digitos[i]);
    }
    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
