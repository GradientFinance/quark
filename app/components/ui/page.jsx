import { React } from 'react'
import { WagmiConfig, createClient, chain } from "wagmi";
import { ConnectKitProvider, getDefaultClient } from "connectkit";

const alchemyId = process.env.ALCHEMY_ID;
const chains = [chain.mainnet, chain.rinkeby];

const client = createClient(
  getDefaultClient({
    appName: "App",
    alchemyId,
    chains,
  }),
);

export function Page({ children }) {
  return (
    <div className="h-full">
      <WagmiConfig client={client}>
        <ConnectKitProvider>
          {children}
        </ConnectKitProvider>
      </WagmiConfig>
    </div>
  );
};