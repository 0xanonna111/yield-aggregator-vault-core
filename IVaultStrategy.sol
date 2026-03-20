// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVaultStrategy {
    function deposit(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function harvest() external returns (uint256);
    function balanceOf() external view returns (uint256);
    function asset() external view returns (address);
}
