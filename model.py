
class circuit:
    def __init__(self, balance_long=0, balance_short=0, balance_eth=0, balance_collateral=0, collateralPerPair=1, uniswap_long_price=4):
        self.balance_long = balance_long
        self.balance_short = balance_short
        self.balance_eth = balance_eth
        self.balance_collateral = balance_collateral

        self.collateralPerPair = collateralPerPair
        self.uniswap_long_price = uniswap_long_price  # in eth
        self.uniswap_short_price = 1 / self.uniswap_long_price  # in eth
        self.normalization_factor = 1

    def create(self, tokensToCreate):
        assert (tokensToCreate > 0)
        collateralAmount = tokensToCreate * self.collateralPerPair
        assert (collateralAmount <= self.balance_eth)

        self.balance_eth -= collateralAmount
        self.balance_collateral += collateralAmount

        self.balance_long += tokensToCreate
        self.balance_short += tokensToCreate * self.normalization_factor

    def redeem(self, tokensToRedeem):
        assert (tokensToRedeem > 0)
        assert (self.balance_long >= tokensToRedeem)
        assert (self.balance_short >= tokensToRedeem)

        self.balance_long -= tokensToRedeem
        self.balance_short -= tokensToRedeem * (self.normalization_factor)

        collateralAmount = tokensToRedeem * self.collateralPerPair
        self.balance_eth += collateralAmount
        self.balance_collateral -= collateralAmount

    # sell long or short for eth
    def sell(self, longAmountToSell = 0, shortAmountToSell = 0):
        assert (shortAmountToSell > 0 and longAmountToSell >= 0 or shortAmountToSell >= 0 and longAmountToSell > 0)
        assert (self.balance_long >= longAmountToSell and self.balance_short >= shortAmountToSell)

        self.balance_long -= longAmountToSell
        self.balance_short -= shortAmountToSell

        self.balance_eth += longAmountToSell*self.uniswap_long_price + shortAmountToSell*self.uniswap_short_price

    # buy long or short with eth
    def buy(self, longAmountToBuy = 0, shortAmountToBuy = 0):
        assert (shortAmountToBuy > 0 and longAmountToBuy >= 0 or shortAmountToBuy >= 0 and longAmountToBuy > 0)
        total_eth = longAmountToBuy*self.uniswap_long_price + shortAmountToBuy*self.uniswap_short_price
        assert (self.balance_eth >= total_eth)
        self.balance_eth -= total_eth
        self.balance_long += longAmountToBuy
        self.balance_short += shortAmountToBuy


    def changePrice(self, newLongPrice=0, newShortPrice=0):
        assert (newLongPrice > 0 and newShortPrice ==
                0 or newLongPrice == 0 and newShortPrice > 0)
        if newLongPrice == 0:
            newLongPrice = 1 / newShortPrice
        else:
            newShortPrice = 1 / newLongPrice

        self.uniswap_long_price = newLongPrice
        self.uniswap_short_price = newShortPrice

    def changeNormalizationFactor(self, newNormalizationFactor):
        assert (newNormalizationFactor > 0)
        self.normalization_factor = newNormalizationFactor

    def addETH(self, amountToAdd):
        assert (amountToAdd > 0)

        self.balance_eth += amountToAdd

    def __repr__(self):
        print("Longs: ", self.balance_long)
        print("Shorts: ", self.balance_short)
        print("ETH: ", self.balance_eth)
        print("Collateral: ", self.balance_collateral)
        print("Uniswap Long Price: ", self.uniswap_long_price)
        print("Uniswap Short Price: ", self.uniswap_short_price)
        return ""


def test(c: circuit):
    c.addETH(10)

    c.create(2)
    # we halve the price of the long token
    c.changeNormalizationFactor(0.5)
    #c.changePrice(newLongPrice=0.000000001)

    c.redeem(2)


c = circuit(uniswap_long_price=1)
test(c)
print(c)