import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../compartilhado/widgets/botao_primario.dart';
import '../../../../nucleo/injecao_dependencias/provedores_globais.dart';
import '../../../../nucleo/utilitarios/validador.dart';
import '../providers/ocorrencias_provider.dart';

/// Opções de tipo de problema (alinhadas ao enum do banco).
const _tiposProblema = [
  ('buraco', 'Buraco'),
  ('alagamento', 'Alagamento'),
  ('deslizamento', 'Deslizamento'),
  ('queda_de_arvore', 'Queda de árvore'),
  ('ponte_danificada', 'Ponte danificada'),
  ('erosao', 'Erosão'),
  ('lama_atoleiro', 'Lama / atoleiro'),
  ('sinalizacao_ausente', 'Sinalização ausente'),
  ('drenagem_obstruida', 'Drenagem obstruída'),
  ('outro', 'Outro'),
];

const _urgencias = [
  ('baixa', 'Baixa', Colors.green),
  ('media', 'Média', Colors.orange),
  ('alta', 'Alta', Colors.red),
];

class NovaOcorrenciaPagina extends ConsumerStatefulWidget {
  const NovaOcorrenciaPagina({super.key});

  @override
  ConsumerState<NovaOcorrenciaPagina> createState() =>
      _NovaOcorrenciaPaginaState();
}

class _NovaOcorrenciaPaginaState extends ConsumerState<NovaOcorrenciaPagina> {
  final _formulario = GlobalKey<FormState>();
  final _descricaoCtrl = TextEditingController();

  String _tipoProblema = 'buraco';
  String _urgencia = 'media';
  String? _enderecoAproximado;
  String? _municipio;
  double? _latitude;
  double? _longitude;
  bool _obtendoLocalizacao = false;
  final List<File> _imagens = [];

  @override
  void dispose() {
    _descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _obterLocalizacao() async {
    setState(() => _obtendoLocalizacao = true);
    final servico = ref.read(geolocalizacaoServicoProvider);
    final posicao = await servico.obterPosicaoAtual();
    if (posicao != null && mounted) {
      final geo = ref.read(geocodificacaoServicoProvider);
      final endereco = await geo.geocodificarReversa(
        latitude: posicao.latitude,
        longitude: posicao.longitude,
      );
      setState(() {
        _latitude = posicao.latitude;
        _longitude = posicao.longitude;
        _enderecoAproximado = endereco?.enderecoFormatado ??
            '${posicao.latitude.toStringAsFixed(6)}, '
                '${posicao.longitude.toStringAsFixed(6)}';
        _municipio = endereco?.municipio;
        _obtendoLocalizacao = false;
      });
    } else if (mounted) {
      setState(() => _obtendoLocalizacao = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível obter a localização.'),
          ),
        );
      }
    }
  }

  Future<void> _adicionarImagem(ImageSource origem) async {
    final seletor = ImagePicker();
    final imagem = await seletor.pickImage(source: origem, imageQuality: 80);
    if (imagem != null) {
      setState(() => _imagens.add(File(imagem.path)));
    }
  }

  Future<void> _enviar() async {
    if (!_formulario.currentState!.validate()) return;
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Obtenha a localização antes de enviar.')),
      );
      return;
    }

    await ref.read(novaOcorrenciaProvider.notifier).enviar(
          descricao: _descricaoCtrl.text.trim(),
          latitude: _latitude!,
          longitude: _longitude!,
          imagens: _imagens,
          tipoProblema: _tipoProblema,
          urgencia: _urgencia,
          municipio: _municipio,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NovaOcorrenciaState>(novaOcorrenciaProvider, (_, novo) {
      if (novo.sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorrência registrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(novaOcorrenciaProvider.notifier).resetar();
        context.pop();
      }
      if (novo.erro != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(novo.erro!), backgroundColor: Colors.red),
        );
      }
    });

    final estado = ref.watch(novaOcorrenciaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar ocorrência')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Tipo de problema ─────────────────────────────
              Text('Tipo de problema',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _tipoProblema,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.warning_amber_outlined),
                ),
                items: _tiposProblema
                    .map((t) => DropdownMenuItem(
                          value: t.$1,
                          child: Text(t.$2),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _tipoProblema = v!),
              ),

              const SizedBox(height: 20),

              // ── Urgência ──────────────────────────────────────
              Text('Urgência',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: _urgencias
                    .map((u) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(u.$2),
                              selected: _urgencia == u.$1,
                              selectedColor: u.$3.withValues(alpha: 0.2),
                              onSelected: (_) =>
                                  setState(() => _urgencia = u.$1),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 20),

              // ── Descrição ─────────────────────────────────────
              TextFormField(
                controller: _descricaoCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva o problema com detalhes...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 64),
                    child: Icon(Icons.description_outlined),
                  ),
                ),
                validator: (v) => Validador.obrigatorio(v, campo: 'Descrição'),
              ),

              const SizedBox(height: 20),

              // ── Localização ───────────────────────────────────
              Text('Localização',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              if (_latitude != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _enderecoAproximado ??
                              '${_latitude!.toStringAsFixed(6)}, '
                                  '${_longitude!.toStringAsFixed(6)}',
                          style: TextStyle(color: Colors.green.shade800),
                        ),
                      ),
                      TextButton(
                        onPressed: _obterLocalizacao,
                        child: const Text('Atualizar'),
                      ),
                    ],
                  ),
                )
              else
                OutlinedButton.icon(
                  onPressed: _obtendoLocalizacao ? null : _obterLocalizacao,
                  icon: _obtendoLocalizacao
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: const Text('Usar minha localização'),
                ),

              if (_municipio != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Município detectado: $_municipio',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              Text('Fotos (opcional)',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              if (_imagens.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imagens.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imagens[i],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _imagens.removeAt(i)),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _adicionarImagem(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Câmera'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _adicionarImagem(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galeria'),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ── Botão enviar ──────────────────────────────────
              BotaoPrimario(
                rotulo: 'Enviar ocorrência',
                carregando: estado.carregando,
                aoPressionar: _enviar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}