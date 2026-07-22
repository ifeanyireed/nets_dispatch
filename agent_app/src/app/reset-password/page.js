"use client";
import Image from "next/image";
import Link from "next/link";
import { useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";

function ResetPasswordForm() {
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams.get("token");

  const handleReset = async (e) => {
    e.preventDefault();
    setError("");
    setMessage("");

    if (!token) {
      setError("No reset token provided in the URL.");
      return;
    }

    if (newPassword !== confirmPassword) {
      setError("Passwords do not match.");
      return;
    }

    setLoading(true);

    try {
      const res = await fetch("http://localhost:8080/auth/reset-password", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ token, newPassword }),
      });
      
      const data = await res.json();
      
      if (!res.ok) {
        throw new Error(data.message || "Failed to reset password");
      }
      
      setMessage("Password successfully reset. You can now login.");
      setTimeout(() => {
        router.push("/login");
      }, 2000);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <form className="flex flex-col mt-10" onSubmit={handleReset}>
      {error && <div className="text-red-500 mb-4 text-sm font-semibold">{error}</div>}
      {message && <div className="text-green-500 mb-4 text-sm font-semibold">{message}</div>}
      
      <label className="text-[12px] font-bold text-[#a5a1a1] mb-2 block">
        New Password
      </label>
      <div className="bg-[#282525] rounded-full border border-white/5 flex items-center mb-5 px-4 py-3.5 relative">
        <svg className="w-5 h-5 text-[#a5a1a1] mr-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
        <input 
          type="password" 
          value={newPassword}
          onChange={(e) => setNewPassword(e.target.value)}
          className="bg-transparent border-none text-white placeholder-[#706B6B] text-[14px] w-full focus:outline-none focus:ring-0 pr-10" 
          placeholder="New password" 
        />
      </div>

      <label className="text-[12px] font-bold text-[#a5a1a1] mb-2 block">
        Confirm Password
      </label>
      <div className="bg-[#282525] rounded-full border border-white/5 flex items-center mb-3 px-4 py-3.5 relative">
        <svg className="w-5 h-5 text-[#a5a1a1] mr-3 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
        <input 
          type="password" 
          value={confirmPassword}
          onChange={(e) => setConfirmPassword(e.target.value)}
          className="bg-transparent border-none text-white placeholder-[#706B6B] text-[14px] w-full focus:outline-none focus:ring-0 pr-10" 
          placeholder="Confirm password" 
        />
      </div>

      <div className="flex items-center justify-start mb-6 mt-2">
        <p className="text-[12px] font-medium text-[#a5a1a1]">
          <Link href="/login" className="text-white hover:text-hazard transition-colors font-bold uppercase tracking-[0.5px] text-[11px]">Back to Log in</Link>
        </p>
      </div>

      <div className="flex-1" />

      <button type="submit" disabled={loading} className="w-full h-14 bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] rounded-full shadow-[0_8px_16px_rgba(255,42,42,0.3)] flex items-center justify-center transition-opacity hover:opacity-90 mt-4 mb-6 disabled:opacity-50">
        <span className="text-white font-extrabold text-[15px] tracking-[1.5px] uppercase">
          {loading ? "Resetting..." : "Reset Password"}
        </span>
      </button>
    </form>
  );
}

export default function ResetPassword() {
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
            <span className="text-[48px] font-semibold text-white tracking-[-1.0px] leading-none">Reset</span>
            <span className="text-[48px] font-semibold text-hazard tracking-[-1.0px] leading-none">Password</span>
          </div>
          
          <p className="mt-2 text-[12px] font-extrabold text-[#a5a1a1] tracking-[1.5px]">CREATE NEW PASSWORD</p>
        </div>

        <div className="flex-[0.5]" />

        <Suspense fallback={<div className="text-white mt-10">Loading...</div>}>
          <ResetPasswordForm />
        </Suspense>
      </div>
    </main>
  );
}
