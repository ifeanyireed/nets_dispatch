import Link from "next/link";
import Image from "next/image";

export default function SplashPage() {
  return (
    <div className="relative min-h-screen bg-black overflow-hidden flex flex-col font-sans">
      {/* Background Image */}
      <div className="absolute inset-0 z-0">
        <Image
          src="/images/biker14.jpeg"
          alt="Biker Background"
          fill
          priority
          className="object-cover object-center"
        />
      </div>

      {/* Dark Overlay Gradient */}
      <div className="absolute inset-0 z-10 bg-gradient-to-b from-black/30 via-black/70 to-black pointer-events-none" />

      {/* Content */}
      <main className="relative z-20 flex-1 flex flex-col px-6 py-6 max-w-lg mx-auto w-full">
        <div className="mt-10 flex items-center gap-3">
          <div className="w-9 h-9 rounded-lg overflow-hidden flex items-center justify-center shrink-0">
            <Image
              src="/logo.png"
              alt="NETS Logo"
              width={36}
              height={36}
              className="object-cover"
            />
          </div>
          <span className="text-white font-semibold text-[22px]" style={{ fontFamily: 'Inter' }}>
            NETS Dispatch
          </span>
        </div>

        <div className="flex-1" />

        {/* Text Content */}
        <div className="mb-8">
          <h1 className="text-white font-semibold text-[40px] leading-[1.15] mb-4" style={{ fontFamily: 'Inter' }}>
            Command<br />Center
          </h1>
          <p className="text-white/70 text-[14px] font-medium leading-normal max-w-[280px]" style={{ fontFamily: 'Inter' }}>
            Manage riders, vendors, and oversee real-time logistics operations across the fleet.
          </p>
        </div>

        {/* Actions */}
        <div className="flex flex-col gap-3 mb-6">
          <Link
            href="/login"
            className="w-full h-14 bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] rounded-full shadow-[0_8px_16px_rgba(255,42,42,0.3)] flex items-center justify-center transition-opacity hover:opacity-90"
          >
            <span className="text-white font-extrabold text-[15px] tracking-[1.5px] uppercase">
              Log In
            </span>
          </Link>
          <div className="flex gap-3">
            <Link
              href="/register"
              className="flex-1 h-14 bg-transparent border border-white/15 rounded-full flex items-center justify-center transition-colors hover:bg-white/5"
            >
              <span className="text-white font-extrabold text-[13px] tracking-[1px] uppercase">
                Register
              </span>
            </Link>
            <Link
              href="/tracking"
              className="flex-1 h-14 bg-white/10 border border-white/10 rounded-full flex items-center justify-center transition-colors hover:bg-white/20 backdrop-blur-md"
            >
              <span className="text-white font-extrabold text-[13px] tracking-[1px] uppercase">
                Track Package
              </span>
            </Link>
          </div>
        </div>
      </main>
    </div>
  );
}
