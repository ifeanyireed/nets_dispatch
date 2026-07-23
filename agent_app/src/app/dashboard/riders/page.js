import { IconSearch, IconFilter, IconPlus, IconUserPlus } from "@tabler/icons-react";
import RidersTable from "./RidersTable";
export default async function Riders() {
  let riders = [];
  try {
    const res = await fetch("https://nets-logistics-api.onrender.com/riders", { cache: "no-store" });
    if (res.ok) {
      riders = await res.json();
    }
  } catch (error) {
    console.error("Failed to fetch riders:", error);
  }

  const getStatusColor = (status) => {
    switch(status?.toLowerCase()) {
      case 'active': return "text-live bg-live/10 border border-live/20";
      case 'busy': return "text-hazard bg-hazard/10 border border-hazard/20";
      case 'suspended': return "text-alert bg-alert/10 border border-alert/20";
      default: return "text-text-1 bg-text-2/10 border border-hairline-2"; // offline
    }
  };

  return (
    <div className="flex-1 flex flex-col min-w-0">
      <div className="p-6 md:p-8 flex-1 flex flex-col">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <span className="font-mono text-xs tracking-[0.15em] text-hazard uppercase">Rider Management</span>
            </div>
            <h1 className="font-display font-extrabold uppercase text-4xl leading-none tracking-wide text-text-0">Riders Directory</h1>
          </div>
          
          <div className="flex items-center gap-3">
            <button className="flex items-center gap-2 font-sans font-semibold text-xs text-text-0 bg-panel border border-hairline hover:bg-panel-2 hover:border-hairline-2 transition-all px-4 py-2.5 rounded-full">
              <IconFilter size={16} className="text-text-2" />
              <span>Filter</span>
            </button>
            <button className="text-xs text-white bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] shadow-[0_4px_15px_rgba(255,42,42,0.2)] border-none flex items-center gap-2 font-sans font-semibold hover:brightness-110 transition-all px-4 py-2.5 rounded-full">
              <IconUserPlus size={16} />
              <span>Onboard Rider</span>
            </button>
          </div>
        </div>

        {/* Search Bar */}
        <div className="flex items-center gap-3 bg-panel border border-hairline rounded-full px-4 py-3 mb-6 focus-within:border-hazard transition-colors">
          <IconSearch size={18} className="text-text-2" />
          <input 
            type="text" 
            placeholder="Search by Rider name, phone, or vehicle ID..." 
            className="bg-transparent border-none outline-none text-text-0 text-sm font-sans w-full"
          />
        </div>

        <RidersTable initialRiders={riders} />

      </div>
    </div>
  );
}
