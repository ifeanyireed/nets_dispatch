"use client";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState, useRef } from "react";
import { IconChevronLeft, IconMapPin, IconCreditCard, IconBell, IconHeadset, IconChevronRight, IconShieldCheck, IconUsers, IconMotorbike, IconChecklist, IconArchive, IconCamera } from "@tabler/icons-react";

export default function Profile() {
  const router = useRouter();
  const [userData, setUserData] = useState(null);
  const [profileData, setProfileData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({ riders: 0, pending: 0, orders: 0 });
  const [isUploading, setIsUploading] = useState(false);
  const [avatarUrl, setAvatarUrl] = useState("/images/biker11.jpeg");
  const fileInputRef = useRef(null);

  const handleImageUpload = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setIsUploading(true);
    try {
      // 1. Upload the file
      const formData = new FormData();
      formData.append("file", file);
      const uploadRes = await fetch("https://nets-logistics-api.onrender.com/upload", {
        method: "POST",
        body: formData,
      });
      const uploadData = await uploadRes.json();
      if (!uploadRes.ok) throw new Error(uploadData.error || "Failed to upload image");

      const newAvatarUrl = uploadData.url;

      // 2. Update user profile if we have their ID
      if (userData?.id) {
        const patchRes = await fetch(`https://nets-logistics-api.onrender.com/users/${userData.id}/avatar`, {
          method: "PATCH",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ avatarUrl: newAvatarUrl }),
        });
        if (!patchRes.ok) {
          const errData = await patchRes.json().catch(() => ({}));
          throw new Error(`Failed to save avatar to profile: ${errData.error || patchRes.statusText}`);
        }
      }

      // 3. Update local state
      setAvatarUrl(newAvatarUrl);
      const updatedUser = { ...userData, avatarUrl: newAvatarUrl };
      setUserData(updatedUser);
      localStorage.setItem("user", JSON.stringify(updatedUser));
    } catch (err) {
      console.error(err);
      alert(err.message);
    } finally {
      setIsUploading(false);
    }
  };

  useEffect(() => {
    // Load from local storage
    const user = localStorage.getItem("user");
    const profile = localStorage.getItem("profile");
    
    if (user) {
      const parsedUser = JSON.parse(user);
      setUserData(parsedUser);
      if (parsedUser.avatarUrl) setAvatarUrl(parsedUser.avatarUrl);
    }
    if (profile) setProfileData(JSON.parse(profile));
    
    // Fetch real stats
    const fetchStats = async () => {
      try {
        const [ridersRes, ordersRes] = await Promise.all([
          fetch("https://nets-logistics-api.onrender.com/riders"),
          fetch("https://nets-logistics-api.onrender.com/orders")
        ]);
        const riders = await ridersRes.json();
        const orders = await ordersRes.json();
        
        if (Array.isArray(riders) && Array.isArray(orders)) {
          setStats({
            riders: riders.filter(r => r.status === "Active").length,
            pending: riders.filter(r => r.status === "Pending").length,
            orders: orders.length
          });
        }
      } catch (e) {}
    };

    fetchStats();
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

  if (loading) return <div className="min-h-full bg-transparent flex items-center justify-center"><div className="w-8 h-8 rounded-full border-2 border-hazard border-t-transparent animate-spin" /></div>;

  return (
    <main className="flex-1 w-full flex flex-col relative overflow-y-auto font-sans p-6 lg:p-10 hide-scrollbar">
      {/* Background Decorators */}
      <div className="absolute top-0 left-0 right-0 h-64 bg-gradient-to-b from-hazard/10 to-transparent z-0 pointer-events-none mix-blend-screen" />
      <div className="absolute -top-40 -right-40 w-96 h-96 bg-hazard/20 rounded-full blur-[120px] z-0 pointer-events-none" />

      <div className="relative z-10 w-full max-w-4xl mx-auto flex flex-col gap-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-4">
          <div>
            <h1 className="text-white font-extrabold text-3xl tracking-wide flex items-center gap-3">
              <span className="bg-clip-text text-transparent bg-gradient-to-r from-white to-white/60">
                Agent Profile
              </span>
            </h1>
            <p className="text-text-2 font-mono text-xs uppercase tracking-widest mt-1">Manage your console settings</p>
          </div>
          <button 
            onClick={handleLogout} 
            className="hidden md:flex items-center justify-center px-6 py-2.5 rounded-full border border-hazard/30 bg-hazard/10 hover:bg-hazard hover:text-white hover:shadow-[0_0_20px_rgba(239,68,68,0.4)] transition-all text-hazard font-bold text-xs tracking-widest uppercase"
          >
            Log Out
          </button>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Left Column: Identity Card & Stats */}
          <div className="lg:col-span-1 flex flex-col gap-6">
            {/* Identity Card */}
            <div className="bg-panel border border-hairline rounded-3xl p-8 flex flex-col items-center justify-center relative overflow-hidden group">
              <div className="absolute inset-0 bg-gradient-to-b from-white/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
              
              <div className="relative z-10 mb-5">
                <input 
                  type="file" 
                  ref={fileInputRef} 
                  onChange={handleImageUpload} 
                  accept="image/*" 
                  className="hidden" 
                />
                <div className="w-28 h-28 rounded-full border-4 border-ink ring-2 ring-hazard/50 shadow-[0_0_30px_rgba(239,68,68,0.2)] overflow-hidden bg-panel relative group-hover:ring-hazard transition-colors">
                  <Image src={avatarUrl} alt="Avatar" fill className="object-cover group-hover:scale-110 transition-transform duration-500" />
                  {isUploading && (
                    <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
                      <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    </div>
                  )}
                </div>
                <button 
                  onClick={() => fileInputRef.current?.click()}
                  className="absolute bottom-0 right-0 p-2 bg-hazard rounded-full border-2 border-ink text-white hover:scale-110 transition-transform shadow-lg cursor-pointer"
                >
                  <IconCamera size={16} />
                </button>
              </div>
              
              <h2 className="text-white text-2xl font-extrabold mb-1.5 z-10 text-center">{name}</h2>
              <div className="px-4 py-1.5 bg-hazard/10 border border-hazard/20 rounded-full z-10 mb-2">
                <span className="text-hazard text-[10px] font-black tracking-[1px] uppercase">
                  Level 4 Dispatcher
                </span>
              </div>
              <p className="text-text-2 text-sm font-mono z-10 text-center">{hub}</p>
            </div>

            {/* Quick Stats */}
            <div className="grid grid-cols-2 gap-4">
              <div className="bg-panel border border-hairline rounded-2xl p-5 hover:border-hairline-2 transition-colors flex flex-col items-center text-center">
                <div className="w-10 h-10 rounded-full bg-live/10 flex items-center justify-center mb-3">
                  <IconMotorbike size={20} className="text-live" />
                </div>
                <span className="text-2xl font-black text-white font-mono">{stats.riders}</span>
                <span className="text-[10px] uppercase tracking-widest text-text-2 font-bold mt-1">Active Riders</span>
              </div>
              
              <div className="bg-panel border border-hairline rounded-2xl p-5 hover:border-hairline-2 transition-colors flex flex-col items-center text-center">
                <div className="w-10 h-10 rounded-full bg-[#f59e0b]/10 flex items-center justify-center mb-3">
                  <IconChecklist size={20} className="text-[#f59e0b]" />
                </div>
                <span className="text-2xl font-black text-white font-mono">{stats.pending}</span>
                <span className="text-[10px] uppercase tracking-widest text-text-2 font-bold mt-1">Pending Approvals</span>
              </div>
              
              <div className="col-span-2 bg-panel border border-hairline rounded-2xl p-5 hover:border-hairline-2 transition-colors flex items-center gap-4">
                <div className="w-12 h-12 rounded-full bg-blue-500/10 flex items-center justify-center flex-none">
                  <IconArchive size={24} className="text-blue-400" />
                </div>
                <div className="flex flex-col flex-1">
                  <span className="text-2xl font-black text-white font-mono">{stats.orders}</span>
                  <span className="text-[10px] uppercase tracking-widest text-text-2 font-bold">Total Orders Processed</span>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column: Settings & Info */}
          <div className="lg:col-span-2 flex flex-col gap-6">
            
            {/* Personal Info */}
            <div className="bg-panel border border-hairline rounded-3xl p-1 overflow-hidden">
              <div className="px-6 py-5 border-b border-hairline bg-panel-2/30">
                <h3 className="font-sans font-bold text-[13px] tracking-widest uppercase text-text-2">Personal Information</h3>
              </div>
              <div className="p-2">
                <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 hover:bg-panel-2/50 rounded-2xl transition-colors">
                  <span className="text-[13px] font-semibold text-text-1 mb-1 sm:mb-0">Full Name</span>
                  <span className="text-[14px] font-bold text-white">{name}</span>
                </div>
                <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 hover:bg-panel-2/50 rounded-2xl transition-colors">
                  <span className="text-[13px] font-semibold text-text-1 mb-1 sm:mb-0">Email Address</span>
                  <span className="text-[14px] font-bold text-white">{email}</span>
                </div>
                <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 hover:bg-panel-2/50 rounded-2xl transition-colors">
                  <span className="text-[13px] font-semibold text-text-1 mb-1 sm:mb-0">Role</span>
                  <span className="text-[14px] font-bold text-white">Administrator Agent</span>
                </div>
              </div>
            </div>

            {/* Account Settings */}
            <div className="bg-panel border border-hairline rounded-3xl p-1 overflow-hidden">
              <div className="px-6 py-5 border-b border-hairline bg-panel-2/30">
                <h3 className="font-sans font-bold text-[13px] tracking-widest uppercase text-text-2">Preferences & Security</h3>
              </div>
              <div className="p-2 flex flex-col gap-1">
                <button className="flex items-center text-left group p-3 hover:bg-panel-2 rounded-2xl transition-all">
                  <div className="w-12 h-12 bg-ink rounded-xl border border-hairline flex items-center justify-center group-hover:border-hazard/30 group-hover:text-hazard transition-all text-text-1 shadow-sm">
                    <IconShieldCheck size={24} />
                  </div>
                  <div className="ml-4 flex-1 flex flex-col">
                    <span className="text-[15px] font-extrabold text-white group-hover:text-hazard transition-colors">Security Settings</span>
                    <span className="text-[12px] text-text-2 mt-0.5">Password, 2FA, and active sessions</span>
                  </div>
                  <IconChevronRight size={20} className="text-text-2 group-hover:text-hazard transition-colors" />
                </button>

                <button className="flex items-center text-left group p-3 hover:bg-panel-2 rounded-2xl transition-all">
                  <div className="w-12 h-12 bg-ink rounded-xl border border-hairline flex items-center justify-center group-hover:border-live/30 group-hover:text-live transition-all text-text-1 shadow-sm">
                    <IconBell size={24} />
                  </div>
                  <div className="ml-4 flex-1 flex flex-col">
                    <span className="text-[15px] font-extrabold text-white group-hover:text-live transition-colors">Notification Alerts</span>
                    <span className="text-[12px] text-text-2 mt-0.5">Manage dashboard sounds and popups</span>
                  </div>
                  <IconChevronRight size={20} className="text-text-2 group-hover:text-live transition-colors" />
                </button>
                
                <button className="flex items-center text-left group p-3 hover:bg-panel-2 rounded-2xl transition-all">
                  <div className="w-12 h-12 bg-ink rounded-xl border border-hairline flex items-center justify-center group-hover:border-[#f59e0b]/30 group-hover:text-[#f59e0b] transition-all text-text-1 shadow-sm">
                    <IconUsers size={24} />
                  </div>
                  <div className="ml-4 flex-1 flex flex-col">
                    <span className="text-[15px] font-extrabold text-white group-hover:text-[#f59e0b] transition-colors">Team Access</span>
                    <span className="text-[12px] text-text-2 mt-0.5">View other dispatchers in your hub</span>
                  </div>
                  <IconChevronRight size={20} className="text-text-2 group-hover:text-[#f59e0b] transition-colors" />
                </button>
              </div>
            </div>

            {/* Support Banner */}
            <div className="bg-gradient-to-r from-hazard/20 to-hazard/5 border border-hazard/30 rounded-3xl p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6 relative overflow-hidden group">
              <div className="absolute -right-6 -bottom-6 text-hazard/10 group-hover:text-hazard/20 transition-colors pointer-events-none">
                <IconHeadset size={120} />
              </div>
              <div className="relative z-10 flex flex-col">
                <span className="text-lg font-extrabold text-white mb-1">Need IT Support?</span>
                <span className="text-[13px] text-text-1 max-w-sm">Contact the engineering team if you encounter bugs or require system-level access changes.</span>
              </div>
              <button className="relative z-10 whitespace-nowrap px-6 py-3 rounded-xl bg-hazard text-white font-bold text-[13px] shadow-[0_4px_14px_rgba(239,68,68,0.4)] hover:bg-hazard/90 hover:-translate-y-0.5 transition-all">
                Contact Support
              </button>
            </div>
            
            <button 
              onClick={handleLogout} 
              className="md:hidden w-full h-[54px] bg-transparent border border-hairline hover:border-hazard/50 hover:bg-hazard/10 rounded-2xl flex items-center justify-center transition-all mt-4"
            >
              <span className="text-text-1 font-bold text-[13px] tracking-widest uppercase">
                LOG OUT
              </span>
            </button>

          </div>
        </div>
      </div>
    </main>
  );
}
