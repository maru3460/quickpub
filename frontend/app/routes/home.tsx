import type React from "react"
import { Welcome } from "../welcome/welcome"

const meta = () => {
  return [
    { title: "New React Router on Rails App" },
    { name: "description", content: "Welcome to React Router on Rails!" },
  ]
}

const Home: React.FC = () => {
  return <Welcome />
}

export { meta }
export default Home
