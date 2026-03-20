# Yield Aggregator Vault Core 🌾

A professional, production-ready implementation of a DeFi Yield Aggregator. This repository follows the **ERC-4626 Tokenized Vault Standard**, ensuring high interoperability with the broader DeFi ecosystem.

## Core Features
- **ERC-4626 Compliant**: Standardized interface for yield-bearing tokens.
- **Strategy Pattern**: Decouples the vault logic from the specific yield-farming strategy.
- **Auto-Compounding**: Logic hooks to sell reward tokens and reinvest into the underlying asset.
- **Fee Management**: Built-in treasury and performance fee calculations.

## Architecture
1. **Vault.sol**: Handles deposits, withdrawals, and share accounting.
2. **BaseStrategy.sol**: Abstract contract for implementing specific farm logic (e.g., Aave, Curve).
3. **Controller.sol**: Manages capital allocation between different strategies.

## Tech Stack
- Solidity ^0.8.20
- OpenZeppelin (ERC4626, ReentrancyGuard)
- Foundry / Hardhat
