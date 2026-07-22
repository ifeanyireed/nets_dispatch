"use client";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { IconChevronLeft, IconMapPin, IconCreditCard, IconBell, IconHeadset, IconChevronRight, IconShieldCheck, IconUsers } from "@tabler/icons-react";

export default function Profile() {
  const router = useRouter();
  const [userData, setUserData] = useState(null);
  const [profileData, setProfileData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Load from local storage
    const user = localStorage.getItem("user");
    const profile = localStorage.getItem("profile");
    
    if (user) setUserData(JSON.parse(user));
    if (profile) setProfileData(JSON.parse(profile));
    
    setLoading(false);
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("user");
    localStorage.removeItem("profile");
    router.push("/login");
  };

  const name = profileData?.name || "Agent";
  const email = userData?.email || "agent@nets.com";
  const hub = profileData?.hub || "HQ Dispatch";

  if (loading) return <div className="min-h-screen bg-ink"></div>;

  return (
    <main className="min-h-screen w-full flex bg-ink relative overflow-y-auto font-sans">
      {/* Global Background Image */}
      <div className="fixed inset-0 z-0">
        <Image src="/images/biker14.jpeg" alt="App Background" fill className="object-cover opacity-30 mix-blend-luminosity" priority />
        <div className="absolute inset-0 bg-gradient-to-b from-ink/80 via-ink/95 to-ink" />
      </div>

      <div className="relative z-10 w-full flex flex-col px-6 py-10 max-w-lg mx-auto">
        {/* App Bar */}
        <div className="flex items-center justify-between mb-8">
          <Link href="/dashboard" className="text-text-1 hover:text-white transition-colors p-2 -ml-2">
            <IconChevronLeft size={24} />
          </Link>
          <span className="text-white font-extrabold text-lg tracking-wide">Profile</span>
          <div className="w-10" />
        </div>

        {/* Top Avatar header card */}
        <div className="flex flex-col items-center justify-center mb-8">
          <div className="w-[84px] h-[84px] rounded-full border-[3px] border-hazard overflow-hidden mb-4 relative shadow-[0_4px_20px_-4px_rgba(239,68,68,0.4)] bg-panel">
            <Image src="/images/biker11.jpeg" alt="Avatar" fill className="object-cover" />
          </div>
          <h2 className="text-white text-[18px] font-extrabold mb-1.5">{name}</h2>
          <div className="px-3 py-1 bg-blue-500/10 border border-blue-500/30 rounded-full">
            <span className="text-blue-500 text-[9px] font-black tracking-[0.5px] uppercase">
              PREMIUM AGENT
            </span>
          </div>
        </div>

        {/* Personal Info Card */}
        <div className="mb-6">
          <span className="text-[11px] font-black text-text-2 tracking-[0.5px] uppercase block mb-2.5 ml-1">
            Personal Information
          </span>
          <div className="w-full bg-panel/90 backdrop-blur-md rounded-[20px] p-4 border border-white/5 flex flex-col gap-3">
            <div className="flex justify-between items-center">
              <span className="text-[12px] font-semibold text-text-2">Full Name</span>
              <span className="text-[12px] font-extrabold text-white font-mono">{name}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-[12px] font-semibold text-text-2">Email Address</span>
              <span className="text-[12px] font-extrabold text-white font-mono">{email}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-[12px] font-semibold text-text-2">Dispatch Hub</span>
              <span className="text-[12px] font-extrabold text-white font-mono">{hub}</span>
            </div>
          </div>
        </div>

        {/* Account Settings */}
        <div className="mb-6">
          <span className="text-[11px] font-black text-text-2 tracking-[0.5px] uppercase block mb-2.5 ml-1">
            Account Settings
          </span>
          <div className="w-full bg-panel/90 backdrop-blur-md rounded-[20px] p-4 border border-white/5 flex flex-col gap-4">
            
            <button className="flex items-center text-left group">
              <div className="p-2 bg-ink rounded-full group-hover:bg-panel-2 transition-colors">
                <IconShieldCheck size={20} className="text-white/70" />
              </div>
              <div className="ml-3.5 flex-1 flex flex-col">
                <span className="text-[14px] font-bold text-white">Security</span>
                <span className="text-[11px] text-text-2">Change your password and 2FA</span>
              </div>
              <IconChevronRight size={16} className="text-text-2" />
            </button>
            
            <div className="h-px w-full bg-white/5" />

            <button className="flex items-center text-left group">
              <div className="p-2 bg-ink rounded-full group-hover:bg-panel-2 transition-colors">
                <IconUsers size={20} className="text-white/70" />
              </div>
              <div className="ml-3.5 flex-1 flex flex-col">
                <span className="text-[14px] font-bold text-white">Rider Management</span>
                <span className="text-[11px] text-text-2">Assign and monitor active riders</span>
              </div>
              <IconChevronRight size={16} className="text-text-2" />
            </button>

            <div className="h-px w-full bg-white/5" />

            <button className="flex items-center text-left group">
              <div className="p-2 bg-ink rounded-full group-hover:bg-panel-2 transition-colors">
                <IconBell size={20} className="text-white/70" />
              </div>
              <div className="ml-3.5 flex-1 flex flex-col">
                <span className="text-[14px] font-bold text-white">Notifications</span>
                <span className="text-[11px] text-text-2">Manage alerts and updates</span>
              </div>
              <IconChevronRight size={16} className="text-text-2" />
            </button>

          </div>
        </div>

        {/* Support Action Banner */}
        <button className="w-full bg-hazard/10 border border-hazard/20 rounded-[20px] p-4 mb-8 flex items-center text-left hover:bg-hazard/15 transition-colors">
          <IconHeadset size={24} className="text-hazard flex-none" />
          <div className="ml-3.5 flex-1 flex flex-col">
            <span className="text-[13px] font-extrabold text-white">Help & Support</span>
            <span className="text-[11px] text-text-2 leading-[1.3] mt-0.5">Contact IT for issues with your dashboard or account.</span>
          </div>
          <IconChevronRight size={14} className="text-hazard flex-none" />
        </button>

        {/* Logout Button */}
        <button 
          onClick={handleLogout} 
          className="w-full h-[52px] bg-transparent border border-white/10 rounded-full flex items-center justify-center transition-colors hover:bg-white/5 mb-10"
        >
          <span className="text-white/70 font-extrabold text-[12px] tracking-[1.5px] uppercase">
            LOG OUT
          </span>
        </button>
      </div>
    </main>
  );
}
