const sales = [
  {
    secondsAgo: '1',
    type: 'Long',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Long',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Long',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Long',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Long',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
]

export function MakeBid() {
  return (
    <>
      <input type="checkbox" id="my-modal-4" className="modal-toggle" />
      <label htmlFor="my-modal-4" className="modal cursor-pointer">
        <label className="modal-box relative" htmlFor="">
          <h3 className="text-lg font-bold">Congratulations random Internet user!</h3>
          <p className="py-4">You've been selected for a chance to get one year of subscription to use Wikipedia for free!</p>
        </label>
      </label>
    </>
  )
}

export function Bids() {
  return (
    <>
      <div class="hero from-primary to-secondary text-primary-content min-h-screen[50%] bg-gradient-to-br">
        <div class="hero-content mx-auto max-w-md text-center md:max-w-full">
          <div>
            <h2 class="mb-2 text-4xl font-extrabold md:text-6xl">Fulfill Orders</h2>
            <h3 class="mb-5 text-3xl font-bold">Apply your own design decisions</h3>
            <p class="mx-auto mb-5 w-full max-w-lg">daisyUI adds a set of semantic color names to Tailwind. So instead of using constant color names like
              <span class="badge badge-ghost">bg-blue-500</span>, we
            </p>
            <div className="overflow-x-auto w-full">
              <table className="table w-full bg-trasparent">
                <thead>
                  <tr className="text-center">
                    <th className="bg-base-100/[.1] text-center">Type</th>
                    <th className="bg-base-100/[.1] text-center">Strike</th>
                    <th className="bg-base-100/[.1] text-center">Expiration</th>
                    <th className="bg-base-100/[.1] text-center">Leverage</th>
                    <th className="bg-base-100/[.1]"></th>
                  </tr>
                </thead>
                <tbody>
                  {sales.map((sale, index) => (
                    <tr>
                      <td className="bg-base-100/[.04] text-center">{sale.type}</td>
                      <td className="bg-base-100/[.04] text-center">{sale.strike} ETH</td>
                      <td className="bg-base-100/[.04] text-center">In {sale.expiration} days</td>
                      <td className="bg-base-100/[.04] text-center">{sale.leverage}x</td>
                      <td className="bg-base-100/[.04] text-center">
                        <label htmlFor="my-modal-4">
                          <span class="badge badge-outline badge-lg">Bid</span>
                        </label>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      <MakeBid />
    </>
  )
}