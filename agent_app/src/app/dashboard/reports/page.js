import { IconChartHistogram, IconDownload } from "@tabler/icons-react";

export default function Reports() {
  return (
    <div className="flex-1 flex flex-col min-w-0">
      <div className="p-6 md:p-8 flex-1 flex flex-col">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <span className="font-mono text-xs tracking-[0.15em] text-hazard uppercase">Analytics & Reports</span>
            </div>
            <h1 className="font-display font-extrabold uppercase text-4xl leading-none tracking-wide text-text-0">System Reports</h1>
          </div>
          
          <div className="flex items-center gap-3">
            <button className="flex items-center gap-2 font-sans font-semibold text-xs text-text-0 bg-panel border border-hairline hover:bg-panel-2 hover:border-hairline-2 transition-all px-4 py-2.5 rounded-full">
              <IconDownload size={16} className="text-text-2" />
              <span>Export PDF</span>
            </button>
          </div>
        </div>

        {/* Charts Row */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
          {/* Chart Placeholder 1 */}
          <div className="bg-panel border border-hairline rounded-2xl p-6 min-h-[300px] flex flex-col">
            <h3 className="font-sans text-sm font-semibold text-text-0 mb-6">Delivery Volume (7 Days)</h3>
            <div className="flex-1 relative flex flex-col justify-end min-h-[200px] mt-4">
              <svg viewBox="0 0 600 200" preserveAspectRatio="none" className="absolute inset-0 w-full h-full overflow-visible">
                <defs>
                  <linearGradient id="gradientLine" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="var(--color-hazard)" stopOpacity="0.5" />
                    <stop offset="100%" stopColor="var(--color-hazard)" stopOpacity="0" />
                  </linearGradient>
                  <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
                    <feGaussianBlur stdDeviation="4" result="blur" />
                    <feComposite in="SourceGraphic" in2="blur" operator="over" />
                  </filter>
                </defs>
                
                {/* Area Fill */}
                <path 
                  d="M 0,200 L 0,120 C 50,120 50,70 100,70 C 150,70 150,140 200,140 C 250,140 250,30 300,30 C 350,30 350,10 400,10 C 450,10 450,90 500,90 C 550,90 550,20 600,20 L 600,200 Z" 
                  fill="url(#gradientLine)" 
                />
                
                {/* Line */}
                <path 
                  d="M 0,120 C 50,120 50,70 100,70 C 150,70 150,140 200,140 C 250,140 250,30 300,30 C 350,30 350,10 400,10 C 450,10 450,90 500,90 C 550,90 550,20 600,20" 
                  fill="none" 
                  stroke="var(--color-hazard)" 
                  strokeWidth="2" 
                  vectorEffect="non-scaling-stroke"
                  filter="url(#glow)"
                  className="path-draw"
                />
              </svg>

              {/* Data Points HTML Overlay */}
              <div className="absolute inset-0 w-full h-full pointer-events-none">
                {[
                  { x: 0, y: 120, val: 240 },
                  { x: 100, y: 70, val: 450 },
                  { x: 200, y: 140, val: 180 },
                  { x: 300, y: 30, val: 620 },
                  { x: 400, y: 10, val: 780 },
                  { x: 500, y: 90, val: 320 },
                  { x: 600, y: 20, val: 680 }
                ].map((pt, i) => (
                  <div 
                    key={i} 
                    className="absolute group cursor-pointer pointer-events-auto"
                    style={{ left: `${(pt.x / 600) * 100}%`, top: `${(pt.y / 200) * 100}%`, transform: 'translate(-50%, -50%)' }}
                  >
                    <div className="w-2.5 h-2.5 rounded-full bg-ink border-[2px] border-hazard transition-all duration-300 group-hover:scale-150" />
                    <div className="absolute left-1/2 -top-8 -translate-x-1/2 w-10 h-5 bg-panel-3 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center pointer-events-none">
                      <span className="font-mono text-[10px] text-text-0">{pt.val}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
            <div className="flex justify-between mt-4 font-mono text-[10px] text-text-2">
              <span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span>
            </div>
          </div>

          {/* Chart Placeholder 2 */}
          <div className="bg-panel border border-hairline rounded-2xl p-6 min-h-[300px] flex flex-col relative overflow-hidden group">
            <IconChartHistogram size={120} className="absolute -right-8 -top-8 opacity-5 text-hazard" />
            <h3 className="font-sans text-sm font-semibold text-text-0 mb-6">Network Health</h3>
            <div className="flex-1 flex flex-col gap-4 justify-center">
              <div>
                <div className="flex justify-between font-mono text-[10px] text-text-1 mb-1"><span>On-time Delivery Rate</span><span>98.2%</span></div>
                <div className="h-1.5 bg-ink rounded-full overflow-hidden"><div className="h-full bg-live w-[98.2%]"></div></div>
              </div>
              <div>
                <div className="flex justify-between font-mono text-[10px] text-text-1 mb-1"><span>Rider Availability</span><span>84.5%</span></div>
                <div className="h-1.5 bg-ink rounded-full overflow-hidden"><div className="h-full bg-sky w-[84.5%]"></div></div>
              </div>
              <div>
                <div className="flex justify-between font-mono text-[10px] text-text-1 mb-1"><span>Order Cancellation</span><span>3.1%</span></div>
                <div className="h-1.5 bg-ink rounded-full overflow-hidden"><div className="h-full bg-hazard w-[3.1%]"></div></div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
