# ZenStack Smart Contract

## Overview

This repository contains the source code and configuration for the ZenStack smart contract project. The contract is designed to provide secure, efficient, and scalable solutions for decentralized applications.

## Features

- Modular contract architecture for easy upgrades and maintenance
- Support for multiple environments (Mainnet, Testnet)
- Comprehensive logging and coverage reporting
- Clean project structure with environment-specific configuration

## Getting Started

### Installation

Clone the repository and install dependencies:

```sh
git clone https://github.com/yourusername/zenstack.git
cd zenstack
npm install
```

### Configuration

Environment-specific configuration files are located in the `settings` directory.  
**Note:** Mainnet and Testnet TOML files are excluded from version control for security.

### Building and Testing

To compile the contracts:

```sh
npx hardhat compile
```

To run tests:

```sh
npx hardhat test
```

### Deployment

Update your deployment scripts and environment variables as needed, then deploy:

```sh
npx hardhat run scripts/deploy.js --network <network>
```

## Project Structure

- `contracts/` — Smart contract source code
- `scripts/` — Deployment and utility scripts
- `test/` — Unit and integration tests
- `settings/` — Environment configuration files
- `.cache/`, `logs/`, `coverage/` — Ignored by version control
