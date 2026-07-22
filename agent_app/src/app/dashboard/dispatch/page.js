import LiveMapWidget from "../LiveMapWidget";
import { IconTruckDelivery, IconSearch, IconUserBolt } from "@tabler/icons-react";

export default function Dispatch() {
  const pendingOrders = [
    { id: "NLG-88229", vendor: "MedPlus Pharmacy", time: "4 mins ago", amount: "₦3,100" },
    { id: "NLG-88235", vendor: "Chicken Republic", time: "12 mins ago", amount: "₦2,400" },
    { id: "NLG-88240", vendor: "ShopRite Lekki", time: "15 mins ago", amount: "₦4,200" },
  ];

  return (
    <div className="flex-1 flex flex-col min-w-0">
      <div className="p-6 md:p-8 flex-1 flex flex-col h-full">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-6 flex-none">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <span className="font-mono text-xs tracking-[0.15em] text-hazard uppercase">Logistics Core</span>
            </div>
            <h1 className="font-display font-extrabold uppercase text-4xl leading-none tracking-wide text-text-0">Dispatch Console</h1>
          </div>
        </div>

        <div className="flex flex-col lg:flex-row gap-6 flex-1 min-h-0">
          {/* Pending Orders List */}
          <div className="w-full lg:w-[360px] flex flex-col gap-4">
            <div className="flex items-center justify-between">
              <h2 className="font-sans font-semibold text-sm text-text-0">Pending Assignment</h2>
              <span className="font-mono text-[10px] text-hazard bg-hazard/10 px-2 py-0.5 rounded-full border border-hazard/20">{pendingOrders.length} queue</span>
            </div>
            
            <div className="flex flex-col gap-3 overflow-y-auto pr-2">
              {pendingOrders.map((order, i) => (
                <div key={i} className="bg-panel border border-hairline hover:border-hazard rounded-xl p-4 transition-all cursor-pointer group">
                  <div className="flex justify-between items-start mb-3">
                    <div>
                      <span className="font-mono text-xs font-semibold text-text-0 group-hover:text-hazard transition-colors">{order.id}</span>
                      <div className="font-sans text-xs text-text-1 mt-1">{order.vendor}</div>
                    </div>
                    <span className="font-mono text-[10px] text-text-2">{order.time}</span>
                  </div>
                  <div className="flex items-center justify-between pt-3 border-t border-hairline">
                    <span className="font-mono font-semibold text-xs text-text-0">{order.amount}</span>
                    <button className="text-[10px] text-white bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] shadow-[0_4px_15px_rgba(255,42,42,0.2)] border-none font-sans font-semibold uppercase tracking-wider hover:brightness-110 transition-colors px-3 py-1.5 rounded-full flex items-center gap-1.5">
                      <IconUserBolt size={12} />
                      Assign Rider
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Map */}
          <div className="bg-panel border border-hairline rounded-2xl flex-1 relative overflow-hidden flex flex-col min-h-[400px]">
            <LiveMapWidget />
            <div className="absolute top-4 left-4 bg-ink/90 backdrop-blur border border-hairline rounded-full px-4 py-2 flex items-center gap-3">
              <span className="relative flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-live opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2 w-2 bg-live"></span>
              </span>
              <span className="font-sans text-xs text-text-0 font-medium">3 riders nearby</span>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
