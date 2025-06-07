import { Plus } from "lucide-react"
import type React from "react"
import { Button } from "~/components/ui/button"
import SidebarButton from "../Sidebar/SidebarButton"

interface IHeaderProps {
  toggleSidebarOpen: () => void
}

const Header: React.FC<IHeaderProps> = ({ toggleSidebarOpen }) => (
  <header className="fixed top-0 left-0 right-0 z-50 bg-background border-b">
    <div className="flex items-center justify-between px-4 py-3">
      <div className="flex items-center gap-3">
        <SidebarButton toggleSidebarOpen={toggleSidebarOpen} />
        <h1 className="text-xl font-semibold cursor-pointer hover:text-primary transition-colors">
          QuickPub
        </h1>
      </div>

      <Button className="flex items-center gap-3">
        <Plus className="h-4 w-4" />
        新規作成
      </Button>
    </div>
  </header>
)

export default Header
