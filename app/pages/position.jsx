import { useEffect, React } from 'react'
import { Page } from 'components/ui/page'
import { Navbar } from 'components/ui/navbar'
import dynamic from "next/dynamic";

const ChartIndex = dynamic(() => import("../components/derivative/chart"), {
  ssr: false
});

export function Content() {
  return (
    <div className="px-4 py-4 sm:px-6 lg:px-8 bg-base-300">
      <div className='w-full grid-cols-3 gap-4 overflow-y-hidden overflow-x-scroll px-10 pt-1 pb-10 xl:grid xl:overflow-x-auto xl:px-4 svelte-1n6ue57'>
        <div className="col-span-2">
          <div className="bg-white w-full rounded-xl p-6 shadow-xl">
            <ChartIndex width={880} height={517} />
          </div>
        </div>
        <div className="col-span-1">
          Form
        </div>
        <div className="col-span-1">
          Index Info
        </div>
        <div className="col-span-1">
          Underlying
        </div>
        <div className="col-span-1">
          Orders
        </div>
      </div>
    </div>
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

