import LiveMapWidget from "../LiveMapWidget";
import { IconMap, IconRadar } from "@tabler/icons-react";

export default function LiveMap() {
  return (
    <div className="flex-1 flex flex-col min-w-0">
      <div className="p-6 md:p-8 flex-1 flex flex-col h-full">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-6 flex-none">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <span className="font-mono text-xs tracking-[0.15em] text-hazard uppercase">Tactical View</span>
              <span className="font-mono text-[10px] text-live bg-live/10 px-2 py-0.5 rounded-full border border-live/20 animate-pulse">Live</span>
            </div>
            <h1 className="font-display font-extrabold uppercase text-4xl leading-none tracking-wide text-text-0">Network Map</h1>
          </div>
          
          <div className="flex items-center gap-3">
            <button className="flex items-center gap-2 font-sans font-semibold text-xs text-text-0 bg-panel border border-hairline hover:bg-panel-2 hover:border-hairline-2 transition-all px-4 py-2.5 rounded-full">
              <IconRadar size={16} className="text-text-2" />
              <span>Traffic Overlay</span>
            </button>
          </div>
        </div>

        {/* Full Map Container */}
        <div className="bg-panel border border-hairline rounded-2xl flex-1 relative overflow-hidden flex flex-col min-h-[500px]">
          <LiveMapWidget />
          
          {/* Controls overlay */}
          <div className="absolute top-4 right-4 flex flex-col gap-2 z-10">
            <div className="bg-ink/90 backdrop-blur border border-hairline rounded-xl p-3 shadow-2xl w-[240px]">
              <h3 className="font-sans font-semibold text-text-0 text-xs mb-3">Live Status</h3>
              <div className="flex flex-col gap-2 font-mono text-[10px] text-text-1">
                <div className="flex justify-between items-center"><span className="flex items-center gap-2"><div className="w-1.5 h-1.5 rounded-full bg-live"></div>Active Riders</span><span className="text-text-0">214</span></div>
                <div className="flex justify-between items-center"><span className="flex items-center gap-2"><div className="w-1.5 h-1.5 rounded-full bg-hazard"></div>In Transit</span><span className="text-text-0">96</span></div>
                <div className="flex justify-between items-center"><span className="flex items-center gap-2"><div className="w-1.5 h-1.5 rounded-full bg-sky"></div>Pending</span><span className="text-text-0">12</span></div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
