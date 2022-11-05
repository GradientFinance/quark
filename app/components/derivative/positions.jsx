import React from "react";

const orders = [
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

export function ActivePositions() {
  return (
    <div className="overflow-x-auto">
      <table className="table table-compact w-full">
        <thead>
          <tr>
            <th>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
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
          {orders.map((order, index) => (
            <tr>
              <td>{order.secondsAgo}s ago</td>
              <td>{order.type}</td>
              <td>{order.strike} ETH</td>
              <td>In {order.expiration} days</td>
              <td>{order.leverage}x</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export function NoActivePositions() {
  return (
    <div
      className="relative block w-full rounded-lg border-2 border-dashed border-gray-300 p-12 text-center hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">
      <svg xmlns="//www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" className="mx-auto h-9 w-9 text-gray-300">
        <path strokeLinecap="round" strokeLinejoin="round" d="M21 7.5l-2.25-1.313M21 7.5v2.25m0-2.25l-2.25 1.313M3 7.5l2.25-1.313M3 7.5l2.25 1.313M3 7.5v2.25m9 3l2.25-1.313M12 12.75l-2.25-1.313M12 12.75V15m0 6.75l2.25-1.313M12 21.75V19.5m0 2.25l-2.25-1.313m0-16.875L12 2.25l2.25 1.313M21 14.25v2.25l-2.25 1.313m-13.5 0L3 16.5v-2.25" />
      </svg>
      <span className="mt-5 block text-sm font-medium">You haven't taken any positions.</span>
    </div>
  )
}

export function Positions() {
  return (
    <div className="card bg-base-100 shadow-xl">
      <div className="card-body">
        <h2 className="card-title">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6.429 9.75L2.25 12l4.179 2.25m0-4.5l5.571 3 5.571-3m-11.142 0L2.25 7.5 12 2.25l9.75 5.25-4.179 2.25m0 0L21.75 12l-4.179 2.25m0 0l4.179 2.25L12 21.75 2.25 16.5l4.179-2.25m11.142 0l-5.571 3-5.571-3" />
          </svg>
          Active positions
        </h2>
        {orders.length > 0 ? <ActivePositions /> : <NoActivePositions />}
      </div>
    </div>
  )
}