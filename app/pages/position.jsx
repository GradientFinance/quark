import { useEffect, React } from 'react'
import { Page } from 'components/ui/page'
import { Navbar } from 'components/ui/navbar'
import { Form } from "components/derivative/form";
import { Positions } from "components/derivative/positions";
import { Bar } from "components/derivative/bar";
import { Orders } from "components/derivative/orders";
import { Bids } from "components/derivative/bids";
import { Chart } from "components/derivative/chart";
import dynamic from "next/dynamic";

export function Content() {
  return (
    <>
      <div className="px-4 py-4 sm:px-6 lg:px-8 bg-base-300">
        <div className='w-full grid-cols-3 gap-4 overflow-y-hidden overflow-x-scroll px-10 pt-1 pb-10 xl:grid xl:overflow-x-auto xl:px-4 svelte-1n6ue57'>
          <div className='col-span-3'>
            <Bar />
          </div>
          <div className="col-span-2">
            <Chart />
          </div>
          <div className="col-span-1 h-full">
            <Form index={"placeholder"} />
          </div>
          <div className="col-span-2">
            <Positions />
          </div>
          <div className="col-span-1">
            <Orders />
          </div>
        </div>
      </div>
      <Bids />
    </>
  )
}

export default function App() {
  useEffect(() => {
    document.title = "Indices";
    document.documentElement.setAttribute("data-theme", "cupcake");
    document.documentElement.className = 'bg-base-300';
  });

  return (
    <Page>
      <Navbar />
      <Content />
    </Page>
  );
};

