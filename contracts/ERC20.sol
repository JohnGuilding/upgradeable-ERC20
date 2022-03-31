// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./IERC20.sol";

contract ERC20 is Initializable, IERC20, OwnableUpgradeable {
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    string public name;
    string public symbol;

    /**
     * @dev Initializes the contract. This defines the {name} and {symbol} of the token, as well
     * as making the contract ownable.
    */
    function initialize(string calldata _name, string calldata _symbol) external initializer {
        name = _name;
        symbol = _symbol;
        __Ownable_init();
    }

    /**
     * @dev Returns the total number decimals that the token has. 
     * For example, if 'decimals' equals '2', then a balance of '250' tokens should
     * be displayed to the user as '2.5' (250 / 10 ** 2).
     *
     * This function can be overridden to change the amont of decimals a token should have.
    */
    function deciamls() public view virtual returns (uint8) {
        return 18;
    }

    /**
     * @dev Returns the total number of tokens that exist
    */
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the amount of tokens owned by the 'account'
    */
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Sends the 'amount' from the sender to the 'recipient'.
     *
     * Returns a boolean indicating the success or failure of the operation.
     *
     * Emits a {Transfer} event.
    */
    function transfer(address recipient, uint256 amount) external returns (bool) {
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev Returns the remaining number of tokens that the `spender` is allowed to
     * spend on behalf of `owner`.  This is zero by default. The value changes 
     * when {approve} or {transferFrom} are called
     */
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Sets the amount that a 'spender' can use over the caller's tokens. Because 
     * contracts cannot listen for events, they are not notified when they recieve tokens.
     * This is overcome with the allowance mechanism. This means payments are split into two steps:
     * 1. {approve} (this method): A user will approve the amount they are willing 
     *    to spend in the transaction.
     * 2. {transferFrom}: The user will call transferFrom and reset the allowance between two accounts.
     *
     * Returns a boolean indicating the success or failure of the operation.
     *
     * Emits a {Approval} event.
    */
    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev Sends the 'amount' of tokens from the 'sender' to the 'recipient' using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
    */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _allowances[sender][msg.sender] -= amount;
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @dev Used to mint new token supply. This implementation is marked as virtual
     * to allow a consuming contract to define its implementation.
     *
     * Emits a {Transfer} event.
    */
    function _mint(uint256 amount, address account) internal virtual {
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    /**
     * @dev Used to burn tokens from the total supply. This method is marked as virtual
     * to allow a consuming contract to define its implementation.
     * 
     * Emits a {Transfer} event.
    */
    function _burn(uint256 amount) internal virtual {
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(address(0), msg.sender, amount);
    }
}