export function Bar() {
  return (
    <>
      <div className="navbar bg-base-300 shadow-lg rounded-xl ">
        <div className="flex-1">
          <div className="flex items-center space-x-4 ml-3">
            <div className="avatar online placeholder">
              <div className="rounded-full w-12">
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
          <div className="stats stats-vertical lg:stats-horizontal shadow-0 bg-transparent">

            <div className="stat">
              <div className="stat-title">Downloads</div>
              <div className="stat-desc">Jan 1st - Feb 1st</div>
            </div>

            <div className="stat">
              <div className="stat-title">New Users</div>
              <div className="stat-desc">↗︎ 400 (22%)</div>
            </div>

            <div className="stat">
              <div className="stat-title">New Registers</div>
              <div className="stat-desc">↘︎ 90 (14%)</div>
            </div>

          </div>
        </div>
      </div>
    </>
  )
}
