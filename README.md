
<h1 align="center">
  <br>
  <a><img src="https://i.imgur.com/2wsNJE7.png" alt="Markdownify" width="300"></a>
  <br>
  Quark Protocol
  <br>
</h1>

  <h4 align="center">A first-of-its-kind derivatives exchange for the NFT space, built on top of on-chain pricing algorithms. It allows anyone to buy, sell, and create cash-settled derivatives (specifically European options) on any ERC721 collection.</h4>

<p align="center">
  <a href="#how-it-works">How it works</a> •
  <a href="#main-use-cases">Main use cases</a> •
  <a href="#how-it-is-made">How it is made</a> •
  <a href="#license">License</a>
</p>

![screenshot](https://storage.googleapis.com/ethglobal-api-production/projects%2F65szk%2Fimages%2Fphoto_2022-11-06_08-53-53.jpg)

## How it works

* Create index
  - Users can create indices tracking any type of collection and attributes. 

* Trade
  - Trade options on community-made indices and enjoy market efficiency. 

* Exercise
  - Enjoy the benefits of cash-settled options when exercising expired options. 
  
## Main use cases

* Hedging:
  - Buy put options in order to hedge downside risk. For example, if the price of a BAYC is currently $80,000 and you're worried about its price crashing, you can buy a put option with a strike price of $75,000. Then say the collection crashes to $50,000, you can still sell a BAYC for $75,000 using your put option. While you own the put option, you've basically created a price floor of $75,000 as the lowest amount you'll sell the BAYC at.

* Leverage:
  - Buy call options to gain leverage without having any liquidation risk. For example, if the BAYC price is currently at $80,000 and you think its price is going to increase, you could buy a call option with a strike price of $90,000 — this call option costs much less than buying a BAYC ERC721. Then say the BAYC price runs up to $100,000, you buy the BAYC at $90,000 using your call option. There is no liquidation risk because you are not putting down any collateral (no need to hold any NFT) to borrow - you are simply paying a premium to buy an option.

* Yield:
  - Sell put or call options to earn "high yield". In order to sell a put or call option, you put down collateral. When you sell the option, you earn a premium. Because selling options is higher risk than, say, lending in a money market, since you could be exercised if the option hits the strike price, you earn a higher premium for taking on that risk, which people often view as "high yield."
  - For example, if you think the BAYC price isn't going to move too much, you could sell a covered call on BAYC, earning the premium ("high yield" on BAYC), and if you aren't exercised, you can leave with your original collateral and your premium. However, it is important to remember the additional risk that comes with these positions.

## How it is made

Quark Protocol is represented in two different areas: interface (DApp/front-end) and smart contracts. The smart contracts are composed of a central exchange and a factory of indices. To understand what the factory does, it is important to lay out the pricing mechanisms of the protocol.

The protocol allows anyone to create a pricing index with the use of linear models and collection data. Say we want to create an index for a collection. To do so, we first select the metadata attributes we want to track and train a linear model off-chain. This linear model will generate a series of coefficients and an intercept, which are passed to the index factory to bring the whole model on-chain for future re-fitting on new data sales.

The index factory follows the gas-optimized clone factory pattern, which allows bringing dawn deployment costs while allowing any user to bring any type of linear model on-chain. The newly created index can return its current price, as well as request new data to train on.

Each index is equipped with its own custom access to the UMA protocol in order to submit a data request to the Optimism oracle when the index is requested to train on new data. This UMA request is formatted with the following ancillary format “Q: Was there a new sale for the collection (NFT collection address) containing (array of tracked attributes)?”.

With this request sent, a proposer will make a series of API requests to track the latest sale, filtered by the tracked attributes. These API requests include Covalent and Reservoir (Opensea, LooksRare, X2Y2, and more marketplaces). If there is a new sale, the proposer will pass the sale price to the index, which in hand would re-fit on this new data, returning a new index price. Thanks to the UMA protocol, the Quark ecosystem can be trusted as disputers supervise the work of the proposers.

The index contract also contains helper functions to, for example, return volume used with the index, options running on index count, and data for the interface.

On the other hand, we have the exchange contract, which plays a key role in matching option buyers and sellers, as well as locking collateral and ensuring payouts.

To get a put or call option, the option buyer needs to call the ‘requestOption’ function with the given option parameters (type of option, strike, expiry, and index to trade on). Now, an option seller can spot the request and send an offer to the option buyer (through the exchange using the ‘createOffer’ function) with a premium cost (that is lower than the previous one if any). If the option buyer is happy with this premium, they can execute the ‘acceptOffer’ function that pays the premium to the option seller, locks the option seller’s collateral, and mints an ERC721 token representing the option.

The holder of the ERC721 token has the power to exercise the option after its expiry using the ‘exerciseOption’ function, which calls the index to fetch the latest data and calculate profits or losses. This function pays the option seller and buyer and consequently burns the ERC721 token.

The contracts are deployed on Goerli, Polygon, Optimism, SKALE, Gnosis, and Evmos.

## How to deploy locally

This repo contains both the front-end and the smart contracts. Find the instructions to deploy the front-end [here](https://github.com/GradientFinance/quark/tree/main/app). The smart contracts run on top of [Foundry](https://book.getfoundry.sh/projects/working-on-an-existing-project).

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/GradientFinance/quark/blob/main/LICENSE) file
