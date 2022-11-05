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

export function IndexInfo() {
  return (
    <div className="bg-base-100 shadow rounded-xl">
      <div className="px-4 py-5 sm:px-6">
        <div className="-ml-2 -mt-2 flex flex-wrap items-baseline mb-4">
          <h3 className="ml-2 mt-2 text-lg font-medium leading-6 text-gray-900">✺ Price Feed Info</h3>
          <p className="ml-2 mt-1 truncate text-sm text-gray-500"> of all derivatives traded on this index hey</p>
        </div>
        <div className="overflow-x-auto">
          <div tabindex="0">
            <div class="flex items-center p-1">
              <span class="text-base-content/70 w-48 text-xs">Search Engines</span>
              <progress max="100" value="50" class="progress progress-success"></progress>
            </div>
            <div class="flex items-center p-1">
              <span class="text-base-content/70 w-48 text-xs">Direct</span>
              <progress max="100" value="30" class="progress progress-primary">
              </progress>
            </div>
            <div class="flex items-center p-1">
              <span class="text-base-content/70 w-48 text-xs">Social Media</span>
              <progress max="100" value="70" class="progress progress-secondary"></progress>
            </div>
            <div class="flex items-center p-1">
              <span class="text-base-content/70 w-48 text-xs">Emails</span>
              <progress max="100" value="90" class="progress progress-accent"></progress>
            </div>
            <div class="flex items-center p-1">
              <span class="text-base-content/70 w-48 text-xs">Ad campaigns</span>
              <progress max="100" value="65" class="progress progress-warning"></progress>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}