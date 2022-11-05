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
        </label>
      </label>
    </>
  )
}