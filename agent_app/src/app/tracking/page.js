import Image from "next/image";
import Link from "next/link";

export default function TrackingLandingPage() {
  return (
    <main className="min-h-screen w-full flex bg-black relative overflow-hidden font-sans">
      {/* Background motorbiker illustration/gradient overlay */}
      <div className="absolute inset-0 z-0">
        <Image 
          src="/images/biker14.jpeg" 
          alt="Biker background" 
          fill 
          className="object-cover object-center"
          priority
        />
      </div>
      
      {/* Dark Overlay matching mobile apps */}
      <div className="absolute inset-0 z-0 pointer-events-none bg-gradient-to-b from-black/40 via-black/85 to-black" style={{ background: "linear-gradient(to bottom, rgba(0,0,0,0.4) 0%, rgba(0,0,0,0.85) 50%, rgba(0,0,0,1) 90%)" }} />

      {/* Stylized background motorbike light trails/shape glow */}
      <div className="absolute -top-[100px] -right-[100px] w-[300px] h-[300px] rounded-full pointer-events-none z-0" style={{ boxShadow: "0 0 100px 0 rgba(229, 57, 53, 0.08)" }} />

      {/* Content wrapper */}
      <div className="relative z-10 w-full flex flex-col px-6 py-5 max-w-lg mx-auto">
        <div className="mt-[30px] flex-none">
          {/* Title Area */}
          <div className="flex items-end gap-0">
            <span className="text-[48px] font-semibold text-white tracking-[-1.0px] leading-none">Track</span>
            <span className="text-[48px] font-semibold text-hazard tracking-[-1.0px] leading-none">Package</span>
          </div>
          
          <p className="mt-2 text-[12px] font-extrabold text-[#a5a1a1] tracking-[1.5px]">REAL-TIME DELIVERY STATUS</p>
        </div>

        <div className="flex-[0.5]" />

        <form className="flex flex-col mt-10">
          {/* Tracking ID Input */}
          <label className="text-[12px] font-bold text-[#a5a1a1] mb-2 block">
            Tracking ID
          </label>
          <div className="bg-[#282525] rounded-full border border-white/5 flex items-center mb-5 px-4 py-3.5">
            <svg className="w-5 h-5 text-[#a5a1a1] mr-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg>
            <input 
              type="text" 
              className="bg-transparent border-none text-white placeholder-[#706B6B] text-[14px] w-full focus:outline-none focus:ring-0 uppercase" 
              placeholder="e.g. NLG-88231" 
              defaultValue="NLG-88231"
            />
          </div>
          
          {/* Phone Number Input */}
          <label className="text-[12px] font-bold text-[#a5a1a1] mb-2 block">
            Phone number
          </label>
          <div className="bg-[#282525] rounded-full border border-white/5 flex items-center mb-3 px-4 py-3.5 relative">
            <svg className="w-5 h-5 text-[#a5a1a1] mr-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"></rect><line x1="12" y1="18" x2="12.01" y2="18"></line></svg>
            <input 
              type="text" 
              className="bg-transparent border-none text-white placeholder-[#706B6B] text-[14px] w-full focus:outline-none focus:ring-0" 
              placeholder="Receiver's phone number" 
            />
          </div>

          <div className="flex-1" />

          {/* Track Button */}
          <Link href="/tracking/NLG-88231" className="w-full h-14 bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] rounded-full shadow-[0_8px_16px_rgba(255,42,42,0.3)] flex items-center justify-center transition-opacity hover:opacity-90 mt-8 mb-6">
            <span className="text-white font-extrabold text-[15px] tracking-[1.5px] uppercase">
              Track Package
            </span>
          </Link>
        </form>
      </div>
    </main>
  );
}
