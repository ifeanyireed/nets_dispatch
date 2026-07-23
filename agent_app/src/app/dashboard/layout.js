"use client";

import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { 
  IconLayoutDashboard, IconLayoutDashboardFilled,
  IconArchive, IconArchiveFilled,
  IconMotorbike, IconMotorbikeFilled,
  IconBasket, IconBasketFilled,
  IconMapPin, IconMapPinFilled,
  IconTruck, IconTruckFilled,
  IconReceipt, IconReceiptFilled,
  IconReportAnalytics, IconReportAnalyticsFilled,
  IconSearch, IconChevronRight
} from "@tabler/icons-react";
import { useState, useEffect } from "react";

export default function DashboardLayout({ children }) {
  const pathname = usePathname();
  const [profileName, setProfileName] = useState("Agent");

  useEffect(() => {
    const p = localStorage.getItem("profile");
    if (p) {
      try {
        setProfileName(JSON.parse(p).name || "Agent");
      } catch (e) {}
    }
  }, []);

  return (
    <div className="flex h-screen overflow-hidden bg-ink relative">
      {/* Global Background Image */}
      <div className="absolute inset-0 z-0">
        <Image src="/images/biker14.jpeg" alt="App Background" fill className="object-cover opacity-40 mix-blend-luminosity" priority />
        <div className="absolute inset-0 bg-ink/85 backdrop-blur-sm" />
      </div>

      <div className="relative z-10 flex w-full h-full">
        {/* Sidebar / Rail */}
        <aside className="w-[240px] flex flex-col border-r border-hairline bg-ink/40 backdrop-blur-md z-40 p-4 gap-3 h-full flex-none overflow-y-auto hidden md:flex">
        {/* Brand */}
        <div className="flex items-center gap-3 pb-4 border-b border-hairline">
          <div className="w-10 h-10 relative flex-none rounded-full overflow-hidden shadow-[0_4px_12px_-4px_rgba(239,68,68,0.5)]">
            <Image src="/images/biker11.jpeg" alt="Agent Avatar" fill className="object-cover" />
          </div>
          <div>
            <h1 className="font-sans font-bold text-sm leading-tight tracking-wide text-text-0">NETS Logistics</h1>
            <p className="font-sans tracking-wide text-sm text-text-2 tracking-widest uppercase mt-0.5">Agent Console</p>
          </div>
        </div>

        {/* Search */}
        <div className="flex items-center gap-2 bg-panel border border-hairline rounded-full px-3 py-2 text-text-2">
          <IconSearch size={14} className="flex-none" />
          <input type="text" placeholder="Search orders, riders..." className="bg-transparent border-none outline-none text-text-0 text-[10px] w-full" />
        </div>

        {/* Nav */}
        <nav className="flex flex-col gap-1 flex-1">
          <span className="font-sans tracking-wide text-[10px] tracking-[0.14em] text-text-2 uppercase px-3 py-1">Menu</span>
          
          <Link href="/dashboard" className={`flex items-center gap-3 px-3 py-1.5 rounded-full transition-all group ${pathname === "/dashboard" ? "bg-panel-2 border border-hairline-2" : "border border-transparent hover:bg-panel"}`}>
            {pathname === "/dashboard" ? (
              <IconLayoutDashboardFilled size={16} className="text-hazard flex-none" />
            ) : (
              <IconLayoutDashboard size={16} className="text-hazard flex-none opacity-70 group-hover:opacity-100 transition-opacity" />
            )}
            <div className="flex flex-col flex-1 min-w-0">
              <span className={`font-sans text-[12px] font-semibold truncate transition-colors ${pathname === "/dashboard" ? "text-text-0" : "text-text-1 group-hover:text-text-0"}`}>Dashboard</span>
            </div>
          </Link>

          <div className="flex flex-col gap-1 mt-2">
          {[
            { name: "Orders", icon: IconArchive, iconFilled: IconArchiveFilled, color: "text-hazard", count: "96" },
            { name: "Riders", icon: IconMotorbike, iconFilled: IconMotorbikeFilled, color: "text-hazard", count: "214" },
            { name: "Vendors", icon: IconBasket, iconFilled: IconBasketFilled, color: "text-hazard", count: "48" },
            { name: "Live Map", icon: IconMapPin, iconFilled: IconMapPinFilled, color: "text-hazard", count: "" },
            { name: "Dispatch", icon: IconTruck, iconFilled: IconTruckFilled, color: "text-hazard", count: "12" },
            { name: "Finance", icon: IconReceipt, iconFilled: IconReceiptFilled, color: "text-hazard", count: "" },
            { name: "Reports", icon: IconReportAnalytics, iconFilled: IconReportAnalyticsFilled, color: "text-hazard", count: "" },
          ].map((item, i) => {
            const href = `/dashboard/${item.name.toLowerCase().replace(" ", "-")}`;
            const isActive = pathname === href;
            const ActiveIcon = isActive ? item.iconFilled : item.icon;
            
            return (
            <Link key={i} href={href} className={`flex items-center gap-3 px-3 py-1.5 rounded-full transition-all group ${isActive ? "bg-panel-2 border border-hairline-2" : "border border-transparent hover:bg-panel"}`}>
              <ActiveIcon size={16} className={`${item.color} ${isActive ? "opacity-100" : "opacity-70 group-hover:opacity-100"} transition-opacity flex-none`} />
              <div className="flex flex-col flex-1 min-w-0">
                <span className={`font-sans text-[12px] font-semibold truncate transition-colors ${isActive ? "text-text-0" : "text-text-1 group-hover:text-text-0"}`}>{item.name}</span>
              </div>
              {item.count && <span className="font-sans tracking-wide text-[10px] text-text-2 flex-none">{item.count}</span>}
            </Link>
          )})}
          </div>
        </nav>

        {/* Footer */}
        <Link href="/profile" className="mt-auto p-3 border border-hairline bg-panel-2/30 backdrop-blur-md rounded-2xl flex items-center gap-3 hover:bg-panel transition-all group cursor-pointer shadow-sm">
          <div className="w-10 h-10 rounded-full border border-hazard/30 group-hover:border-hazard/60 transition-colors overflow-hidden relative shadow-[0_2px_10px_-2px_rgba(239,68,68,0.2)] bg-ink">
            <Image src="/images/biker11.jpeg" alt="Agent Avatar" fill className="object-cover" />
          </div>
          <div className="flex flex-col flex-1 min-w-0">
            <span className="text-text-0 font-extrabold text-sm truncate group-hover:text-hazard transition-colors">{profileName}</span>
            <span className="text-[9px] text-text-2 uppercase tracking-[0.1em] font-bold mt-0.5">Dispatcher HQ</span>
          </div>
          <IconChevronRight size={16} className="text-text-2 group-hover:text-hazard transition-colors flex-none" />
        </Link>
      </aside>

      {/* Main Content */}
      <main className="flex-1 min-w-0 flex flex-col h-full overflow-y-auto">
        {/* Top Ticker */}
        <div className="overflow-hidden whitespace-nowrap border-b border-hairline bg-[#050505]/40 backdrop-blur-md py-1.5 flex-none">
          <div className="inline-flex gap-8 animate-[tickerMove_30s_linear_infinite] font-sans tracking-wide text-[10px] text-text-1">
            {[
              "Order NLG-88231 assigned to Ade O. · Ikeja → Yaba",
              "Chicken Republic — new order NLG-88240 received",
              "Rider Musa B. went offline · Lekki zone",
              "Payout of ₦84,200 approved for Ade O.",
              "Order NLG-88190 delivered · rated 4.9",
            ].map((msg, i) => (
              <span key={i} className="inline-flex items-center gap-2">
                <i className="w-1.5 h-1.5 rounded-full bg-live shadow-[0_0_8px_var(--color-live)] inline-block" />
                {msg}
              </span>
            ))}
          </div>
        </div>

        {/* Content Area */}
        {children}
      </main>
      </div>
    </div>
  );
}
