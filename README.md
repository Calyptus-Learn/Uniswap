# UniswapV2 Pool

Features

- Create a UniswapV2 Liquidity pool for a token pair (Calyp token, Tus token)
- Add first liquidity to the pool, earn liquidity token.
  > The first liquidity provider to join a pool sets the initial exchange rate by depositing what they believe to be an equivalent value of Calyp and Tus tokens. If this ratio is off, arbitrage traders will bring the prices to equilibrium at the expense of the initial liquidity provider.
- Swap Calyp token for Tus token by any of the following methods:
  - swapSingleHopExactAmountIn (sells all tokens for another)
  - swapSingleHopExactAmountOut (buys specific amount of tokens set by the caller)
- Burn Liquidity tokens and remove liquidity you had provided.
