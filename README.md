# Guardião do Limiar (Threshold Guard)

Uma Habilidade de agente inteligente desenvolvida em Solidity para verificar múltiplas condições on-chain antes de autorizar e disparar uma ação (como o rebalanceamento de um cofre).

## 🚀 Requisitos Atendidos

1. **Avaliação Multi-Critério (Req. 01):**
   * O contrato avalia 3 condições independentes: Variação de Preço Mínima, Teto Máximo de Gás e Liquidez Mínima do Cofre.

2. **Limiares Configuráveis (Req. 02):**
   * Os valores de limiar não estão codificados fixamente (hardcoded). Podem ser ajustados dinamicamente através da função `setThresholds()`.

3. **Traço de Decisão e Rastreabilidade (Req. 03):**
   * Cada verificação dispara eventos `ConditionChecked` detalhando o valor exigido, valor real observado e aprovação/reprovação individual, além do evento `FinalDecision` com o resultado global.

4. **Demonstração dos Cenários (Req. 04):**
   * O contrato inclui duas funções de teste (`demoTriggerScenario` e `demoHoldScenario`) que simulam explicitamente o disparo da ação em condições favoráveis e o bloqueio preventivo em condições desfavoráveis.

## 📂 Estrutura do Repositório

```text
pharos/
├── contracts/
│   └── ThresholdGuard.sol     # Contrato inteligente em Solidity
└── README.md                  # Documentação do projeto
