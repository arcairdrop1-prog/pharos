// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ThresholdGuard {
    // Requisito 02: Condições e limiares configuráveis (não codificados fixamente)
    uint256 public minPriceChange;
    uint256 public maxGasPrice;
    uint256 public minVaultLiquidity;

    address public owner;

    // Requisito 03: Traço claro de decisão de cada execução via Eventos
    event ConditionChecked(
        string condition, 
        uint256 threshold, 
        uint256 actualValue, 
        bool passed, 
        string detail
    );
    event FinalDecision(bool executed, string status);

    constructor(uint256 _minPriceChange, uint256 _maxGasPrice, uint256 _minVaultLiquidity) {
        minPriceChange = _minPriceChange;
        maxGasPrice = _maxGasPrice;
        minVaultLiquidity = _minVaultLiquidity;
        owner = msg.sender;
    }

    // Função para atualizar os limiares dinamicamente
    function setThresholds(uint256 _minPriceChange, uint256 _maxGasPrice, uint256 _minVaultLiquidity) external {
        require(msg.sender == owner, "Apenas o proprietario pode configurar");
        minPriceChange = _minPriceChange;
        maxGasPrice = _maxGasPrice;
        minVaultLiquidity = _minVaultLiquidity;
    }

    // Requisito 01: Avalia pelo menos 3 condições independentes lidas da cadeia/parâmetros
    function evaluate(uint256 priceChange, uint256 gasPrice, uint256 vaultLiquidity) public returns (bool) {
        // Condição 1: Variação de Preço Mínima
        bool c1Passed = priceChange >= minPriceChange;
        emit ConditionChecked(
            "Variacao de Preco Minima", 
            minPriceChange, 
            priceChange, 
            c1Passed, 
            c1Passed ? "Aprovado" : "Variacao insuficiente"
        );

        // Condição 2: Preço Máximo do Gás
        bool c2Passed = gasPrice <= maxGasPrice;
        emit ConditionChecked(
            "Preco Maximo do Gas", 
            maxGasPrice, 
            gasPrice, 
            c2Passed, 
            c2Passed ? "Aprovado" : "Gas acima do limite"
        );

        // Condição 3: Liquidez Mínima do Cofre
        bool c3Passed = vaultLiquidity >= minVaultLiquidity;
        emit ConditionChecked(
            "Liquidez Minima do Cofre", 
            minVaultLiquidity, 
            vaultLiquidity, 
            c3Passed, 
            c3Passed ? "Aprovado" : "Liquidez abaixo do minimo"
        );

        // Decisão final combinada
        bool finalDecision = c1Passed && c2Passed && c3Passed;
        
        if (finalDecision) {
            emit FinalDecision(true, "DISPARAR ACAO (Rebalanceamento Executado)");
        } else {
            emit FinalDecision(false, "SEGURAR / BLOQUEAR (Nenhuma acao enviada)");
        }

        return finalDecision;
    }

    // ==========================================
    // Requisito 04: Demonstração de Ambos os Resultados
    // ==========================================
    
    // Simula uma corrida onde o disparo OCORRE (valores ideais)
    function demoTriggerScenario() external returns (bool) {
        // Exemplo: Variação 4%, Gás 20 gwei, Liquidez 150.000
        return evaluate(4, 20, 150000);
    }

    // Simula uma corrida onde ele SEGURA/BLOQUEA (valores desfavoráveis)
    function demoHoldScenario() external returns (bool) {
        // Exemplo: Variação 1%, Gás 45 gwei, Liquidez 75.000
        return evaluate(1, 45, 75000);
    }
}
