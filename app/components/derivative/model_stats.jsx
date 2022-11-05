import React from "react";
import { useState, useEffect } from 'react'

export function ModelStats() {
  return (
    <>
      <input type="checkbox" id="modelStats" className="modal-toggle" />
      <label htmlFor="modelStats" className="modal">
        <label className="modal-box relative" htmlFor="">
          <h3 className="text-lg font-bold">Congratulations random Internet user!</h3>
          <p className="py-4">You've been selected for a chance to get one year of subscription to use Wikipedia for free!</p>
          <div class="grid gap-3">
            <div class="dropdown dropdown-top">
              <div tabindex="0">
                <div class="flex items-center p-1">
                  <span class="text-base-content/70 w-48 text-xs">Search Engines</span>
                  <progress max="100" value="50" class="progress progress-success"></progress>
                </div>
                <div class="flex items-center p-1">
                  <span class="text-base-content/70 w-48 text-xs">Direct</span>
                  <progress max="100" value="30" class="progress progress-primary"></progress>
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
                  <span class="text-base-content/70 w-48 text-xs ml-4">Ad campaigns</span>
                </div>
              </div>
            </div>
          </div>
        </label>
      </label>
    </>
  )
}