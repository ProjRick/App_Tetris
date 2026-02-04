
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Garante que o binding do Flutter esteja inicializado antes de usar SystemChrome.
  WidgetsFlutterBinding.ensureInitialized();

  // Deixa o app em modo imersivo (some status bar / navigation bar quando possível).
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MeuApp());
}

/// ============================
/// APP RAIZ
/// ============================
/// Responsável por iniciar o MaterialApp e apontar para a primeira tela.
class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaSelecaoModo(),
    );
  }
}

/// ============================
/// CONFIGURAÇÃO DO JOGO
/// ============================
/// Define o tamanho do tabuleiro (linhas x colunas) e um rótulo para exibir na UI.
class ConfiguracaoJogo {
  final int linhas;
  final int colunas;
  final String rotulo;

  const ConfiguracaoJogo({
    required this.linhas,
    required this.colunas,
    required this.rotulo,
  });
}

/// ============================
/// MENU INICIAL (SELEÇÃO DE MODO)
/// ============================
/// Tela onde o usuário escolhe o tamanho da grade (pequena/normal/grande).
class PaginaSelecaoModo extends StatelessWidget {
  const PaginaSelecaoModo({super.key});

  /// Abre a página do jogo com uma configuração específica.
  void _abrirJogo(BuildContext context, ConfiguracaoJogo config) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PaginaTetris(config: config)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo (capa).
          Positioned.fill(
            child: Image.asset(
              'assets/images/tetris_cover.png',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay escuro para melhorar contraste do texto.
          Positioned.fill(child: Container(color: const Color(0xB0050505))),

          // Conteúdo central com os cards de modo.
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'TETRIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Escolha o tamanho da grade',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 26),

                    _CartaoModo(
                      titulo: '1) Pequena',
                      subtitulo: 'Jogo mais dinâmico',
                      etiqueta: '16 x 8',
                      aoTocar: () => _abrirJogo(
                        context,
                        const ConfiguracaoJogo(
                          linhas: 16,
                          colunas: 8,
                          rotulo: 'Pequena',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _CartaoModo(
                      titulo: '2) Normal',
                      subtitulo: 'Jogo clássico',
                      etiqueta: '20 x 10',
                      aoTocar: () => _abrirJogo(
                        context,
                        const ConfiguracaoJogo(
                          linhas: 20,
                          colunas: 10,
                          rotulo: 'Normal',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _CartaoModo(
                      titulo: '3) Grande',
                      subtitulo: 'Maior safe area',
                      etiqueta: '30 x 15',
                      aoTocar: () => _abrirJogo(
                        context,
                        const ConfiguracaoJogo(
                          linhas: 30,
                          colunas: 15,
                          rotulo: 'Grande',
                        ),
                      ),
                    ),

// const SizedBox(height: 22),
 //const Text(
 // 'No jogo: Tap = girar | Swipe ←/→ = mover | Swipe ↓ = queda direta',
// style: TextStyle(color: Colors.white54),
//  textAlign: TextAlign.center,
 //  ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================
/// CARD DO MODO
/// ============================
/// Widget visual reutilizável para cada opção de modo.
class _CartaoModo extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String etiqueta;
  final VoidCallback aoTocar;

  const _CartaoModo({
    required this.titulo,
    required this.subtitulo,
    required this.etiqueta,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xCC0B0B0B),
            Color(0x66161616),
          ],
        ),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitulo,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101010),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFF2D7DFF), width: 1),
                  ),
                  child: Text(etiqueta, style: const TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================
/// PEÇAS (FORMATO) + CORES
/// ============================
/// Estrutura que representa um "tipo de peça": id + matriz do formato.
class PecaTetris {
  final int id;
  final List<List<int>> formato; // 1 = ocupa célula, 0 = vazio

  const PecaTetris(this.id, this.formato);
}

/// Mapa de cores por id de peça (usado para renderização do tabuleiro).
const Map<int, Color> coresDasPecas = {
  1: Color(0xFF2EC4FF), // I
  2: Color(0xFFFFD400), // O
  3: Color(0xFFB15CFF), // T
  4: Color(0xFF2EE66B), // S
  5: Color(0xFFFF6B6B), // Z
  6: Color(0xFFFF9F1C), // L
  7: Color(0xFF4D96FF), // J
};

/// Lista de peças possíveis com seus formatos iniciais.
final List<PecaTetris> pecas = [
  const PecaTetris(1, [
    [1, 1, 1, 1]
  ]),
  const PecaTetris(2, [
    [1, 1],
    [1, 1]
  ]),
  const PecaTetris(3, [
    [0, 1, 0],
    [1, 1, 1]
  ]),
  const PecaTetris(6, [
    [1, 0],
    [1, 0],
    [1, 1]
  ]),
  const PecaTetris(7, [
    [0, 1],
    [0, 1],
    [1, 1]
  ]),
  const PecaTetris(4, [
    [0, 1, 1],
    [1, 1, 0]
  ]),
  const PecaTetris(5, [
    [1, 1, 0],
    [0, 1, 1]
  ]),
];

/// ============================
/// PÁGINA DO JOGO
/// ============================
/// Contém a lógica do Tetris + renderização do tabuleiro.
class PaginaTetris extends StatefulWidget {
  final ConfiguracaoJogo config;

  const PaginaTetris({super.key, required this.config});

  @override
  State<PaginaTetris> createState() => _EstadoPaginaTetris();
}

/// ============================
/// ESTADO DO JOGO
/// ============================
/// Mantém o tabuleiro, a peça atual, temporizador de queda e controles por gesto.
class _EstadoPaginaTetris extends State<PaginaTetris> {
  late final int totalLinhas;
  late final int totalColunas;

  /// Tabuleiro guarda SOMENTE peças travadas:
  /// 0 = vazio, 1..7 = id da peça travada naquela célula.
  late List<List<int>> tabuleiro;

  /// Peça atual (não entra no tabuleiro até travar).
  List<List<int>> pecaAtual = [];
  int idPecaAtual = 1;
  int linhaAtual = 0;
  int colunaAtual = 0;

  Timer? temporizadorQueda;
  bool jogoEncerrado = false;

  /// Controle de gestos de arrastar (swipe).
  Offset? inicioPan;
  bool moveuNestePan = false;

  /// Velocidade base da queda automática.
  static const Duration velocidadeQueda = Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();

    totalLinhas = widget.config.linhas;
    totalColunas = widget.config.colunas;

    // Inicializa tabuleiro vazio.
    tabuleiro = List.generate(totalLinhas, (_) => List.generate(totalColunas, (_) => 0));

    // Cria a primeira peça.
    gerarPeca();
  }

  @override
  void dispose() {
    // Encerra o timer ao sair da tela para evitar vazamentos e callbacks após dispose().
    temporizadorQueda?.cancel();
    super.dispose();
  }

  /// Clona a matriz do formato de uma peça para não alterar a referência original.
  List<List<int>> _clonarMatriz(List<List<int>> matriz) =>
      matriz.map((linha) => List<int>.from(linha)).toList();

  /// ============================
  /// GESTOS
  /// ============================
  /// Trata o "pan" (arrastar) e decide se o usuário moveu para esquerda/direita/baixo.
  void tratarPanUpdate(DragUpdateDetails detalhes) {
    if (jogoEncerrado) return;
    if (inicioPan == null) return;

    final dx = detalhes.localPosition.dx - inicioPan!.dx;
    final dy = detalhes.localPosition.dy - inicioPan!.dy;

    const limite = 18.0;

    // Impede múltiplos movimentos no mesmo gesto.
    if (moveuNestePan) return;

    // Se o movimento horizontal é maior, move para esquerda/direita.
    if (dx.abs() > dy.abs()) {
      if (dx > limite) {
        moverDireita();
        moveuNestePan = true;
      } else if (dx < -limite) {
        moverEsquerda();
        moveuNestePan = true;
      }
    } else {
      // Se o vertical é maior, queda direta (hard drop).
      if (dy > limite) {
        quedaDireta();
        moveuNestePan = true;
      }
    }
  }

  /// ============================
  /// LOOP DO JOGO (QUEDA AUTOMÁTICA)
  /// ============================
  /// Inicia/reinicia o timer de queda. A cada tick:
  /// - se pode descer, desce
  /// - senão, trava a peça, limpa linhas e gera a próxima.
  void iniciarQuedaAutomatica() {
    temporizadorQueda?.cancel();

    temporizadorQueda = Timer.periodic(velocidadeQueda, (_) {
      if (jogoEncerrado) return;

      setState(() {
        if (podeMoverParaBaixo()) {
          linhaAtual++;
        } else {
          travarPecaAtual();
          limparLinhasCompletas();
          gerarPeca();
        }
      });
    });
  }

  /// Gera uma nova peça no topo e centraliza horizontalmente.
  void gerarPeca() {
    if (jogoEncerrado) return;

    linhaAtual = 0;

    final sorteada = pecas[Random().nextInt(pecas.length)];
    idPecaAtual = sorteada.id;
    pecaAtual = _clonarMatriz(sorteada.formato);

    // Centraliza a peça no topo com base na largura do formato.
    colunaAtual = max(0, (totalColunas - pecaAtual[0].length) ~/ 2);

    // Se não for possível posicionar no topo, game over.
    if (!podePosicionar(linhaAtual, colunaAtual, pecaAtual)) {
      setState(() => jogoEncerrado = true);
      temporizadorQueda?.cancel();
      temporizadorQueda = null;
      return;
    }

    iniciarQuedaAutomatica();
  }

  /// Reseta o estado do jogo para recomeçar do zero.
  void reiniciarJogo() {
    temporizadorQueda?.cancel();
    temporizadorQueda = null;

    setState(() {
      jogoEncerrado = false;
      tabuleiro = List.generate(totalLinhas, (_) => List.generate(totalColunas, (_) => 0));
      pecaAtual = [];
    });

    gerarPeca();
  }

  /// ============================
  /// COLISÃO / MOVIMENTO
  /// ============================
  /// Verifica se um formato (shape) pode ser colocado em (linhaBase, colunaBase)
  /// sem sair do tabuleiro e sem colidir com peças travadas.
  bool podePosicionar(int linhaBase, int colunaBase, List<List<int>> formato) {
    for (int r = 0; r < formato.length; r++) {
      for (int c = 0; c < formato[r].length; c++) {
        if (formato[r][c] != 1) continue;

        final linhaTab = linhaBase + r;
        final colTab = colunaBase + c;

        // Fora das bordas.
        if (colTab < 0 || colTab >= totalColunas) return false;
        if (linhaTab < 0 || linhaTab >= totalLinhas) return false;

        // Colisão com peça travada.
        if (tabuleiro[linhaTab][colTab] != 0) return false;
      }
    }
    return true;
  }

  /// Retorna se a peça atual pode descer uma linha.
  bool podeMoverParaBaixo() => podePosicionar(linhaAtual + 1, colunaAtual, pecaAtual);

  /// Move a peça atual uma coluna à esquerda, se possível.
  void moverEsquerda() {
    if (jogoEncerrado) return;
    if (!podePosicionar(linhaAtual, colunaAtual - 1, pecaAtual)) return;
    setState(() => colunaAtual--);
  }

  /// Move a peça atual uma coluna à direita, se possível.
  void moverDireita() {
    if (jogoEncerrado) return;
    if (!podePosicionar(linhaAtual, colunaAtual + 1, pecaAtual)) return;
    setState(() => colunaAtual++);
  }

  /// Gira a peça 90° no sentido horário (matriz rotacionada),
  /// respeitando colisões e limites (sem wall-kick).
  void girarPeca() {
    if (jogoEncerrado) return;
    if (pecaAtual.isEmpty) return;

    final rotacionada = List.generate(
      pecaAtual[0].length,
      (i) => List.generate(
        pecaAtual.length,
        (j) => pecaAtual[pecaAtual.length - 1 - j][i],
      ),
    );

    if (!podePosicionar(linhaAtual, colunaAtual, rotacionada)) return;

    setState(() => pecaAtual = rotacionada);
  }

  /// Hard drop: desce a peça até o máximo possível e finaliza o ciclo
  /// (trava, limpa linhas e gera a próxima) sem precisar de outra interação.
  void quedaDireta() {
    if (jogoEncerrado) return;

    // Recomendado: cancela o timer para não concorrer com o tick durante o hard drop.
    temporizadorQueda?.cancel();
    temporizadorQueda = null;

    setState(() {
      while (podeMoverParaBaixo()) {
        linhaAtual++;
      }

      travarPecaAtual();
      limparLinhasCompletas();
      gerarPeca();
    });
  }

  /// "Trava" a peça atual no tabuleiro, gravando seu id nas células ocupadas.
  void travarPecaAtual() {
    for (int r = 0; r < pecaAtual.length; r++) {
      for (int c = 0; c < pecaAtual[r].length; c++) {
        if (pecaAtual[r][c] != 1) continue;

        final linhaTab = linhaAtual + r;
        final colTab = colunaAtual + c;

        if (linhaTab >= 0 && linhaTab < totalLinhas && colTab >= 0 && colTab < totalColunas) {
          tabuleiro[linhaTab][colTab] = idPecaAtual;
        }
      }
    }
  }

  /// Remove linhas completas e puxa as linhas acima para baixo.
  void limparLinhasCompletas() {
    for (int linha = totalLinhas - 1; linha >= 0; linha--) {
      bool cheia = true;

      for (int col = 0; col < totalColunas; col++) {
        if (tabuleiro[linha][col] == 0) {
          cheia = false;
          break;
        }
      }

      if (cheia) {
        // Desce tudo acima.
        for (int r = linha; r > 0; r--) {
          tabuleiro[r] = List<int>.from(tabuleiro[r - 1]);
        }
        // Nova linha vazia no topo.
        tabuleiro[0] = List<int>.filled(totalColunas, 0);

        // Reavalia a mesma linha (pois ela recebeu a linha de cima).
        linha++;
      }
    }
  }

  /// ============================
  /// UI (CÉLULA PERTENCE À PEÇA ATUAL?)
  /// ============================
  /// Retorna true se a célula (linha, col) está ocupada pela peça atual (em queda).
  bool celulaEhDaPecaAtual(int linha, int col) {
    for (int r = 0; r < pecaAtual.length; r++) {
      for (int c = 0; c < pecaAtual[r].length; c++) {
        if (pecaAtual[r][c] != 1) continue;

        final linhaTab = linhaAtual + r;
        final colTab = colunaAtual + c;

        if (linhaTab == linha && colTab == col) return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06122A),
      body: Stack(
        children: [
          // Fundo com gradiente.
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF081A3A),
                    Color(0xFF06122A),
                  ],
                ),
              ),
            ),
          ),

          // Área de jogo com gestos.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              // Tap gira a peça.
              onTap: jogoEncerrado ? null : girarPeca,

              // Início do pan.
              onPanStart: (detalhes) {
                inicioPan = detalhes.localPosition;
                moveuNestePan = false;
              },

              // Atualização do pan.
              onPanUpdate: tratarPanUpdate,

              // Final do pan.
              onPanEnd: (_) {
                inicioPan = null;
                moveuNestePan = false;
              },

              child: LayoutBuilder(
                builder: (context, constraints) {
                  final mq = MediaQuery.of(context);

                  // Safe areas.
                  final safeTop = mq.padding.top;
                  final safeBottom = mq.padding.bottom;

                  // Reserva extra para sobrar espaço embaixo.
                  const reservaInferiorExtra = 60.0;

                  final alturaDisponivel =
                      constraints.maxHeight - safeTop - safeBottom - reservaInferiorExtra;
                  final larguraDisponivel = constraints.maxWidth;

                  // Define uma área "utilizável" para o tabuleiro (ajuste fino de layout).
                  final alturaUtil = alturaDisponivel * 5.82;
                  final larguraUtil = larguraDisponivel * 0.78;

                  // Tamanho de cada célula é limitado pela dimensão mais restritiva.
                  final tamanhoCelula = min(larguraUtil / totalColunas, alturaUtil / totalLinhas);

                  final larguraTabuleiro = tamanhoCelula * totalColunas;
                  final alturaTabuleiro = tamanhoCelula * totalLinhas;

                  return Padding(
                    padding: EdgeInsets.only(
                      top: safeTop + 4,
                      bottom: safeBottom + reservaInferiorExtra,
                      left: 12,
                      right: 12,
                    ),
                    child: Align(
                      // Alinha no topo para "subir" o tabuleiro (sobra maior fica embaixo).
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1B3A),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFF2D6BFF), width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 24,
                              offset: Offset(0, 14),
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: larguraTabuleiro,
                          height: alturaTabuleiro,
                          child: GridView.builder(
                            // Importante: desativa scroll e remove padding automático.
                            primary: false,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: totalLinhas * totalColunas,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: totalColunas,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final linha = index ~/ totalColunas;
                              final col = index % totalColunas;

                              // Renderiza célula da peça atual (em queda).
                              if (!jogoEncerrado &&
                                  pecaAtual.isNotEmpty &&
                                  celulaEhDaPecaAtual(linha, col)) {
                                final cor = coresDasPecas[idPecaAtual] ?? const Color(0xFF2EC4FF);
                                return Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: AzulejoTetris(preenchido: true, cor: cor),
                                );
                              }

                              // Renderiza célula do tabuleiro (peças travadas).
                              final valor = tabuleiro[linha][col];
                              if (valor == 0) {
                                return const Padding(
                                  padding: EdgeInsets.all(1),
                                  child: AzulejoTetris(preenchido: false),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.all(1),
                                child: AzulejoTetris(
                                  preenchido: true,
                                  cor: coresDasPecas[valor] ?? const Color(0xFF2EC4FF),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Badge com o modo atual.
          Positioned(
            top: 18,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xAA06122A),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0x552D6BFF)),
              ),
              child: Text(
                '${widget.config.rotulo} (${widget.config.linhas}x${widget.config.colunas})',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),

          // Overlay de game over.
          if (jogoEncerrado)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'WASTED',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: reiniciarJogo,
                            child: const Text('Reiniciar'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Mudar modo'),
                          ),
                        ],
                      ),
  // const SizedBox(height: 14),
   // const Text(
  // 'Tap = girar | Swipe ←/→ = mover | Swipe ↓ = queda direta',
  //  style: TextStyle(color: Colors.white70),
 //  textAlign: TextAlign.center,
 //  ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ============================
/// AZULEJO (TILE) DO TABULEIRO
/// ============================
/// Responsável por desenhar uma célula do tabuleiro.
/// - Se vazia: fundo escuro simples.
/// - Se preenchida: gradiente + sombra para estilo arcade.
class AzulejoTetris extends StatelessWidget {
  final bool preenchido;
  final Color cor;

  const AzulejoTetris({
    super.key,
    required this.preenchido,
    this.cor = const Color(0xFF2EC4FF),
  });

  @override
  Widget build(BuildContext context) {
    if (!preenchido) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0E1A33),
          borderRadius: BorderRadius.circular(5),
        ),
      );
    }

    // Cria tons mais claro e mais escuro para simular profundidade.
    final claro = Color.lerp(cor, Colors.white, 0.38)!;
    final escuro = Color.lerp(cor, Colors.black, 0.45)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [claro, escuro],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

