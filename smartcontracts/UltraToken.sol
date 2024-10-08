// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BEP20Token.sol";  // Import the BEP20 token standard contract
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol"; // Import OpenZeppelin's AccessControl for role-based access
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol"; // Import ReentrancyGuard to prevent reentrancy attacks

/**
 * @title UltraToken
 * The contract allows user registration for a fee and distributes Ultra tokens upon successful registration.
 * Additionally, it supports upgradability and includes functionalities for minting, burning, and setting registration fees.
 */
contract UltraToken is Initializable, BEP20Token, UUPSUpgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    
    // Address of the admin account responsible for managing the contract
    address public admin;

    // The registration fee in BNB, set to 2.05 BNB in wei
    uint256 public registrationFee;
    
    // The amount of Ultra tokens to be distributed when a user registers
    uint256 public tokensForRegistration;
    
    // Mapping to track registered users (true if registered)
    mapping(address => bool) public registeredUsers;

    // Event emitted when a user registers
    event Registration(address indexed user, uint256 amountPaid);
    
    // Event emitted when tokens are distributed to a registered user
    event TokenDistributed(address indexed user, uint256 amount);
    
    // Event emitted when new tokens are created (minted)
    event TokenCreated(uint256 amount);

    /**
     * @dev Function to authorize upgrades of the contract.
     * Only the admin can authorize an upgrade to the proxy contract.
     */
    function _authorizeUpgrade(address) internal override onlyAdmin {}

    /**
     * @dev Initializes the contract. 
     * This replaces the constructor in upgradeable contracts.
     * It sets the token name, symbol, initial supply, and other necessary parameters.
     */
    function initialize() public initializer {
        __BEP20_init("Ultra", "ULTRA"); // Initialize the BEP20 token with name and symbol
        __Ownable_init(msg.sender); // Initialize Ownable to make the deployer the owner
        __ReentrancyGuard_init(); // Initialize ReentrancyGuard for reentrancy protection
        admin = msg.sender; // Set the admin as the contract deployer
        registrationFee = 2.05 ether; // Set registration fee to 2.05 BNB (in wei)

        tokensForRegistration = 1 * 10 ** decimals(); // Set the amount of tokens for registration reward
        
        // Mint an initial supply of 1,000,000 ULTRA tokens to the contract itself
        mint(address(this), 1000000 * 10 ** decimals());
        emit TokenCreated(1000000 * 10 ** decimals()); // Emit event for token creation
    }

    /**
     * @dev Modifier to restrict function access to the admin only.
     * Ensures that only the admin can call functions protected by this modifier.
     */
    modifier onlyAdmin {
        require(msg.sender == admin, "Not admin");
        _;
    }

    /**
     * @dev Function to register users.
     * Users must send the exact registration fee (2.05 BNB) to register and receive Ultra tokens.
     * Emits a Registration event upon successful registration.
     */
    function register() external payable nonReentrant {
        require(!registeredUsers[msg.sender], "Already registered"); // Ensure the user is not already registered
        require(msg.value == registrationFee, "Incorrect registration fees"); // Ensure the user sends the correct fee

        registeredUsers[msg.sender] = true; // Mark the user as registered

        emit Registration(msg.sender, msg.value); // Emit registration event

        _distributeTokens(msg.sender); // Distribute tokens to the registered user
    }

    /**
     * @dev Private function to distribute tokens to the user upon successful registration.
     * Transfers the predefined number of tokens to the user's address.
     * Emits a TokenDistributed event.
     */
    function _distributeTokens(address _user) private {
        require(balanceOf(address(this)) >= tokensForRegistration, "Not enough tokens in the contract to distribute"); // Ensure the contract has enough tokens
        
        _transfer(address(this), _user, tokensForRegistration); // Transfer tokens from contract to user

        emit TokenDistributed(_user, tokensForRegistration); // Emit token distribution event
    }

    /**
     * @dev Admin function to mint new tokens.
     * Can only be called by the admin.
     */
    function _mint(address to, uint256 amount) external onlyAdmin {
        mint(to, amount); // Mint the specified amount of tokens to the provided address
    }

    /**
     * @dev Admin function to burn tokens.
     * Can only be called by the admin.
     */
    function _burn(uint256 amount) external onlyAdmin {
        burn(amount); // Burn the specified amount of tokens from the msg.sender
    }

    /**
     * @dev Admin function to set a new registration fee.
     * Can only be called by the admin.
     */
    function setRegistrationFee(uint256 _newFee) external onlyAdmin {
        registrationFee = _newFee; // Update the registration fee
    }

    /**
     * @dev Admin function to withdraw all BNB from the contract.
     * Transfers the contract's BNB balance to the admin.
     * Can only be called by the admin and is protected against reentrancy.
     */
    function withdrawBNB() external onlyAdmin nonReentrant {
        payable(msg.sender).transfer(address(this).balance); // Transfer contract's balance to the admin
    }

    /**
     * @dev Function to change the admin.
     * Can only be called by the owner.
     * Ensures the new admin is a valid address.
     */
    function changeAdmin(address newAdmin) external onlyOwner {
        require(newAdmin != address(0), "Invalid address"); // Ensure the new admin address is valid
        admin = newAdmin; // Set the new admin
    }

    /**
     * @dev Fallback function to allow the contract to receive BNB.
     * Automatically triggered when BNB is sent to the contract address.
     */
    receive() external payable {}

}
