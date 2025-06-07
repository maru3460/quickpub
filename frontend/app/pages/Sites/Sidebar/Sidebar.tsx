import type React from "react"

interface ISidebarProps {
  isOpen: boolean
}

const Sidebar: React.FC<ISidebarProps> = ({ isOpen }) => (
  <>
    <div
      className={`
        fixed inset-y-0 left-0 z-40 w-80 
        bg-background border-r 
        transform transition-transform duration-200 ease-in-out 
        ${isOpen ? "translate-x-0" : "-translate-x-full"} 
        pt-16
      `}
    >
      <div className="flex flex-col h-hull">
        <div className="flex-1 overflow-y-auto">はろわ</div>
      </div>
    </div>
  </>
)

export default Sidebar
