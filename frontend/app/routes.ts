import { type RouteConfig, index, route } from "@react-router/dev/routes"

export default [
  index("routes/sites.tsx"),
  route("react", "routes/welcome.tsx"),
] satisfies RouteConfig
