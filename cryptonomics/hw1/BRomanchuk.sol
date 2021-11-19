// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/access/Ownable.sol";

//Safe Math Interface
contract SafeMath {
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 

contract BRCToken is Ownable, ERC20, SafeMath {
    
    uint private constant _maxSupply = 1000000000000000000000000000000000000;
                                        
    constructor() ERC20("BRCToken", "BRC") {
    }
    
    function destroy() public onlyOwner{
        selfdestruct(payable(owner()));
    }
    
    receive() external payable {
        require(msg.value > 0, "No ETH");
        uint avaliableSupply = _maxSupply - totalSupply();
        
        uint requestedSupply = safeMul(msg.value, 100);
        
        if (avaliableSupply >= requestedSupply) {
            payable(owner()).transfer(msg.value);
            _mint(msg.sender, requestedSupply);
        } else {
            uint ethForOwner = safeDiv(avaliableSupply, 100);
            payable(owner()).transfer(ethForOwner);
            _mint(msg.sender, avaliableSupply);
            payable(msg.sender).transfer(safeSub(msg.value, ethForOwner));
        }
    }
}
