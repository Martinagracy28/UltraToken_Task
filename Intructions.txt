
## Testing the Registration Process on BNB Testnet

To test the registration process and token transfer on the BNB Testnet using the UltraToken proxy address, follow these steps:

### Step 1: Connect to the BNB Testnet

1. **Open MetaMask** and ensure you are connected to the **BNB Testnet**.
   - If you don't have the BNB Testnet added, you can add it manually:
     - **Network Name**: BNB Testnet
     - **New RPC URL**: `https://data-seed-prebsc-1-s1.binance.org:8545/`
     - **Chain ID**: `97`
     - **Currency Symbol**: BNB

### Step 2: Access the Proxy Contract Address

1. Go to the [BscScan Testnet](https://testnet.bscscan.com/) and search for your deployed proxy contract address.
2. Click on the **contract address** to view the contract details.

### Step 3: Write to the Contract as Proxy

1. In the contract overview, navigate to the **Write as Proxy** tab.
2. Connect your MetaMask wallet if prompted.

### Step 4: Execute the Registration Function

1. Locate the `register()` function in the list of available functions.
2. **Enter the Payable Amount**:
   - Input `2.05` in the value field to send **2.05 BNB**.
3. Click on the **register** button to execute the registration.
4. Confirm the transaction in MetaMask.

### Step 5: View the Transaction Logs

1. After the transaction is confirmed, navigate back to the transaction details on BscScan.
2. Scroll down to the **Logs** section to view the emitted events:
   - **Registration Event**: You should see a log indicating that registration was successful.
   - **Token Distribution Event**: You will also see a log showing the token distribution to your wallet.

### Step 6: Verify Token Transfer

1. To verify that the tokens were transferred, go to your wallet in MetaMask.
2. You may need to add the UltraToken contract address to see your balance:
   - Click on **Tokens** > **Import Tokens**.
   - Enter the UltraToken contract address and add the token.
