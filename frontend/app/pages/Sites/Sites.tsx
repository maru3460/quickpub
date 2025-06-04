import type React from "react"
import { useState } from "react"
import Header from "./Header"
import Sidebar from "./Sidebar"

const Home: React.FC = () => {
  const [sidebarOpen, setSidebarOpen] = useState<boolean>(false)

  return (
    <>
      <div className="min-h-screen bg-background">
        <Header toggleSidebarOpen={() => setSidebarOpen((prev) => !prev)} />
        <Sidebar isOpen={sidebarOpen} />
        <p>Hello, World</p>
        {/* オーバーレイ */}
        {sidebarOpen && (
          <div
            className="fixed inset-0 z-30 bg-black/50 pt-16"
            onClick={() => setSidebarOpen(false)}
          />
        )}
      </div>
    </>
  )
}

export default Home
