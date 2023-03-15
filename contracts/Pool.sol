// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "contracts/Cal.sol";
import "contracts/Tus.sol";

contract Pool {
    IUniswapV2Router02 public uniswapV2Router =
        IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address public uniswapV2Pair;

    Calyp public calyp;
    Tus public tus;

    constructor() {
        // deploying two tokens
        calyp = new Calyp();
        tus = new Tus();

        // creating UniswapV2 Pair for the the two tokens
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(calyp),
                address(tus)
            );
    }

    /* 
    The first liquidity provider to join a pool sets the initial exchange rate by depositing what they believe to be an equivalent value of Calyp and Tus tokens. If this ratio is off, arbitrage traders will bring the prices to equilibrium at the expense of the initial liquidity provider.
     */
    function addLiquidity(
        uint _amountA,
        uint _amountB
    ) external returns (uint amountA, uint amountB, uint liquidity) {
        calyp.transferFrom(msg.sender, address(this), _amountA);
        tus.transferFrom(msg.sender, address(this), _amountB);

        calyp.approve(address(uniswapV2Router), _amountA);
        tus.approve(address(uniswapV2Router), _amountB);

        (amountA, amountB, liquidity) = uniswapV2Router.addLiquidity(
            address(calyp),
            address(tus),
            _amountA,
            _amountB,
            1,
            1,
            address(this),
            block.timestamp
        );
    }

    /* 
    Liquidity is withdrawn at the same ratio as the reserves at the time of withdrawal. If the exchange rate is bad there is a profitable arbitrage opportunity that will correct the price.
     */
    function removeLiquidity() external returns (uint amountA, uint amountB) {
        uint liquidity = IERC20(uniswapV2Pair).balanceOf(address(this));
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), liquidity);

        (amountA, amountB) = uniswapV2Router.removeLiquidity(
            address(calyp),
            address(tus),
            liquidity,
            1,
            1,
            address(this),
            block.timestamp
        );
        calyp.transfer(msg.sender, amountA);
        tus.transfer(msg.sender, amountB);
    }

    function swapSingleHopExactAmountIn(
        uint amountIn,
        uint amountOutMin,
        address fromToken,
        address toToken
    ) external returns (uint amountOut) {
        IERC20(fromToken).transferFrom(msg.sender, address(this), amountIn);
        IERC20(fromToken).approve(address(uniswapV2Router), amountIn);

        address[] memory path;
        path = new address[](2);
        path[0] = address(fromToken);
        path[1] = address(toToken);

        uint[] memory amounts = uniswapV2Router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            msg.sender,
            block.timestamp
        );

        // send swapped token to the caller
        uint toSend = IERC20(toToken).balanceOf(address(this));
        require(
            IERC20(toToken).transfer(msg.sender, toSend),
            "Transfer Failed"
        );

        return toSend;
    }

    function swapSingleHopExactAmountOut(
        uint amountOutDesired,
        uint amountInMax,
        address fromToken,
        address toToken
    ) external returns (uint amountOut) {
        IERC20(fromToken).transferFrom(msg.sender, address(this), amountInMax);
        IERC20(fromToken).approve(address(uniswapV2Router), amountInMax);

        address[] memory path;
        path = new address[](2);
        path[0] = fromToken;
        path[1] = toToken;

        uint[] memory amounts = uniswapV2Router.swapTokensForExactTokens(
            amountOutDesired,
            amountInMax,
            path,
            msg.sender,
            block.timestamp
        );

        // Refund residue calyp to msg.sender
        if (amounts[0] < amountInMax) {
            IERC20(fromToken).transfer(msg.sender, amountInMax - amounts[0]);
        }

        // send swapped token to the caller
        uint toSend = IERC20(toToken).balanceOf(address(this));
        require(
            IERC20(toToken).transfer(msg.sender, toSend),
            "Transfer Failed"
        );

        return amounts[1];
    }
}
