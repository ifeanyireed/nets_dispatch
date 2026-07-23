"use client";

import { useState } from "react";
import { IconX, IconCheck, IconSearch, IconFilter, IconUserPlus } from "@tabler/icons-react";

export default function RidersTable({ initialRiders }) {
  const [riders, setRiders] = useState(initialRiders);
  const [selectedRider, setSelectedRider] = useState(null);
  const [isApproving, setIsApproving] = useState(false);
  const [filter, setFilter] = useState("All Riders");

  const getStatusColor = (status) => {
    switch(status?.toLowerCase()) {
      case 'active': return "text-live bg-live/10 border border-live/20";
      case 'busy': return "text-hazard bg-hazard/10 border border-hazard/20";
      case 'suspended': return "text-alert bg-alert/10 border border-alert/20";
      case 'pending': return "text-[#f59e0b] bg-[#f59e0b]/10 border border-[#f59e0b]/20";
      default: return "text-text-1 bg-text-2/10 border border-hairline-2"; // offline or new
    }
  };

  const handleApprove = async () => {
    if (!selectedRider) return;
    setIsApproving(true);
    try {
      const res = await fetch(`https://nets-logistics-api.onrender.com/riders/${selectedRider.id}/status`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: "Active" }),
      });
      if (res.ok) {
        const updated = await res.json();
        setRiders(riders.map(r => r.id === updated.id ? updated : r));
        setSelectedRider(null);
      }
    } catch (error) {
      console.error("Failed to approve rider:", error);
    } finally {
      setIsApproving(false);
    }
  };

  const filteredRiders = riders.filter(r => {
    if (filter === "All Riders") return true;
    if (filter === "New Applicants") return r.status === "Pending" || r.status === "New";
    return r.status === filter;
  });

  return (
    <>
      <div className="flex gap-2 mb-6 overflow-x-auto pb-2">
        {["All Riders", "Active", "Offline", "Suspended", "New Applicants"].map((chip, i) => (
          <button 
            key={i} 
            onClick={() => setFilter(chip)}
            className={`whitespace-nowrap px-4 py-1.5 rounded-full font-sans text-xs font-semibold border transition-all ${filter === chip ? 'bg-panel-2 border-hairline-2 text-text-0' : 'bg-transparent border-hairline text-text-2 hover:border-hairline-2 hover:text-text-1'}`}
          >
            {chip}
          </button>
        ))}
      </div>

      <div className="bg-panel border border-hairline rounded-2xl overflow-hidden flex-1 relative">
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
              {filteredRiders.length === 0 && (
                <tr>
                  <td colSpan="5" className="px-6 py-8 text-center text-text-2 font-mono text-sm">
                    No riders found.
                  </td>
                </tr>
              )}
              {filteredRiders.map((rider, idx) => (
                <tr key={idx} onClick={() => setSelectedRider(rider)} className="hover:bg-panel-2/50 transition-colors cursor-pointer group">
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
          <span>Showing {filteredRiders.length} riders</span>
          <div className="flex gap-2">
            <button className="px-3 py-1 rounded-full border border-hairline hover:text-text-0 transition-colors">Prev</button>
            <button className="px-3 py-1 rounded-full border border-hairline hover:text-text-0 transition-colors">Next</button>
          </div>
        </div>
      </div>

      {/* Modal */}
      {selectedRider && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
          <div className="bg-ink border border-hairline rounded-3xl w-full max-w-md shadow-2xl overflow-hidden flex flex-col">
            <div className="flex items-center justify-between p-6 border-b border-hairline bg-panel-2/50">
              <div>
                <h3 className="font-sans font-bold text-lg text-text-0">Rider Profile</h3>
                <p className="text-xs text-text-2 font-mono mt-1">ID: {selectedRider.id}</p>
              </div>
              <button onClick={() => setSelectedRider(null)} className="p-2 rounded-full hover:bg-panel transition-colors text-text-2 hover:text-white">
                <IconX size={20} />
              </button>
            </div>
            
            <div className="p-6 flex flex-col gap-6">
              <div className="flex items-center gap-4">
                <div className="w-16 h-16 rounded-full bg-panel border border-hairline flex items-center justify-center font-bold text-text-0 font-sans text-2xl shadow-inner">
                  {selectedRider.name ? selectedRider.name.charAt(0).toUpperCase() : '?'}
                </div>
                <div>
                  <h4 className="font-extrabold text-xl text-white tracking-wide">{selectedRider.name || 'Unknown'}</h4>
                  <div className={`mt-2 inline-flex items-center px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${getStatusColor(selectedRider.status)}`}>
                    {selectedRider.status || 'Offline'}
                  </div>
                </div>
              </div>

              <div className="bg-panel rounded-2xl border border-hairline p-4 grid grid-cols-2 gap-4">
                <div>
                  <span className="text-[10px] text-text-2 uppercase font-bold tracking-widest block mb-1">Vehicle</span>
                  <span className="text-sm text-text-0 font-medium">{selectedRider.vehicle || 'Not provided'}</span>
                </div>
                <div>
                  <span className="text-[10px] text-text-2 uppercase font-bold tracking-widest block mb-1">Total Deliveries</span>
                  <span className="text-sm text-text-0 font-medium">{selectedRider.deliveries || 0}</span>
                </div>
                <div>
                  <span className="text-[10px] text-text-2 uppercase font-bold tracking-widest block mb-1">User ID</span>
                  <span className="text-xs text-text-1 font-mono truncate block" title={selectedRider.userId}>{selectedRider.userId}</span>
                </div>
                <div>
                  <span className="text-[10px] text-text-2 uppercase font-bold tracking-widest block mb-1">Rating</span>
                  <span className="text-sm text-text-0 font-medium flex items-center gap-1">
                    {selectedRider.rating || '0.0'} <span className="text-hazard text-xs">★</span>
                  </span>
                </div>
              </div>

              {/* Only show Approval Section if Pending/New */}
              {(selectedRider.status === 'Pending' || selectedRider.status === 'New') && (
                <div className="bg-hazard/5 border border-hazard/20 rounded-2xl p-5 flex flex-col gap-4">
                  <div className="flex items-start gap-3">
                    <div className="p-1.5 bg-hazard/20 rounded-full text-hazard mt-0.5">
                      <IconCheck size={16} />
                    </div>
                    <div>
                      <h5 className="font-bold text-white text-sm">Action Required</h5>
                      <p className="text-xs text-text-2 mt-1 leading-relaxed">This rider has submitted their verification documents. Please review and approve them to activate their account.</p>
                    </div>
                  </div>
                  
                  <button 
                    onClick={handleApprove}
                    disabled={isApproving}
                    className="w-full py-3 rounded-xl bg-hazard hover:bg-hazard/90 disabled:opacity-50 transition-colors text-white font-bold text-sm shadow-[0_4px_12px_rgba(239,68,68,0.3)] flex items-center justify-center gap-2"
                  >
                    {isApproving ? "Approving..." : "Approve & Activate Rider"}
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
}
