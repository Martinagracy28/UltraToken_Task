# UltraToken Smart Contract

**UltraToken** is a BEP20-compatible token contract deployed on the Binance Smart Chain (BSC). The contract supports features such as user registration (with a fee), token distribution upon registration, minting, and burning of tokens. It is also designed to be upgradeable using OpenZeppelin's UUPS proxy pattern.

## Features

- **Upgradeable:** UUPS proxy-based contract upgrades.
- **Token Distribution:** Users receive Ultra tokens after successful registration.
- **Minting/Burning:** Admin has control over token supply via minting and burning functions.
- **Access Control:** Admin-only functionality for critical operations like minting, burning, and withdrawing BNB.
- **Security:** Uses OpenZeppelin’s `ReentrancyGuard` to prevent reentrancy attacks.

## Prerequisites

Before deploying and interacting with this contract, ensure you have the following:

- **MetaMask**: Installed and connected to Binance Smart Chain.
- **Remix IDE**: For deploying the contract.
- **BNB**: To cover deployment and transaction fees.

## Table of Contents

1. [Deployment Using Remix](#deployment-using-remix)
2. [Interaction with UltraToken](#interaction-with-ultratoken)
3. [Contract Functions](#contract-functions)
4. [Admin Functions](#admin-functions)
5. [Upgrade the Contract](#upgrade-the-contract)

## Deployment Using Remix

To deploy the UltraToken contract using **Remix**, follow these steps:

### Step 1: Open Remix IDE
- Visit [Remix IDE](https://remix.ethereum.org) and ensure MetaMask is connected to Binance Smart Chain (BSC).

### Step 2: Import Contract Code
1. In **Remix**, under the **File Explorer**, create the following three files:
    - `IBEP20.sol`
    - `BEP20Token.sol`
    - `UltraToken.sol`

2. Copy the corresponding code into each file:
    - **IBEP20.sol**: Contains the interface for the BEP20 token.
    - **BEP20Token.sol**: The implementation of the BEP20 token.
    - **UltraToken.sol**: The main contract for UltraToken.

3. Ensure that all imports within the files are correct, such as:

```solidity
import "./IBEP20.sol";
import "./BEP20Token.sol";
```

4. After importing all three files, proceed to the next step to compile the contracts.

### Step 3: Compile the Contract
- Go to the **Solidity Compiler** tab.
- Select the correct compiler version (e.g., `^0.8.26`).
- Click **Compile UltraToken.sol** and ensure there are no errors.

### Step 4: Deploy the Contract
1. In the **Deploy & Run Transactions** tab:
   - Set the **Environment** to **Injected Web3** (MetaMask).
   - Ensure you are connected to the desired network in MetaMask (e.g., testnet like **BNB Smart Chain**).

2. Select **UltraToken** from the contract dropdown.

3. **Proxy Deployment**:
   - Once you select **UltraToken**, a checkbox labeled **Deploy as Proxy** will appear.
   - Check the **Deploy with Proxy** option. This ensures that both the **implementation** and **proxy** contracts are deployed simultaneously, allowing for future upgrades.
   - You can now proceed by clicking the **Deploy** button.

4. Confirm the deployment transaction in MetaMask.

5. After deployment, you should see both the **implementation contract** and the **proxy contract** under the **Deployed Contracts** section.


### Step 5: Contract Initialization (Not Required for Proxy Deployment)
- Since the contract is deployed as a proxy, the **initialize()** function will be automatically called during deployment, and no manual initialization is needed.

## Interaction with UltraToken

Once deployed, you can interact with the contract directly from Remix or using any Web3 integration. Some key functions:

- **register()**: Users register by paying a specified registration fee (e.g., 2.05 BNB) and receive Ultra tokens in return.
- **_distributeTokens()**: Internally called after registration to send tokens to the registered user.

## Contract Functions

### 1. **register()**
Allows users to register by sending the required registration fee (e.g., 2.05 BNB). If the registration is successful, they receive Ultra tokens.

- **Parameters**: None
- **Returns**: Ultra tokens based on the contract's configuration.

### 2. **_distributeTokens(address user)**
Distributes Ultra tokens to the specified user upon successful registration.

- **Parameters**: Address of the user to receive tokens.
- **Returns**: Event indicating the token distribution.

### 3. **setRegistrationFee(uint256 fee)**
Admin can change the registration fee required to register.

- **Parameters**: `fee` (in wei).
- **Returns**: None.

### 4. **withdrawBNB()**
Admin can withdraw the BNB collected through user registrations.

- **Returns**: None.

## Admin Functions

- **_mint(address to, uint256 amount)**: Mint new Ultra tokens to a specified address. Only callable by the admin.
- **_burn(uint256 amount)**: Burn Ultra tokens from the contract's balance. Only callable by the admin.
- **setRegistrationFee(uint256 fee)**: Set a new registration fee. Only callable by the admin.
- **withdrawBNB()**: Withdraw BNB from the contract. Only callable by the admin.
- **changeAdmin(address newAdmin)**: Change the admin address.


## Upgrade the Contract

This contract supports the **UUPS proxy upgrade** pattern, allowing you to upgrade the contract's implementation without changing its address. To upgrade the contract:

1. In Remix, compile the new contract implementation.
2. Navigate to the **Deploy & Run Transactions** tab in Remix.
3. Select the **Upgrade with Proxy** option.
4. Enter the proxy contract address (the one already deployed) and click **Deploy**.
5. Remix will handle the upgrade automatically, updating the implementation while keeping the same proxy address.

**Note**: If the new implementation includes new state variables, ensure that the contract has an `initialize()`  function to properly set the new variables or logic.



