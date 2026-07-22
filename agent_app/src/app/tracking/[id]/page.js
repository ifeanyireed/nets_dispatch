"use client";
import TrackingMapWidget from "./TrackingMapWidget";
import { useParams } from "next/navigation";
import Link from "next/link";
import Image from "next/image";

export default function OrderTrackingPage() {
  const params = useParams();
  const id = params?.id || "NLG-88231";

  return (
    <main className="min-h-screen w-full flex bg-[#0A0A0A] relative font-sans text-white">
      {/* Container */}
      <div className="w-full max-w-[500px] mx-auto bg-black flex flex-col min-h-screen relative shadow-2xl overflow-hidden">
        
        {/* Header */}
        <div className="flex-none px-6 py-6 border-b border-white/5 relative z-10 bg-black">
          <div className="flex items-center gap-4 mb-4">
            <Link href="/tracking" className="w-10 h-10 rounded-full bg-[#282525] flex items-center justify-center hover:bg-white/10 transition-colors">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M19 12H5"></path><polyline points="12 19 5 12 12 5"></polyline></svg>
            </Link>
            <div>
              <h1 className="font-semibold text-lg">{id}</h1>
              <p className="text-[11px] font-bold text-[#a5a1a1] tracking-[1px] uppercase mt-0.5">Live Tracking</p>
            </div>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto pb-20">
          
          {/* Map Area */}
          <div className="relative w-full h-[300px]">
            <TrackingMapWidget />
          </div>

          <div className="px-6 py-6 flex flex-col gap-6">
            
            {/* Shipment Info Profile Box */}
            <div className="bg-[#121212] rounded-[20px] p-5 border border-white/5">
              <h5 className="text-[11px] font-bold text-[#a5a1a1] tracking-[1px] uppercase mb-4">Shipment Details</h5>
              
              <div className="flex flex-col gap-3">
                <div className="flex justify-between items-center">
                  <span className="text-sm text-[#706B6B]">Vendor</span>
                  <span className="text-sm font-semibold">Chicken Republic</span>
                </div>
                <div className="w-full h-px bg-white/5" />
                <div className="flex justify-between items-center">
                  <span className="text-sm text-[#706B6B]">Status</span>
                  <span className="text-[11px] font-bold tracking-[1px] uppercase text-[#ff2a2a] bg-[#ff2a2a]/10 px-2.5 py-1 rounded-md">In transit</span>
                </div>
              </div>
            </div>

            {/* Timeline */}
            <div className="bg-[#121212] rounded-[20px] p-6 border border-white/5 relative">
              {/* Vertical line for timeline */}
              <div className="absolute left-[33px] top-[40px] bottom-[40px] w-px bg-white/5" />
              
              <div className="flex flex-col gap-8 relative z-10">
                {/* Step 1: Done */}
                <div className="flex items-center gap-4">
                  <div className="w-[18px] h-[18px] rounded-full bg-[#121212] border-2 border-[#ff2a2a] flex items-center justify-center shrink-0">
                    <div className="w-2 h-2 rounded-full bg-[#ff2a2a]" />
                  </div>
                  <span className="text-sm font-semibold text-white">Order placed</span>
                </div>

                {/* Step 2: Done */}
                <div className="flex items-center gap-4">
                  <div className="w-[18px] h-[18px] rounded-full bg-[#121212] border-2 border-[#ff2a2a] flex items-center justify-center shrink-0">
                    <div className="w-2 h-2 rounded-full bg-[#ff2a2a]" />
                  </div>
                  <span className="text-sm font-semibold text-white">Picked up</span>
                </div>

                {/* Step 3: Active */}
                <div className="flex items-center gap-4">
                  <div className="relative w-[18px] h-[18px] flex items-center justify-center shrink-0">
                    <div className="absolute w-full h-full rounded-full bg-hazard/30 animate-ping" />
                    <div className="w-[18px] h-[18px] rounded-full bg-[#ff2a2a] flex items-center justify-center shadow-[0_0_10px_rgba(255,42,42,0.4)]">
                      <div className="w-2 h-2 rounded-full bg-white" />
                    </div>
                  </div>
                  <div className="flex flex-col">
                    <span className="text-sm font-bold text-hazard">In transit</span>
                    <span className="text-[11px] text-[#a5a1a1] mt-0.5">ETA: 14 mins</span>
                  </div>
                </div>

                {/* Step 4: Pending */}
                <div className="flex items-center gap-4">
                  <div className="w-[18px] h-[18px] rounded-full bg-[#121212] border-2 border-white/10 flex items-center justify-center shrink-0" />
                  <span className="text-sm font-medium text-[#706B6B]">Delivered</span>
                </div>
              </div>
            </div>

            <Link href={`/tracking/${id}/confirmed`} className="w-full h-14 bg-white/5 border border-white/10 rounded-full flex items-center justify-center transition-colors hover:bg-white/10">
              <span className="text-white font-bold text-[13px] tracking-[1px] uppercase">
                Simulate Delivery
              </span>
            </Link>
          </div>
        </div>
      </div>
    </main>
  );
}
