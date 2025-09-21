// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MTKPresale {
    IERC20 public token;
    address public owner;
    uint256 public price; // price per token in wei
    uint256 public totalRaised;

    event TokensPurchased(address indexed buyer, uint256 amount);

    constructor(address tokenAddress, uint256 tokenPrice) {
        token = IERC20(tokenAddress);
        owner = msg.sender;
        price = tokenPrice;
    }

    function buyTokens() public payable {
        uint256 amount = msg.value / price;
        require(amount > 0, "Send ETH to buy tokens");
        require(token.balanceOf(address(this)) >= amount, "Not enough tokens left");

        token.transfer(msg.sender, amount);
        totalRaised += msg.value;

        emit TokensPurchased(msg.sender, amount);
    }

    function withdrawETH() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }

    function withdrawUnsoldTokens() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 unsold = token.balanceOf(address(this));
        token.transfer(owner, unsold);
    }
}
