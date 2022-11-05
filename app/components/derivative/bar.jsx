export function Bar() {
  return (
    <>
      <div className="navbar bg-base-200 shadow-lg rounded-xl ">
        <div className="flex-1">
          <div className="flex items-center space-x-4 p-5">
            <div className="avatar placeholder">
              <div className="rounded-full w-12 ring ring-primary-content ring-offset-base-100 ring-offset-2">
                <img src="https://images.blur.io/_blur-prod/0x60bb1e2aa1c9acafb4d34f71585d7e959f387769/143-07ffc842bd7fe913?w=64&h=64" alt="Avatar Tailwind CSS Component" />
              </div>
            </div>
            <div>
              <div className="font-bold">Hedonic Price Index</div>
              <a href='#'>
                <span className="badge badge-ghost">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4 mr-2">
                    <path fill-rule="evenodd" d="M9.638 1.093a.75.75 0 01.724 0l2 1.104a.75.75 0 11-.724 1.313L10 2.607l-1.638.903a.75.75 0 11-.724-1.313l2-1.104zM5.403 4.287a.75.75 0 01-.295 1.019l-.805.444.805.444a.75.75 0 01-.724 1.314L3.5 7.02v.73a.75.75 0 01-1.5 0v-2a.75.75 0 01.388-.657l1.996-1.1a.75.75 0 011.019.294zm9.194 0a.75.75 0 011.02-.295l1.995 1.101A.75.75 0 0118 5.75v2a.75.75 0 01-1.5 0v-.73l-.884.488a.75.75 0 11-.724-1.314l.806-.444-.806-.444a.75.75 0 01-.295-1.02zM7.343 8.284a.75.75 0 011.02-.294L10 8.893l1.638-.903a.75.75 0 11.724 1.313l-1.612.89v1.557a.75.75 0 01-1.5 0v-1.557l-1.612-.89a.75.75 0 01-.295-1.019zM2.75 11.5a.75.75 0 01.75.75v1.557l1.608.887a.75.75 0 01-.724 1.314l-1.996-1.101A.75.75 0 012 14.25v-2a.75.75 0 01.75-.75zm14.5 0a.75.75 0 01.75.75v2a.75.75 0 01-.388.657l-1.996 1.1a.75.75 0 11-.724-1.313l1.608-.887V12.25a.75.75 0 01.75-.75zm-7.25 4a.75.75 0 01.75.75v.73l.888-.49a.75.75 0 01.724 1.313l-2 1.104a.75.75 0 01-.724 0l-2-1.104a.75.75 0 11.724-1.313l.888.49v-.73a.75.75 0 01.75-.75z" clip-rule="evenodd" />
                  </svg>
                  Cryptopunks
                </span>
              </a>
            </div>
          </div>
        </div>
        <div className="flex-none gap-2">
          <div className="stats stats-vertical lg:stats-horizontal shadow-0 bg-transparent overflow-hidden">
            <div className="stat py-1">
              <div className="stat-title">
                Price
              </div>
              <div className="stat-val">
                <div className="flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4 mr-1">
                    <path d="M10.75 10.818v2.614A3.13 3.13 0 0011.888 13c.482-.315.612-.648.612-.875 0-.227-.13-.56-.612-.875a3.13 3.13 0 00-1.138-.432zM8.33 8.62c.053.055.115.11.184.164.208.16.46.284.736.363V6.603a2.45 2.45 0 00-.35.13c-.14.065-.27.143-.386.233-.377.292-.514.627-.514.909 0 .184.058.39.202.592.037.051.08.102.128.152z" />
                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-6a.75.75 0 01.75.75v.316a3.78 3.78 0 011.653.713c.426.33.744.74.925 1.2a.75.75 0 01-1.395.55 1.35 1.35 0 00-.447-.563 2.187 2.187 0 00-.736-.363V9.3c.698.093 1.383.32 1.959.696.787.514 1.29 1.27 1.29 2.13 0 .86-.504 1.616-1.29 2.13-.576.377-1.261.603-1.96.696v.299a.75.75 0 11-1.5 0v-.3c-.697-.092-1.382-.318-1.958-.695-.482-.315-.857-.717-1.078-1.188a.75.75 0 111.359-.636c.08.173.245.376.54.569.313.205.706.353 1.138.432v-2.748a3.782 3.782 0 01-1.653-.713C6.9 9.433 6.5 8.681 6.5 7.875c0-.805.4-1.558 1.097-2.096a3.78 3.78 0 011.653-.713V4.75A.75.75 0 0110 4z" clip-rule="evenodd" />
                  </svg>
                  <h2>24,942 ETH</h2>
                </div>
              </div>
            </div>

            <div className="stat py-1">
              <div className="stat-title">
                Volume
              </div>
              <div className="stat-val">
                <div className="flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-4 h-4 mr-1">
                    <path d="M15.5 2A1.5 1.5 0 0014 3.5v13a1.5 1.5 0 001.5 1.5h1a1.5 1.5 0 001.5-1.5v-13A1.5 1.5 0 0016.5 2h-1zM9.5 6A1.5 1.5 0 008 7.5v9A1.5 1.5 0 009.5 18h1a1.5 1.5 0 001.5-1.5v-9A1.5 1.5 0 0010.5 6h-1zM3.5 10A1.5 1.5 0 002 11.5v5A1.5 1.5 0 003.5 18h1A1.5 1.5 0 006 16.5v-5A1.5 1.5 0 004.5 10h-1z" />
                  </svg>
                  <h2>24,942 ETH</h2>
                </div>
              </div>
            </div>

            <div className="stat py-1">
              <div className="stat-title">
                Volatility
              </div>
              <div className="stat-val">
                <div className="flex items-center">
                  <a href='#'>
                    <span className="badge badge-success badge-sm m-0"><b>1D:</b>42.05%</span><br />
                    <span className="badge badge-error badge-sm m-0"><b>7D:</b>-42.05%</span>
                  </a>
                </div>
              </div>
            </div>

            <div className="stat py-1">
              <div className="stat-title">
                Tracked
              </div>
              <div className="stat-val">
                <a className="tooltip tooltip-bottom" data-tip="Entire collection is tracked" href='#'>
                  <div className="avatar-group -space-x-6">
                    <div className="avatar">
                      <div className="w-12">
                        <img src="https://img.seadn.io/files/6aa7878172728461d4d670c0042cabf1.png?fit=max&w=1000" />
                      </div>
                    </div>
                    <div className="avatar">
                      <div className="w-12">
                        <img src="https://img.seadn.io/files/1b246fd7b45666783491471ad57d9295.png?fit=max&w=1000" />
                      </div>
                    </div>
                    <div className="avatar">
                      <div className="w-12">
                        <img src="https://img.seadn.io/files/dfc7ff5a7feab944d0c76213495d08a8.png?fit=max&w=1000" />
                      </div>
                    </div>
                    <div className="avatar placeholder">
                      <div className="w-12 bg-primary-focus text-primary-content">
                        <span>+99</span>
                      </div>
                    </div>
                  </div>
                </a>
              </div>
            </div>

            <div className="stat py-1">
              <div className="stat-title">
                Accuracy
              </div>
              <div className="stat-val">
                <div className="flex items-center">
                  <div className="tooltip tooltip-bottom" data-tip="Verified using zkSNARKs">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5 mr-2">
                      <path fill-rule="evenodd" d="M16.403 12.652a3 3 0 000-5.304 3 3 0 00-3.75-3.751 3 3 0 00-5.305 0 3 3 0 00-3.751 3.75 3 3 0 000 5.305 3 3 0 003.75 3.751 3 3 0 005.305 0 3 3 0 003.751-3.75zm-2.546-4.46a.75.75 0 00-1.214-.883l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
                    </svg>
                  </div>
                  High
                </div>
              </div>
            </div>

            <div className="stat py-1">
              <div className="stat-title">
                Manipulation Risk
              </div>
              <div className="stat-val">
                <div className="flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5 mr-2">
                    <path fill-rule="evenodd" d="M10 2a.75.75 0 01.75.75v.258a33.186 33.186 0 016.668.83.75.75 0 01-.336 1.461 31.28 31.28 0 00-1.103-.232l1.702 7.545a.75.75 0 01-.387.832A4.981 4.981 0 0115 14c-.825 0-1.606-.2-2.294-.556a.75.75 0 01-.387-.832l1.77-7.849a31.743 31.743 0 00-3.339-.254v11.505a20.01 20.01 0 013.78.501.75.75 0 11-.339 1.462A18.558 18.558 0 0010 17.5c-1.442 0-2.845.165-4.191.477a.75.75 0 01-.338-1.462 20.01 20.01 0 013.779-.501V4.509c-1.129.026-2.243.112-3.34.254l1.771 7.85a.75.75 0 01-.387.83A4.98 4.98 0 015 14a4.98 4.98 0 01-2.294-.556.75.75 0 01-.387-.832L4.02 5.067c-.37.07-.738.148-1.103.232a.75.75 0 01-.336-1.462 32.845 32.845 0 016.668-.829V2.75A.75.75 0 0110 2zM5 7.543L3.92 12.33a3.499 3.499 0 002.16 0L5 7.543zm10 0l-1.08 4.787a3.498 3.498 0 002.16 0L15 7.543z" clip-rule="evenodd" />
                  </svg>
                  <h2>
                    0.7
                    <a href='#'>
                      {0.7 >= 0.4 ? <span className="ml-3 badge badge-warning">Medium</span> : ''}
                    </a>
                  </h2>
                </div>
              </div>
            </div>

            <div className="stat py-1">
              <div className="stat-title">
                Open-Source
              </div>
              <div className="stat-val text-center">
                <div className="flex items-center">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5 mr-2">
                    <path fill-rule="evenodd" d="M6.28 5.22a.75.75 0 010 1.06L2.56 10l3.72 3.72a.75.75 0 01-1.06 1.06L.97 10.53a.75.75 0 010-1.06l4.25-4.25a.75.75 0 011.06 0zm7.44 0a.75.75 0 011.06 0l4.25 4.25a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06-1.06L17.44 10l-3.72-3.72a.75.75 0 010-1.06zM11.377 2.011a.75.75 0 01.612.867l-2.5 14.5a.75.75 0 01-1.478-.255l2.5-14.5a.75.75 0 01.866-.612z" clip-rule="evenodd" />
                  </svg>
                  <h2>Yes</h2>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </>
  )
}
