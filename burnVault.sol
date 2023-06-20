// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Amt.sol";

/**
 * @title BurnVault
 * @dev A contract for burning AMT tokens and withdrawing BTCB tokens in exchange.
 */

contract BurnVault is Ownable {

    event burnMade(uint256 amtBurned, uint256 btcbWithdrew);

    // Constants for token addresses
    address constant addrBtcb = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address constant addrAmt = 0x6Ae0A238a6f51Df8eEe084B1756A54dD8a8E85d3;

    // Instances of the ERC20 token contracts
    IERC20 constant btcb = IERC20(addrBtcb);
    AMT constant amt = AMT(addrAmt);

    constructor(){}
    /**
     * @dev Allows a user to burn AMT tokens and withdraw an equivalent amount of BTCB tokens.
     * @param amount The amount of AMT tokens to burn and withdraw BTCB tokens against.
     */
    function backingWithdraw(uint256 amount) public {
        uint256 totalSupply = amt.totalSupply();
        uint256 btcbToTransfer = (amount * btcb.balanceOf(address(this)))/totalSupply;

        // Burn AMT tokens from the sender's balance
        amt.burnFrom(msg.sender, amount);

        // Transfer the equivalent amount of BTCB tokens to the sender
        bool btcbTransferSuccess = btcb.transfer(msg.sender, btcbToTransfer);
        require(btcbTransferSuccess,"Transaction failed");

        // Emit event to track the burn and withdrawal transaction
        emit burnMade(amount, btcbToTransfer);
    }
}