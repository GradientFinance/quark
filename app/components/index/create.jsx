import { useEffect, useState, React } from 'react'
import {
  usePrepareContractWrite,
  useContractWrite,
  useWaitForTransaction,
} from 'wagmi'
import { factoryABI } from '../../abi/factory'


export function CreateModal({ factoryAddress, contractReader }) {
  const [name, setName] = useState('');
  const [collection, setCollection] = useState('0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D');
  const [denomination, setDenomination] = useState('0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6');

  const [coefficients, setCoefficients] = useState([-44, -63, 77, -28, 90]);
  const [intercept, setIntercept] = useState(242242);
  const [accuracy, setAccuracy] = useState(85);
  const [attributes, setAttributes] = useState(['Aquamarine', 'Prom Dress', 'Crazy', 'Black', 'Bored']);
  const [manipulationScore, setManipulationScore] = useState(0);
  const [openSource, setOpenSource] = useState(true);

  const { config } = usePrepareContractWrite({
    address: factoryAddress,
    abi: [{
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
        },
        {
          "internalType": "uint256",
          "name": "_manipulation",
          "type": "uint256"
        },
        {
          "internalType": "bool",
          "name": "_opensource",
          "type": "bool"
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
    }],
    functionName: 'createIndex',
    args: [coefficients, intercept, accuracy, attributes, collection, denomination, name, manipulationScore, openSource],
  })

  const { data, write } = useContractWrite(config)

  const { isLoading, isSuccess } = useWaitForTransaction({
    hash: data?.hash,
  })

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
              <input
                id="name"
                onChange={(e) => setName(e.target.value)}
                value={name}
                className="input input-bordered"
              />
            </div>
            <div className="form-control mb-2">
              <label className="label">
                <span className="label-text">Pricing Algorithm</span>
              </label>
              <input type="file" className="file-input file-input-bordered w-full" />
            </div>
            <div className="form-control mb-2">
              <label className="label">
                <span className="label-text">Collection address</span>
              </label>
              <input
                id="collection"
                onChange={(e) => setCollection(e.target.value)}
                value={collection}
                className="input input-bordered"
              />
            </div>
            <div className="form-control mb-2">
              <label className="label">
                <span className="label-text">Denominated in</span>
              </label>
              <input
                id="denomination"
                onChange={(e) => setDenomination(e.target.value)}
                value={denomination}
                className="input input-bordered"
              />
            </div>
            <button className={"btn btn-block space-x-2 mt-3" + (isLoading ? " loading" : "")} disabled={!write || isLoading}>
              {isLoading ? 'Creating Price Feed' :
                <div className="flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6 mr-2">
                    <path fill-rule="evenodd" d="M12 5.25a.75.75 0 01.75.75v5.25H18a.75.75 0 010 1.5h-5.25V18a.75.75 0 01-1.5 0v-5.25H6a.75.75 0 010-1.5h5.25V6a.75.75 0 01.75-.75z" clip-rule="evenodd" />
                  </svg>
                  Create Price Feed
                </div>
              }
            </button>
            {isSuccess ? <contractReader /> : ''}
          </form>
        </label>
      </label>
    </>
  );
}