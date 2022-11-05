import { WagmiConfig, createClient, chain } from "wagmi";
import { ConnectKitProvider, getDefaultClient } from "connectkit";

const alchemyId = process.env.ALCHEMY_ID;

// Choose which chains you'd like to show
const chains = [chain.mainnet, chain.goerli, chain.optimism, chain.arbitrum];

const client = createClient(
  getDefaultClient({
    appName: "App",
    alchemyId,
    chains,
  }),
);

export function Page({ children }) {
  return (
    <WagmiConfig client={client}>
      <ConnectKitProvider>
        {children}
      </ConnectKitProvider>
    </WagmiConfig>
  );
};