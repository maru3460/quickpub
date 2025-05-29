import { Welcome } from "../welcome/welcome"

export function meta() {
  return [
    { title: "New React Router on Rails App" },
    { name: "description", content: "Welcome to React Router on Rails!" },
  ]
}

export default function Home() {
  return <Welcome />
}
