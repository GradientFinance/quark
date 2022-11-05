export function Positions() {
  return (
    <div className="overflow-hidden bg-base-100 shadow sm:rounded-xl">
      <div className="px-4 py-5 sm:px-6">
        <div className="-ml-2 -mt-2 flex flex-wrap items-baseline mb-4">
          <h3 className="ml-2 mt-2 text-lg font-medium leading-6 text-gray-900">Active Positions</h3>
        </div>
        <div
          className="relative block w-full rounded-lg border-2 border-dashed border-gray-300 p-12 text-center hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
        >
          <svg xmlns="//www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" className="mx-auto h-9 w-9 text-gray-300">
            <path strokeLinecap="round" strokeLinejoin="round" d="M21 7.5l-2.25-1.313M21 7.5v2.25m0-2.25l-2.25 1.313M3 7.5l2.25-1.313M3 7.5l2.25 1.313M3 7.5v2.25m9 3l2.25-1.313M12 12.75l-2.25-1.313M12 12.75V15m0 6.75l2.25-1.313M12 21.75V19.5m0 2.25l-2.25-1.313m0-16.875L12 2.25l2.25 1.313M21 14.25v2.25l-2.25 1.313m-13.5 0L3 16.5v-2.25" />
          </svg>
          <span className="mt-5 block text-sm font-medium text-gray-900">You haven't taken any positions.</span>
        </div>
      </div>
    </div>
  )
}