import { useEffect, useState, React } from 'react'
import {
  usePrepareContractWrite,
  useContractWrite,
  useContractRead,
} from 'wagmi'
import useSWR from "swr";


export function CreateModal() {
  const [name, setName] = useState('BAYC Index 5');
  const [coefficients, setCoefficients] = useState([-44, -63, 77, -28, 90]);
  const [intercept, setIntercept] = useState(242242);
  const [accuracy, setAccuracy] = useState(85);
  const [attributes, setAttributes] = useState(['Aquamarine', 'Prom Dress', 'Crazy', 'Black', 'Bored']);
  const [collection, setCollection] = useState('0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D');
  const [denomination, setDenomination] = useState('0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6');

  const { config } = usePrepareContractWrite({
    address: '0xc220324bef6a5ccdc181d772c14d859be40b870b',
    abi: [
      {
        "inputs": [
          {
            "internalType": "int256[]",
            "name": "_coefficients",
            "type": "int256[]"
          },
          {
            "internalType": "int256",
            "name": "_intercept",
            "type": "int256"
          },
          {
            "internalType": "uint8",
            "name": "_accuracy",
            "type": "uint8"
          },
          {
            "internalType": "string[]",
            "name": "_attributes",
            "type": "string[]"
          },
          {
            "internalType": "address",
            "name": "_collection",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "_denomination",
            "type": "address"
          },
          {
            "internalType": "string",
            "name": "_name",
            "type": "string"
          }
        ],
        "name": "createIndex",
        "outputs": [
          {
            "internalType": "address",
            "name": "index",
            "type": "address"
          }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
      },
    ],
    functionName: 'createIndex',
    args: [coefficients, intercept, accuracy, attributes, collection, denomination, name],
  })

  const { data, write } = useContractWrite(config);
  return (
    <>
      <input type="checkbox" id="my-modal-3" className="modal-toggle" />
      <label htmlFor="my-modal-3" className="modal cursor-pointer">
        <label className="modal-box relative" htmlFor="">
          <h3 className="text-lg font-bold">Congratulations random Internet user!</h3>
          <p className="py-4">You've been selected for a chance to get one year of subscription to use Wikipedia for free!</p>
          <ul className="steps">
            <li className="step step-primary">Register</li>
            <li className="step step-primary">Choose plan</li>
            <li className="step">Purchase</li>
            <li className="step">Receive Product</li>
          </ul>
          <form
            onSubmit={(e) => {
              e.preventDefault()
              write?.()
            }}>
            <div className="form-control mb-2">
              <label className="label">
                <span className="label-text">Name</span>
              </label>
              <input type="text" placeholder="0.01" className="input input-bordered" />
            </div>
            <div className="form-control mb-2">
              <label className="label">
                <span className="label-text">Collection address</span>
              </label>
              <input type="text" placeholder="0.01" className="input input-bordered" />
            </div>
            <div className="form-control mb-2">
              <label className="label">
                <span className="label-text">Name</span>
              </label>
              <input type="text" placeholder="0.01" className="input input-bordered" />
            </div>
            <div className="form-control mb-5">
              <label className="label">
                <span className="label-text">Name</span>
              </label>
              <input type="file" className="file-input file-input-bordered w-full" />
            </div>
            <div className="form-control mb-2">
              <select className="select select-bordered w-full">
                <option disabled selected>Pick your favorite Simpson</option>
                <option>Homer</option>
                <option>Marge</option>
                <option>Bart</option>
                <option>Lisa</option>
                <option>Maggie</option>
              </select>
            </div>
            <button className="btn btn-block space-x-2 mt-3">
              <div className="flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6 mr-2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m0 0l6.75-6.75M12 19.5l-6.75-6.75" />
                </svg>
                Buy Put
              </div>
            </button>
          </form>
        </label>
      </label>
    </>
  );
}