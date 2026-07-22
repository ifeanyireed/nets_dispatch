import Image from "next/image";
import Link from "next/link";

export default function Register() {
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
      <div className="relative z-10 w-full flex flex-col px-6 py-5 max-w-lg mx-auto overflow-y-auto">
        <div className="mt-[30px] flex-none">
          {/* Title Area */}
          <div className="flex items-end gap-0">
            <span className="text-[48px] font-semibold text-white tracking-[-1.0px] leading-none">Create</span>
            <span className="text-[48px] font-semibold text-hazard tracking-[-1.0px] leading-none">Account</span>
          </div>
          
          <p className="mt-2 text-[12px] font-extrabold text-[#a5a1a1] tracking-[1.5px]">JOIN NETS DISPATCH</p>
        </div>

        <div className="flex-[0.5]" />

        <form className="flex flex-col mt-10">
          <label className="text-[12px] font-bold text-[#a5a1a1] mb-2 block">
            Full Name
          </label>
          <div className="bg-[#282525] rounded-full border border-white/5 flex items-center mb-5 px-4 py-3.5">
            <svg className="w-5 h-5 text-[#a5a1a1] mr-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
            <input 
              type="text" 
              className="bg-transparent border-none text-white placeholder-[#706B6B] text-[14px] w-full focus:outline-none focus:ring-0" 
              placeholder="John Doe" 
            />
          </div>

          <label className="text-[12px] font-bold text-[#a5a1a1] mb-2 block">
            Email Address
          </label>
          <div className="bg-[#282525] rounded-full border border-white/5 flex items-center mb-5 px-4 py-3.5">
            <svg className="w-5 h-5 text-[#a5a1a1] mr-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="5" width="18" height="14" rx="2" ry="2"></rect><polyline points="3 7 12 13 21 7"></polyline></svg>
            <input 
              type="text" 
              className="bg-transparent border-none text-white placeholder-[#706B6B] text-[14px] w-full focus:outline-none focus:ring-0" 
              placeholder="Email address" 
            />
          </div>
          
          <label className="text-[12px] font-bold text-[#a5a1a1] mb-2 block">
            Password
          </label>
          <div className="bg-[#282525] rounded-full border border-white/5 flex items-center mb-3 px-4 py-3.5 relative">
            <svg className="w-5 h-5 text-[#a5a1a1] mr-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
            <input 
              type="password" 
              className="bg-transparent border-none text-white placeholder-[#706B6B] text-[14px] w-full focus:outline-none focus:ring-0 pr-10" 
              placeholder="Password" 
            />
            <button type="button" className="absolute right-4 text-[#a5a1a1]">
              <svg className="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
            </button>
          </div>

          <div className="flex items-center justify-start mb-6 mt-2">
            <p className="text-[12px] font-medium text-[#a5a1a1]">
              Already have an account? <Link href="/login" className="text-white hover:text-hazard transition-colors font-bold">Log in</Link>
            </p>
          </div>

          <div className="flex-1" />

          <Link href="/login" className="w-full h-14 bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] rounded-full shadow-[0_8px_16px_rgba(255,42,42,0.3)] flex items-center justify-center transition-opacity hover:opacity-90 mt-4 mb-6">
            <span className="text-white font-extrabold text-[15px] tracking-[1.5px] uppercase">
              Register
            </span>
          </Link>
        </form>
      </div>
    </main>
  );
}
