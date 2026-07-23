import { IconSearch, IconFilter, IconPlus, IconUserPlus } from "@tabler/icons-react";

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

        {/* Filter Chips */}
        <div className="flex gap-2 mb-6 overflow-x-auto pb-2">
          {["All Riders", "Active", "Offline", "Suspended", "New Applicants"].map((chip, i) => (
            <button key={i} className={`whitespace-nowrap px-4 py-1.5 rounded-full font-sans text-xs font-semibold border transition-all ${i === 0 ? 'bg-panel-2 border-hairline-2 text-text-0' : 'bg-transparent border-hairline text-text-2 hover:border-hairline-2 hover:text-text-1'}`}>
              {chip}
            </button>
          ))}
        </div>

        {/* Data Table */}
        <div className="bg-panel border border-hairline rounded-2xl overflow-hidden flex-1">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-panel-2 border-b border-hairline">
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Rider</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Vehicle</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Status</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Rating</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal text-right">Deliveries</th>
                </tr>
              </thead>
              <tbody className="font-sans text-sm divide-y divide-hairline">
                {riders.length === 0 && (
                  <tr>
                    <td colSpan="5" className="px-6 py-8 text-center text-text-2 font-mono text-sm">
                      No riders found.
                    </td>
                  </tr>
                )}
                {riders.map((rider, idx) => (
                  <tr key={idx} className="hover:bg-panel-2/50 transition-colors cursor-pointer group">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 rounded-full bg-panel-2 border border-hairline flex items-center justify-center font-bold text-text-0 font-sans text-xs">
                          {rider.name ? rider.name.charAt(0).toUpperCase() : '?'}
                        </div>
                        <span className="font-semibold text-text-0 group-hover:text-hazard transition-colors">{rider.name || 'Unknown'}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-text-1">{rider.vehicle || 'N/A'}</td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${getStatusColor(rider.status)}`}>
                        {rider.status || 'Offline'}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-text-0 font-mono font-semibold">{rider.rating ?? '0.0'} <span className="text-hazard">★</span></td>
                    <td className="px-6 py-4 text-right font-mono font-semibold text-text-0">{rider.deliveries ?? 0}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          
          <div className="p-4 border-t border-hairline flex items-center justify-between text-xs font-mono text-text-2">
            <span>Showing {riders.length} riders</span>
            <div className="flex gap-2">
              <button className="px-3 py-1 rounded-full border border-hairline hover:text-text-0 transition-colors">Prev</button>
              <button className="px-3 py-1 rounded-full border border-hairline hover:text-text-0 transition-colors">Next</button>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
