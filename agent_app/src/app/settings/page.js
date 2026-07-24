"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { IconBell, IconMail, IconDeviceMobile, IconRefresh, IconShield, IconTag, IconChevronLeft, IconDeviceFloppy } from "@tabler/icons-react";
import Link from "next/link";

export default function SettingsPage() {
  const router = useRouter();
  const [userData, setUserData] = useState(null);
  const [settings, setSettings] = useState({
    pushEnabled: true,
    emailEnabled: true,
    orderUpdates: true,
    promotions: false,
    systemAlerts: true,
  });
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    const userStr = localStorage.getItem("user");
    if (!userStr) {
      router.push("/login");
      return;
    }
    const parsedUser = JSON.parse(userStr);
    setUserData(parsedUser);
    fetchSettings(parsedUser.id);
  }, []);

  const fetchSettings = async (userId) => {
    try {
      const res = await fetch(`https://nets-logistics-api.onrender.com/users/${userId}/settings/notifications`);
      if (res.ok) {
        const data = await res.json();
        setSettings({
          pushEnabled: data.pushEnabled ?? true,
          emailEnabled: data.emailEnabled ?? true,
          orderUpdates: data.orderUpdates ?? true,
          promotions: data.promotions ?? false,
          systemAlerts: data.systemAlerts ?? true,
        });
      }
    } catch (err) {
      console.error("Failed to load settings:", err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleToggle = (key) => {
    setSettings((prev) => ({ ...prev, [key]: !prev[key] }));
  };

  const saveSettings = async () => {
    if (!userData?.id) return;
    setIsSaving(true);
    try {
      const res = await fetch(`https://nets-logistics-api.onrender.com/users/${userData.id}/settings/notifications`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(settings),
      });

      if (!res.ok) {
        throw new Error("Failed to save settings");
      }
      
      alert("Settings saved successfully");
    } catch (err) {
      alert(`Error: ${err.message}`);
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-black flex items-center justify-center">
        <div className="w-8 h-8 border-4 border-hazard border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-black text-white font-sans flex flex-col">
      {/* App Bar (Header) */}
      <header className="sticky top-0 z-50 bg-transparent">
        <div className="max-w-3xl mx-auto px-4 h-[60px] flex items-center justify-between">
          <Link href="/profile" className="p-2 -ml-2 rounded-full hover:bg-white/5 transition-colors">
            <IconChevronLeft className="w-6 h-6 text-white" />
          </Link>
          <h1 className="text-[18px] font-bold text-white font-sans">
            Notification Settings
          </h1>
          <button
            onClick={saveSettings}
            disabled={isSaving}
            className="p-2 -mr-2 rounded-full hover:bg-white/5 transition-colors text-hazard disabled:opacity-50"
          >
            {isSaving ? (
              <div className="w-5 h-5 border-2 border-hazard border-t-transparent rounded-full animate-spin" />
            ) : (
              <IconDeviceFloppy className="w-6 h-6" />
            )}
          </button>
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-1 w-full max-w-3xl mx-auto px-6 py-5 overflow-y-auto hide-scrollbar">
        
        {/* Delivery Methods Section */}
        <div className="mb-8">
          <h2 className="text-[12px] font-bold tracking-[1.2px] text-white/40 ml-2 mb-3 font-sans">
            DELIVERY METHODS
          </h2>
          <div className="bg-[#1c1a1a] rounded-[20px] border border-white/5 overflow-hidden">
            <ToggleRow
              icon={<IconDeviceMobile className="w-5 h-5" />}
              title="Push Notifications"
              description="Receive alerts directly on your device"
              checked={settings.pushEnabled}
              onChange={() => handleToggle("pushEnabled")}
            />
            <div className="h-px w-full bg-white/5" />
            <ToggleRow
              icon={<IconMail className="w-5 h-5" />}
              title="Email Notifications"
              description="Receive daily summaries and critical alerts via email"
              checked={settings.emailEnabled}
              onChange={() => handleToggle("emailEnabled")}
            />
          </div>
        </div>

        {/* Notification Types Section */}
        <div className="mb-8">
          <h2 className="text-[12px] font-bold tracking-[1.2px] text-white/40 ml-2 mb-3 font-sans">
            NOTIFICATION TYPES
          </h2>
          <div className="bg-[#1c1a1a] rounded-[20px] border border-white/5 overflow-hidden">
            <ToggleRow
              icon={<IconRefresh className="w-5 h-5" />}
              title="Order & Delivery Updates"
              description="Get notified about status changes and assignments"
              checked={settings.orderUpdates}
              onChange={() => handleToggle("orderUpdates")}
            />
            <div className="h-px w-full bg-white/5" />
            <ToggleRow
              icon={<IconShield className="w-5 h-5" />}
              title="System Alerts"
              description="Security notices and platform maintenance"
              checked={settings.systemAlerts}
              onChange={() => handleToggle("systemAlerts")}
            />
            <div className="h-px w-full bg-white/5" />
            <ToggleRow
              icon={<IconTag className="w-5 h-5" />}
              title="Promotions & News"
              description="Platform updates and special offers"
              checked={settings.promotions}
              onChange={() => handleToggle("promotions")}
            />
          </div>
        </div>
        
      </main>
    </div>
  );
}

function ToggleRow({ icon, title, description, checked, onChange }) {
  return (
    <div className="flex items-center justify-between px-5 py-3 bg-transparent">
      <div className="flex items-center space-x-4 flex-1">
        <div className="w-10 h-10 rounded-[10px] bg-white/5 flex items-center justify-center text-white/70">
          {icon}
        </div>
        <div className="flex-1">
          <h3 className="font-semibold text-[15px] text-white font-sans">{title}</h3>
          <p className="text-[12px] text-white/50 font-sans mt-1 leading-tight">{description}</p>
        </div>
      </div>
      <button
        type="button"
        className={`relative inline-flex h-[24px] w-[44px] flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none ml-4 ${
          checked ? 'bg-hazard/30' : 'bg-white/10'
        }`}
        onClick={onChange}
        role="switch"
        aria-checked={checked}
      >
        {/* Toggle switch track overlay if active to give it the primaryRed activeTrackColor feel from flutter, while thumb is primaryRed */}
        <div className={`absolute inset-0 rounded-full transition-opacity ${checked ? 'bg-hazard/50 opacity-100' : 'opacity-0'}`} />
        <span
          className={`relative inline-block h-5 w-5 transform rounded-full shadow ring-0 transition duration-200 ease-in-out ${
            checked ? 'translate-x-5 bg-hazard' : 'translate-x-0 bg-white/50'
          }`}
        />
      </button>
    </div>
  );
}

