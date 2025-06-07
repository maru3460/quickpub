import type React from "react"
import Header from "./Header/Header"
import Sidebar from "./Sidebar/Sidebar"

const Home: React.FC = () => {
  return (
    <>
      <div className="min-h-screen bg-background">
        <Header />
        <Sidebar />
        <p>Hello, World</p>
      </div>
    </>
  )
}

export default Home
