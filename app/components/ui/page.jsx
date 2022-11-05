import { WagmiConfig, createClient } from "wagmi";
import { ConnectKitProvider, ConnectKitButton, getDefaultClient } from "connectkit";

const alchemyId = process.env.ALCHEMY_ID;

const client = createClient(
  getDefaultClient({
    appName: "Your App Name",
    alchemyId: alchemyId,
  }),
);

export function Page({ children }) {
  return (
    <WagmiConfig client={client}>
      <ConnectKitProvider>
        { children }
      </ConnectKitProvider>
    </WagmiConfig>
  );
};