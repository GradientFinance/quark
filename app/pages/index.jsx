import { useState } from 'react'
import { useEffect, React } from 'react'
import { Page } from 'components/ui/page'

export function Content() {
  return (
    <>
      <div className="overflow-x-auto">
        <table className="table w-full">
          <thead>
            <tr>
              <th>
                <div className="flex items-center">
                  <h2>Name</h2>
                </div>
              </th>
              <th>
                <div className="flex items-center">
                  <h2>Price</h2>
                </div>
              </th>
              <th>
                <div className="flex items-center">
                  <h2>Volume</h2>
                </div>
              </th>
              <th>
                <div className="flex items-center">
                  <h2>Tracked</h2>
                </div>
              </th>
              <th>
                <div className="flex items-center">
                  <h2>Accuracy</h2>
                </div>
              </th>
              <th>
                <div className="flex items-center">
                  <h2>Manipulation Risk</h2>
                </div>
              </th>
              <th>
                <div className="flex items-center">
                  <h2>Open-sourced</h2>
                </div>
              </th>
            </tr>
          </thead>
        </table>
      </div>
    </>
  )
}



export default function App() {
  useEffect(() => {
    document.title = "Indices";
  });

  return (
    <Page>
      <Content />
    </Page>
  );
};
