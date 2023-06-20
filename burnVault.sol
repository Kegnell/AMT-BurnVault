// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Amt.sol";
contract BurnVault is Ownable {

    event burnMade(uint256 amtBurned, uint256 btcbWithdrew);

    address constant addrBtcb = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address constant addrAmt = 0x6Ae0A238a6f51Df8eEe084B1756A54dD8a8E85d3;

    //For production
    /*
    IERC20 constant btcb = IERC20(addrBtcb);
    AMT constant amt = AMT(addrAmt);
    */

    //For testing
    IERC20  btcb;
    AMT  amt;
    constructor(address _amt, address _btcb){
        btcb = IERC20(_btcb);
        amt = AMT(_amt);
    }
   
    function backingWithdraw(uint256 amount) public {
        uint256 totalSupply = amt.totalSupply();
        amt.burnFrom(msg.sender, amount);
        uint256 btcbToTransfer = (amount * btcb.balanceOf(address(this)))/totalSupply;
        btcb.transfer(msg.sender, btcbToTransfer);
        emit burnMade(amount, btcbToTransfer);
    }
}