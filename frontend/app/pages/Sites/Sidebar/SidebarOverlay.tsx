import { useAtomValue, useSetAtom } from "jotai"
import type React from "react"
import { sidebarOpenAtom } from "~/stores/sidebarAtom"

const SidebarOverlay: React.FC = () => {
  const sidebarOpen = useAtomValue(sidebarOpenAtom)
  const setSidebarOpen = useSetAtom(sidebarOpenAtom)

  if (!sidebarOpen) return null

  return (
    <div
      className="fixed inset-0 z-30 bg-black/50 pt-16"
      onClick={() => setSidebarOpen(false)}
    />
  )
}

export default SidebarOverlay
