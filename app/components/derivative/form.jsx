import React from "react";
import { useState, useEffect } from 'react'

export function Long({ setShortActive }) {
  return (
    <div className="col-span-3 row-span-3 mx-2 flex w-72 flex-shrink-0 flex-col xl:mx-0 xl:w-full svelte-1n6ue57">
      <div className="dropdown">
        <div tabindex="0" className="bg-opacity-100">
          <div className="tabs w-full flex-grow-0">
            <button className="tab tab-lifted tab-active tab-border-none tab-lg flex-1"><b className="mr-2">Long</b></button>
            <button className="tab tab-lifted tab-border-none tab-lg flex-1" onClick={setShortActive}>Short</button>
          </div>
        </div>
      </div>
      <div className="bg-base-100 grid w-full flex-grow rounded-xl rounded-tl-none p-6 shadow-xl pt-4">
        <div className="form-control">
          <label className="label">
            <span className="label-text">Strike</span>
          </label>
          <label className="input-group">
            <input type="text" placeholder="0.01" className="input input-bordered w-full" />
            <span>
              USDC
            </span>
          </label>
        </div>
        <div className="form-control">
          <label className="label">
            <span className="label-text">Expiration</span>
          </label>
          <label className="input-group">
            <input type="text" placeholder="30" className="input input-bordered w-full" />
            <span>days</span>
          </label>
        </div>
        <div className="form-control">
          <label className="label">
            <span className="label-text">Leverage</span>
          </label>
          <input type="range" min="0" max="100" defaultValue="40" className="range" />
          <div className="w-full flex justify-between text-xs px-2 mt-1">
            <span>1x</span>
            <span>5x</span>
            <span>10x</span>
            <span>15x</span>
            <span>20x</span>
            <span>25x</span>
            <span>30x</span>
          </div>
        </div>
        <div className="divider text-base-content/60 m-2">Long Put</div>
        <dl className="mb-4 space-y-2">
          <div className="flex items-center justify-between">
            <dt className="text-sm text-gray-600">Strike</dt>
            <dd className="text-sm font-medium text-gray-900">$99.00</dd>
          </div>
          <div className="flex items-center justify-between border-t border-gray-200 pt-2">
            <dt className="flex items-center text-sm text-gray-600">
              <span>Expiration</span>
            </dt>
            <dd className="text-sm font-medium text-gray-900">$5.00</dd>
          </div>
          <div className="flex items-center justify-between border-t border-gray-200 pt-2">
            <dt className="flex text-sm text-gray-600">
              <span>Tax estimate</span>
              <a href="#" className="ml-2 flex-shrink-0 text-gray-400 hover:text-gray-500">
                <span className="sr-only">Learn more about how tax is calculated</span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
                  <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zM8.94 6.94a.75.75 0 11-1.061-1.061 3 3 0 112.871 5.026v.345a.75.75 0 01-1.5 0v-.5c0-.72.57-1.172 1.081-1.287A1.5 1.5 0 108.94 6.94zM10 15a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
                </svg>
              </a>
            </dt>
            <dd className="text-sm font-medium text-gray-900">$8.32

              <button className="badge badge-ghost badge-sm">LTV 10%</button>
            </dd>
          </div>
          <div className="flex items-center justify-between border-t border-gray-200 pt-2">
            <dt className="text-base font-medium text-gray-900">Premium to pay</dt>
            <dd className="text-base font-medium text-gray-900">$112.32</dd>
          </div>
        </dl>
        <button className="btn btn-block space-x-2">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 19.5v-15m0 0l-6.75 6.75M12 4.5l6.75 6.75" />
          </svg>
          <span>Long</span>
        </button>
      </div>
    </div>
  )
}

export function Short({ setLongActive }) {
  return (
    <div className="col-span-3 row-span-3 mx-2 flex w-72 flex-shrink-0 flex-col xl:mx-0 xl:w-full svelte-1n6ue57">
      <div className="dropdown">
        <div tabindex="0" className="bg-opacity-100">
          <div className="tabs w-full flex-grow-0">
          <button className="tab tab-lifted tab-border-none tab-lg flex-1" onClick={setLongActive}>Long</button>
          <button className="tab tab-lifted tab-active tab-border-none tab-lg flex-1"><b className="mr-2">Short</b></button>
          </div>
        </div>
      </div>
      <div className="bg-base-100 grid w-full flex-grow rounded-xl rounded-tr-none p-6 shadow-xl pt-4">
        <div className="form-control">
          <label className="label">
            <span className="label-text">Strike</span>
          </label>
          <label className="input-group">
            <input type="text" placeholder="0.01" className="input input-bordered w-full" />
            <span>
              USDC
            </span>
          </label>
        </div>
        <div className="form-control">
          <label className="label">
            <span className="label-text">Expiration</span>
          </label>
          <label className="input-group">
            <input type="text" placeholder="30" className="input input-bordered w-full" />
            <span>days</span>
          </label>
        </div>
        <div className="form-control">
          <label className="label">
            <span className="label-text">Leverage</span>
          </label>
          <input type="range" min="0" max="100" defaultValue="40" className="range" />
          <div className="w-full flex justify-between text-xs px-2 mt-1">
            <span>1x</span>
            <span>5x</span>
            <span>10x</span>
            <span>15x</span>
            <span>20x</span>
            <span>25x</span>
            <span>30x</span>
          </div>
        </div>
        <div className="divider text-base-content/60 m-2">Long Put</div>
        <dl className="mb-4 space-y-2">
          <div className="flex items-center justify-between">
            <dt className="text-sm text-gray-600">Strike</dt>
            <dd className="text-sm font-medium text-gray-900">$99.00</dd>
          </div>
          <div className="flex items-center justify-between border-t border-gray-200 pt-2">
            <dt className="flex items-center text-sm text-gray-600">
              <span>Expiration</span>
            </dt>
            <dd className="text-sm font-medium text-gray-900">$5.00</dd>
          </div>
          <div className="flex items-center justify-between border-t border-gray-200 pt-2">
            <dt className="flex text-sm text-gray-600">
              <span>Tax estimate</span>
              <a href="#" className="ml-2 flex-shrink-0 text-gray-400 hover:text-gray-500">
                <span className="sr-only">Learn more about how tax is calculated</span>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5">
                  <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zM8.94 6.94a.75.75 0 11-1.061-1.061 3 3 0 112.871 5.026v.345a.75.75 0 01-1.5 0v-.5c0-.72.57-1.172 1.081-1.287A1.5 1.5 0 108.94 6.94zM10 15a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
                </svg>
              </a>
            </dt>
            <dd className="text-sm font-medium text-gray-900">$8.32

              <button className="badge badge-ghost badge-sm">LTV 10%</button>
            </dd>
          </div>
          <div className="flex items-center justify-between border-t border-gray-200 pt-2">
            <dt className="text-base font-medium text-gray-900">Premium to pay</dt>
            <dd className="text-base font-medium text-gray-900">$112.32</dd>
          </div>
        </dl>
        <button className="btn btn-block space-x-2">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 19.5v-15m0 0l-6.75 6.75M12 4.5l6.75 6.75" />
          </svg>
          <span>Long</span>
        </button>
      </div>
    </div>
  )
}

export function Form() {
  const [longActive, setLong] = useState(true)

  const setLongActive = event => {
    setLong(true);
  };

  const setShortActive = event => {
    setLong(false);
  };

  return (
    <>
      {longActive ? <Long setShortActive={setShortActive} /> : <Short setLongActive={setLongActive} />}
    </>
  )
}
