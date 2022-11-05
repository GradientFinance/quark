const sales = [
  {
    secondsAgo: '1',
    type: 'Put',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Put',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Put',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Put',
    strike: '82',
    expiration: '23',
    leverage: '1'
  },
  {
    secondsAgo: '1',
    type: 'Put',
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
          <h3 className="text-lg font-bold">Make bid</h3>
          <p className="py-4">The buyer will then choose whether to accept your bid.</p>
          <div className="form-control">
            <label className="label">
              <span className="label-text">Enter amount</span>
            </label>
            <label className="input-group">
              <span>BTC</span>
              <input type="text" placeholder="0.01" className="input input-bordered" />
              <button className="btn btn-square">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15.042 21.672L13.684 16.6m0 0l-2.51 2.225.569-9.47 5.227 7.917-3.286-.672zM12 2.25V4.5m5.834.166l-1.591 1.591M20.25 10.5H18M7.757 14.743l-1.59 1.59M6 10.5H3.75m4.007-4.243l-1.59-1.59" />
                </svg>
              </button>
            </label>
          </div>
        </label>
      </label>
    </>
  )
}

export function Bids() {
  return (
    <>
      <div class="hero from-primary to-secondary text-primary-content min-h-screen[50%] bg-gradient-to-br">
        <div class="hero-content mx-auto max-w-md text-center md:max-w-full my-10">
          <div>
            <h3 class="mb-5 text-3xl font-bold">Fill Orders</h3>
            <div className="overflow-x-auto w-full">
              <table className="table w-full bg-trasparent">
                <thead>
                  <tr className="text-center">
                    <th className="bg-base-100/[.1] text-center"></th>
                    <th className="bg-base-100/[.1] text-center">Strike</th>
                    <th className="bg-base-100/[.1] text-center">Expiration</th>
                    <th className="bg-base-100/[.1] text-center">Leverage</th>
                    <th className="bg-base-100/[.1] text-center">Best Premium</th>
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
                        <span class="badge badge-ghost"><a href="#">1.402 ETH</a></span>
                      </td>
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