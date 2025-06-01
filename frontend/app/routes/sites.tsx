import type React from "react"
import Sites from "~/pages/Sites/Sites"

const meta = () => {
  return [
    { title: "New React Router on Rails App" },
    { name: "description", content: "Welcome to React Router on Rails!" },
  ]
}

const SitesRoute: React.FC = () => {
  return <Sites />
}

export { meta }
export default SitesRoute
