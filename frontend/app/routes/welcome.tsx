import type React from "react"
import { Welcome } from "../pages/Welcome/Welcome"

const meta = () => {
  return [
    { title: "New React Router on Rails App" },
    { name: "description", content: "Welcome to React Router on Rails!" },
  ]
}

const WelcomeRoute: React.FC = () => {
  return <Welcome />
}

export { meta }
export default WelcomeRoute
