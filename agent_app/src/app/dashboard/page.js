import Image from "next/image";
import { IconPackage, IconTruckDelivery, IconMotorbike, IconReceipt2 } from "@tabler/icons-react";
import LiveMapWidget from "./LiveMapWidget";

export default function Dashboard() {
  return (
    <div className="flex-1 overflow-y-auto pb-10">
      {/* Header */}
      <div className="relative border-b border-hairline overflow-hidden p-5 md:p-6">
        {/* Abstract Background */}
        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjQiIGhlaWdodD0iNjQiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMSIgY3k9IjEiIHI9IjEiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4wMjUpIi8+PC9zdmc+')] [mask-image:linear-gradient(to_bottom,white,transparent)] opacity-50 z-0 pointer-events-none" />
        <div className="absolute -top-[30%] -right-[10%] w-[500px] h-[500px] bg-hazard/10 rounded-full blur-[100px] pointer-events-none" />

        <div className="relative z-10 flex flex-col md:flex-row justify-between items-start md:items-end gap-6">
          <div className="max-w-2xl">
            <div className="font-sans tracking-wide text-sm tracking-[0.16em] text-hazard uppercase flex items-center gap-2 mb-3">
              <span className="text-sm">◎</span> Network Overview
            </div>
            <h1 className="font-sans font-extrabold uppercase text-3xl md:text-4xl leading-none mb-3">
              System <em className="not-italic text-hazard">Live</em>
            </h1>
            <p className="font-sans text-sm text-text-1 leading-relaxed m-0">
              Real-time overview of every logistics activity on the network.
            </p>
          </div>
          
          <div className="flex items-center gap-6 p-4 bg-ink-2/50 backdrop-blur border border-hairline rounded-2xl">
            <div className="text-right">
              <b className="block font-sans tracking-wide text-lg text-text-0">1,248</b>
              <span className="font-sans text-sm tracking-wider text-text-2 uppercase">Total Today</span>
            </div>
            <div className="w-px h-8 bg-hairline"></div>
            <div className="text-right">
              <b className="block font-sans tracking-wide text-lg text-live">98.2%</b>
              <span className="font-sans text-sm tracking-wider text-text-2 uppercase">On-Time</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="p-5 md:p-6 flex flex-col gap-5">
        
        {/* Stats Row */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          {[
            { value: "482", label: "Orders today", color: "text-text-0", icon: IconPackage },
            { value: "96", label: "Active deliveries", color: "text-hazard", icon: IconTruckDelivery },
            { value: "214", label: "Active riders", color: "text-sky", icon: IconMotorbike },
            { value: "₦8.2M", label: "Today's revenue", color: "text-live", icon: IconReceipt2 },
          ].map((stat, i) => (
            <div key={i} className="bg-panel border border-hairline rounded-2xl p-4 transition-all hover:border-hairline-2 hover:bg-panel-2 hover:-translate-y-1 min-h-[130px] flex flex-col justify-end relative overflow-hidden group">
              <stat.icon size={80} className={`absolute -right-4 -top-4 opacity-5 group-hover:opacity-10 group-hover:scale-110 transition-all ${stat.color}`} />
              <stat.icon size={20} className={`mb-auto opacity-70 ${stat.color}`} />
              <div className={`font-sans tracking-wide font-bold text-2xl mb-1 mt-4 ${stat.color}`}>{stat.value}</div>
              <div className="font-sans text-sm text-text-2 uppercase tracking-widest">{stat.label}</div>
            </div>
          ))}
        </div>

        {/* Two Columns: Chart & Map */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          
          {/* Chart Widget */}
          <div className="lg:col-span-2 bg-panel border border-hairline rounded-2xl p-4 flex flex-col">
            <div className="flex items-center justify-between mb-6">
              <h3 className="font-sans font-bold text-lg">Orders Volume</h3>
              <select className="bg-ink border border-hairline-2 rounded-full px-4 py-1.5 text-sm text-text-1 outline-none font-sans appearance-none cursor-pointer">
                <option>Last 7 days</option>
                <option>Last 30 days</option>
              </select>
            </div>
            
            <div className="flex-1 min-h-[160px] w-full flex flex-col justify-end mt-auto relative">
              <svg viewBox="0 0 1000 200" preserveAspectRatio="none" className="absolute inset-0 w-full h-full overflow-visible">
                <defs>
                  <linearGradient id="gradientLineDash" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="var(--color-hazard)" stopOpacity="0.5" />
                    <stop offset="100%" stopColor="var(--color-hazard)" stopOpacity="0" />
                  </linearGradient>
                  <filter id="glowDash" x="-20%" y="-20%" width="140%" height="140%">
                    <feGaussianBlur stdDeviation="4" result="blur" />
                    <feComposite in="SourceGraphic" in2="blur" operator="over" />
                  </filter>
                </defs>
                
                {/* Area Fill */}
                <path 
                  d="M 50,200 L 50,136 L 150,96 L 250,112 L 350,72 L 450,40 L 550,104 L 650,56 L 750,80 L 850,128 L 950,64 L 950,200 Z" 
                  fill="url(#gradientLineDash)" 
                />
                
                {/* Line */}
                <path 
                  d="M 50,136 L 150,96 L 250,112 L 350,72 L 450,40 L 550,104 L 650,56 L 750,80 L 850,128 L 950,64" 
                  fill="none" 
                  stroke="var(--color-hazard)" 
                  strokeWidth="2" 
                  strokeLinecap="round" 
                  strokeLinejoin="round" 
                  vectorEffect="non-scaling-stroke"
                  filter="url(#glowDash)"
                  className="path-draw"
                />
              </svg>

              {/* Data Points HTML Overlay */}
              <div className="absolute inset-0 w-full h-full pointer-events-none">
                {[
                  { x: 50, y: 136, val: 240 },
                  { x: 150, y: 96, val: 450 },
                  { x: 250, y: 112, val: 380 },
                  { x: 350, y: 72, val: 590 },
                  { x: 450, y: 40, val: 750 },
                  { x: 550, y: 104, val: 410 },
                  { x: 650, y: 56, val: 680 },
                  { x: 750, y: 80, val: 560 },
                  { x: 850, y: 128, val: 290 },
                  { x: 950, y: 64, val: 620 }
                ].map((pt, i) => (
                  <div 
                    key={i} 
                    className="absolute group cursor-pointer pointer-events-auto"
                    style={{ left: `${(pt.x / 1000) * 100}%`, top: `${(pt.y / 200) * 100}%`, transform: 'translate(-50%, -50%)' }}
                  >
                    <div className="w-2.5 h-2.5 rounded-full bg-ink border-[2px] border-hazard transition-all duration-300 group-hover:scale-150" />
                    <div className="absolute left-1/2 -top-8 -translate-x-1/2 w-10 h-5 bg-panel-3 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center pointer-events-none">
                      <span className="font-mono text-[10px] text-text-0">{pt.val}</span>
                    </div>
                  </div>
                ))}
              </div>

              <div className="flex justify-between w-full px-2 mt-2 h-6 items-end">
                {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((num) => (
                  <span key={num} className="font-sans tracking-wide text-[10px] text-text-2 leading-none">{num}</span>
                ))}
              </div>
            </div>
          </div>

          {/* Live Map Widget */}
          <div className="bg-panel border border-hairline rounded-2xl pt-4 flex flex-col overflow-hidden">
            <div className="flex items-center justify-between mb-4 px-4">
              <h3 className="font-sans font-bold text-lg">Live Map</h3>
              <div className="w-2 h-2 rounded-full bg-live shadow-[0_0_8px_var(--color-live)] animate-pulse" />
            </div>
            
            <div className="relative flex-1 min-h-[220px] w-full border-t border-hairline-2">
              <LiveMapWidget />
            </div>
          </div>
          
        </div>
      </div>
    </div>
  );
}
