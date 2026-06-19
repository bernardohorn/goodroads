import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../compartilhado/widgets/botao_primario.dart';
import '../../../../compartilhado/widgets/campo_texto.dart';
import '../../../../nucleo/constantes/constantes_aplicativo.dart';
import '../../../../nucleo/utilitarios/validador.dart';
import '../../../../nucleo/utilitarios/extrator_mensagem_erro.dart';
import '../../../../rotas/rotas_nomes.dart';
import '../providers/autenticacao_provider.dart';

/// Página de login (estrutura base).
class LoginPagina extends ConsumerStatefulWidget {
  const LoginPagina({super.key});

  @override
  ConsumerState<LoginPagina> createState() => _LoginPaginaState();
}

class _LoginPaginaState extends ConsumerState<LoginPagina> {
  final _formulario = GlobalKey<FormState>();
  final _emailControlador = TextEditingController();
  final _senhaControlador = TextEditingController();

  @override
  void dispose() {
    _emailControlador.dispose();
    _senhaControlador.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formulario.currentState!.validate()) return;

    await ref.read(autenticacaoControladorProvider.notifier).entrar(
          email: _emailControlador.text.trim(),
          senha: _senhaControlador.text,
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
            content: Text(extrairMensagemErro(proximo.error!)),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  ConstantesAplicativo.nomeAplicativo,
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Registro de ocorrências — ${ConstantesAplicativo.organizacao}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                CampoTexto(
                  rotulo: 'E-mail',
                  controlador: _emailControlador,
                  tipoTeclado: TextInputType.emailAddress,
                  validador: Validador.email,
                ),
                const SizedBox(height: 16),
                CampoTexto(
                  rotulo: 'Senha',
                  controlador: _senhaControlador,
                  ocultarTexto: true,
                  validador: Validador.senha,
                ),
                const SizedBox(height: 24),
                BotaoPrimario(
                  rotulo: 'Entrar',
                  carregando: autenticacao.isLoading,
                  aoPressionar: _entrar,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.push(RotasNomes.registro),
                  child: const Text('Criar conta'),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
