"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Bell, Mail, Smartphone, RefreshCw, ShieldAlert, Tag, ArrowLeft } from "lucide-react";
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
  const [error, setError] = useState(null);

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
          pushEnabled: data.pushEnabled,
          emailEnabled: data.emailEnabled,
          orderUpdates: data.orderUpdates,
          promotions: data.promotions,
          systemAlerts: data.systemAlerts,
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
    setError(null);
    try {
      const res = await fetch(`https://nets-logistics-api.onrender.com/users/${userData.id}/settings/notifications`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(settings),
      });

      if (!res.ok) {
        throw new Error("Failed to save settings");
      }
      
      // Optionally show a success toast here
    } catch (err) {
      setError(err.message);
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-[#0E0E0E] flex items-center justify-center">
        <div className="w-8 h-8 border-4 border-azure border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#0E0E0E] text-white">
      {/* Header */}
      <header className="sticky top-0 z-50 bg-[#0E0E0E]/80 backdrop-blur-xl border-b border-white/5">
        <div className="max-w-4xl mx-auto px-6 h-20 flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <Link href="/dashboard" className="p-2 hover:bg-white/5 rounded-full transition-colors">
              <ArrowLeft className="w-5 h-5 text-gray-400" />
            </Link>
            <div>
              <h1 className="text-2xl font-bold bg-gradient-to-r from-white to-gray-400 bg-clip-text text-transparent">
                Settings
              </h1>
              <p className="text-sm text-gray-500">Manage your notifications and preferences</p>
            </div>
          </div>
          <button
            onClick={saveSettings}
            disabled={isSaving}
            className="px-6 py-2.5 bg-azure text-white text-sm font-semibold rounded-full hover:bg-azure/90 transition-all shadow-lg shadow-azure/20 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
          >
            {isSaving ? (
              <>
                <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                <span>Saving...</span>
              </>
            ) : (
              <span>Save Changes</span>
            )}
          </button>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-6 py-12">
        {error && (
          <div className="mb-8 p-4 bg-red-500/10 border border-red-500/20 rounded-2xl text-red-400 text-sm">
            {error}
          </div>
        )}

        <div className="space-y-8">
          {/* Notification Channels */}
          <section className="bg-white/[0.02] border border-white/5 rounded-3xl overflow-hidden">
            <div className="p-6 border-b border-white/5 flex items-center space-x-3">
              <div className="w-10 h-10 rounded-xl bg-azure/10 flex items-center justify-center text-azure">
                <Bell className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-semibold">Delivery Methods</h2>
                <p className="text-sm text-gray-500">How you receive your notifications</p>
              </div>
            </div>
            <div className="p-6 space-y-6">
              <ToggleRow
                icon={<Smartphone className="w-5 h-5" />}
                title="Push Notifications"
                description="Receive alerts directly on your device"
                checked={settings.pushEnabled}
                onChange={() => handleToggle("pushEnabled")}
              />
              <ToggleRow
                icon={<Mail className="w-5 h-5" />}
                title="Email Notifications"
                description="Receive daily summaries and critical alerts via email"
                checked={settings.emailEnabled}
                onChange={() => handleToggle("emailEnabled")}
              />
            </div>
          </section>

          {/* Alert Types */}
          <section className="bg-white/[0.02] border border-white/5 rounded-3xl overflow-hidden">
            <div className="p-6 border-b border-white/5 flex items-center space-x-3">
              <div className="w-10 h-10 rounded-xl bg-hazel/10 flex items-center justify-center text-hazel">
                <ShieldAlert className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-lg font-semibold">Notification Types</h2>
                <p className="text-sm text-gray-500">What you get notified about</p>
              </div>
            </div>
            <div className="p-6 space-y-6">
              <ToggleRow
                icon={<RefreshCw className="w-5 h-5" />}
                title="Order & Delivery Updates"
                description="Get notified about status changes and assignments"
                checked={settings.orderUpdates}
                onChange={() => handleToggle("orderUpdates")}
              />
              <ToggleRow
                icon={<ShieldAlert className="w-5 h-5" />}
                title="System Alerts"
                description="Security notices and platform maintenance"
                checked={settings.systemAlerts}
                onChange={() => handleToggle("systemAlerts")}
              />
              <ToggleRow
                icon={<Tag className="w-5 h-5" />}
                title="Promotions & News"
                description="Platform updates and special offers"
                checked={settings.promotions}
                onChange={() => handleToggle("promotions")}
              />
            </div>
          </section>
        </div>
      </main>
    </div>
  );
}

function ToggleRow({ icon, title, description, checked, onChange }) {
  return (
    <div className="flex items-center justify-between p-4 rounded-2xl hover:bg-white/[0.02] transition-colors cursor-pointer" onClick={onChange}>
      <div className="flex items-center space-x-4">
        <div className="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center text-gray-400">
          {icon}
        </div>
        <div>
          <h3 className="font-medium text-gray-200">{title}</h3>
          <p className="text-sm text-gray-500">{description}</p>
        </div>
      </div>
      <button
        type="button"
        className={`relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none ${
          checked ? 'bg-azure' : 'bg-gray-700'
        }`}
        role="switch"
        aria-checked={checked}
      >
        <span
          className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out ${
            checked ? 'translate-x-5' : 'translate-x-0'
          }`}
        />
      </button>
    </div>
  );
}
