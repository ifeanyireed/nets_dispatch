import Image from "next/image";
import Link from "next/link";

export default function Verify() {
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
            <span className="text-[48px] font-semibold text-white tracking-[-1.0px] leading-none">Verify</span>
            <span className="text-[48px] font-semibold text-hazard tracking-[-1.0px] leading-none">Code</span>
          </div>
          
          <p className="mt-2 text-[12px] font-extrabold text-[#a5a1a1] tracking-[1.5px]">SECURE YOUR ACCOUNT</p>
        </div>

        <div className="flex-[0.5]" />

        <form className="flex flex-col mt-10">
          <div className="bg-[#282525] border border-white/5 p-4 rounded-[20px] text-center mb-6">
            <p className="text-[13px] font-medium text-white">A 6-digit code was sent to your registered device.</p>
          </div>
          
          <div className="flex gap-2 justify-between mb-8">
            {[...Array(6)].map((_, i) => (
              <input 
                key={i}
                type="text" 
                maxLength={1}
                className="w-12 h-14 bg-[#282525] border border-white/5 rounded-[12px] text-center text-xl font-bold text-white focus:border-hazard focus:outline-none transition-colors" 
              />
            ))}
          </div>

          <div className="flex-1" />

          <Link href="/dashboard" className="w-full h-14 bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] rounded-full shadow-[0_8px_16px_rgba(255,42,42,0.3)] flex items-center justify-center transition-opacity hover:opacity-90 mt-4">
            <span className="text-white font-extrabold text-[15px] tracking-[1.5px] uppercase">
              Verify Code
            </span>
          </Link>

          <div className="flex items-center justify-center mt-6 mb-6">
            <button type="button" className="text-[12px] font-bold text-[#a5a1a1] tracking-[0.5px] uppercase hover:text-white transition-colors">
              RESEND CODE
            </button>
          </div>
        </form>
      </div>
    </main>
  );
}
