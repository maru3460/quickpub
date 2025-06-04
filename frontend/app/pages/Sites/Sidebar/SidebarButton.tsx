import { Menu } from "lucide-react"
import type React from "react"
import { Button } from "~/components/ui/button"

interface ISidebarButtonProps {
  toggleSidebarOpen: () => void
}

const SidebarButton: React.FC<ISidebarButtonProps> = ({
  toggleSidebarOpen,
}) => (
  <Button variant="ghost" size="sm" onClick={() => toggleSidebarOpen()}>
    <Menu className="h-5 w-5" />
  </Button>
)

export default SidebarButton
