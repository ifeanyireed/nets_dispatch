"use client";
import { useParams } from "next/navigation";
import Link from "next/link";
import Image from "next/image";

export default function DeliveryConfirmationPage() {
  const params = useParams();
  const id = params?.id || "NLG-88231";

  return (
    <main className="min-h-screen w-full flex bg-[#0A0A0A] relative font-sans text-white">
      {/* Container */}
      <div className="w-full max-w-[500px] mx-auto bg-black flex flex-col min-h-screen relative shadow-2xl overflow-hidden">
        
        {/* Header */}
        <div className="flex-none px-6 py-6 border-b border-white/5 relative z-10 bg-black">
          <div className="flex items-center gap-4 mb-4">
            <Link href={`/tracking/${id}`} className="w-10 h-10 rounded-full bg-[#282525] flex items-center justify-center hover:bg-white/10 transition-colors">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M19 12H5"></path><polyline points="12 19 5 12 12 5"></polyline></svg>
            </Link>
            <div>
              <h1 className="font-semibold text-lg">{id}</h1>
              <p className="text-[11px] font-bold text-[#a5a1a1] tracking-[1px] uppercase mt-0.5">Delivery Confirmation</p>
            </div>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto px-6 py-8 flex flex-col gap-6">
          
          {/* Success Banner */}
          <div className="bg-[#2fd484]/10 border border-[#2fd484]/20 rounded-[20px] p-6 flex flex-col items-center text-center">
            <div className="w-16 h-16 rounded-full bg-[#2fd484]/20 flex items-center justify-center mb-4">
              <div className="w-12 h-12 rounded-full bg-[#2fd484] flex items-center justify-center text-black shadow-[0_0_20px_rgba(47,212,132,0.4)]">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
              </div>
            </div>
            <h2 className="text-[22px] font-bold text-white mb-2">Package Delivered</h2>
            <p className="text-sm text-[#2fd484] font-medium leading-relaxed">
              Delivered at 2:41 PM<br/>
              <span className="text-[#a5a1a1]">Signed by T. Balogun.</span>
            </p>
          </div>

          {/* Proof of delivery photo placeholder */}
          <div className="bg-[#121212] rounded-[20px] p-1 border border-white/5 relative group cursor-pointer overflow-hidden">
            <div className="w-full aspect-[4/3] bg-[#282525] rounded-[16px] flex flex-col items-center justify-center relative overflow-hidden">
              {/* Fake photo representation */}
              <div className="absolute inset-0 opacity-40 mix-blend-luminosity">
                <Image 
                  src="/images/biker14.jpeg" 
                  alt="Delivery Proof" 
                  fill 
                  className="object-cover object-center grayscale"
                />
              </div>
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
              
              <div className="relative z-10 flex flex-col items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center backdrop-blur">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><circle cx="8.5" cy="8.5" r="1.5"></circle><polyline points="21 15 16 10 5 21"></polyline></svg>
                </div>
                <span className="text-[13px] font-bold text-white tracking-[0.5px] uppercase">Proof of Delivery Photo</span>
              </div>
            </div>
          </div>

          <div className="flex-1" />

          <Link href="/tracking" className="w-full h-14 bg-white/5 border border-white/10 rounded-full flex items-center justify-center transition-colors hover:bg-white/10 mt-8 mb-4">
            <span className="text-white font-bold text-[13px] tracking-[1px] uppercase">
              Track Another Package
            </span>
          </Link>
          
        </div>
      </div>
    </main>
  );
}
