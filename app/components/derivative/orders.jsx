import React from "react";

const sales = [
  {
    secondsAgo: '1',
    type: 'Long',
    strike: '82',
    expiration: '23',
    leverage: '1'
  }
]

export function Orders() {
  return (
    <div className="bg-base-100 shadow rounded-xl">
      <div className="px-4 py-5 sm:px-6">
        <div className="-ml-2 -mt-2 flex flex-wrap items-baseline mb-4">
          <h3 className="ml-2 mt-2 text-lg font-medium leading-6 text-gray-900">✺ Orderbook</h3>
          <p className="ml-2 mt-1 truncate text-sm text-gray-500"> of all derivatives traded on this index hey</p>
        </div>
        <div className="overflow-x-auto">
          <table className="table table-compact w-full">
            <thead>
              <tr>
                <th>
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-4 h-4">
                    <path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25zM12.75 6a.75.75 0 00-1.5 0v6c0 .414.336.75.75.75h4.5a.75.75 0 000-1.5h-3.75V6z" clip-rule="evenodd" />
                  </svg>
                </th>
                <th>Type</th>
                <th>Strike</th>
                <th>Expiration</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              {sales.map((sale, index) => (
                <tr>
                  <td>{sale.secondsAgo}s ago</td>
                  <td>{sale.type}</td>
                  <td>{sale.strike} ETH</td>
                  <td>In {sale.expiration} days</td>
                  <td>{sale.leverage}x</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}