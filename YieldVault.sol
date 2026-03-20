// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./IVaultStrategy.sol";

contract YieldVault is ERC4626, Ownable, ReentrancyGuard {
    IVaultStrategy public strategy;
    uint256 public constant FEE_DENOMINATOR = 10000;
    uint256 public performanceFee = 500; // 5%

    event StrategyUpdated(address indexed newStrategy);

    constructor(
        IERC20 _asset,
        string memory _name,
        string memory _symbol
    ) ERC4626(_asset) ERC20(_name, _symbol) Ownable(msg.sender) {}

    function setStrategy(address _strategy) external onlyOwner {
        require(_strategy != address(0), "Invalid strategy");
        strategy = IVaultStrategy(_strategy);
        emit StrategyUpdated(_strategy);
    }

    /**
     * @dev Overridden to deploy funds into the strategy upon deposit.
     */
    function _deposit(
        address caller,
        address receiver,
        uint256 assets,
        uint256 shares
    ) internal override nonReentrant {
        super._deposit(caller, receiver, assets, shares);
        
        if (address(strategy) != address(0)) {
            SafeERC20.safeApprove(IERC20(asset()), address(strategy), assets);
            strategy.deposit(assets);
        }
    }

    /**
     * @dev Overridden to pull funds from the strategy upon withdrawal.
     */
    function _withdraw(
        address caller,
        address receiver,
        address owner,
        uint256 assets,
        uint256 shares
    ) internal override nonReentrant {
        if (address(strategy) != address(0)) {
            uint256 vaultBalance = IERC20(asset()).balanceOf(address(this));
            if (vaultBalance < assets) {
                strategy.withdraw(assets - vaultBalance);
            }
        }
        super._withdraw(caller, receiver, owner, assets, shares);
    }

    function totalAssets() public view override returns (uint256) {
        uint256 strategyBalance = address(strategy) != address(0) ? strategy.balanceOf() : 0;
        return super.totalAssets() + strategyBalance;
    }
}
