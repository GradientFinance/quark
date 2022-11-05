import { useEffect, React } from 'react'
import { Page } from 'components/ui/page'
import { Navbar } from 'components/ui/navbar'


export function Content() {
  return (
    <div className='w-full grid-cols-3 gap-4 overflow-y-hidden overflow-x-scroll grid'>
      <div className="col-span-2">
        <div className="bg-white w-full rounded-xl p-6 shadow-xl">
          Chart
        </div>
      </div>
      <div className="col-span-1">
        Form
      </div>
      <div className="col-span-1">
        Index Info
      </div>
      <div className="col-span-1">
        Underlying market info
      </div>
      <div className="col-span-1">
        Orders
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

