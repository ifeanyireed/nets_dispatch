import { IconReceipt2, IconArrowUpRight, IconArrowDownRight, IconDownload } from "@tabler/icons-react";

export default function Finance() {
  const transactions = [
    { id: "TXN-9021", type: "Order Revenue", reference: "NLG-88231", date: "Today, 10:42 AM", amount: "+₦2,400", amountColor: "text-live" },
    { id: "TXN-9020", type: "Rider Payout", reference: "Ade Ogundele", date: "Today, 09:00 AM", amount: "-₦84,200", amountColor: "text-text-0" },
    { id: "TXN-9019", type: "Order Revenue", reference: "NLG-88230", date: "Today, 08:15 AM", amount: "+₦1,850", amountColor: "text-live" },
    { id: "TXN-9018", type: "Vendor Payout", reference: "ShopRite Lekki", date: "Yesterday", amount: "-₦142,000", amountColor: "text-text-0" },
  ];

  return (
    <div className="flex-1 flex flex-col min-w-0">
      <div className="p-6 md:p-8 flex-1 flex flex-col">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <span className="font-mono text-xs tracking-[0.15em] text-hazard uppercase">Finance & Accounting</span>
            </div>
            <h1 className="font-display font-extrabold uppercase text-4xl leading-none tracking-wide text-text-0">Financial Ledger</h1>
          </div>
          
          <div className="flex items-center gap-3">
            <button className="flex items-center gap-2 font-sans font-semibold text-xs text-text-0 bg-panel border border-hairline hover:bg-panel-2 hover:border-hairline-2 transition-all px-4 py-2.5 rounded-full">
              <IconDownload size={16} className="text-text-2" />
              <span>Export CSV</span>
            </button>
            <button className="text-xs text-white bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] shadow-[0_4px_15px_rgba(255,42,42,0.2)] border-none flex items-center gap-2 font-sans font-semibold hover:brightness-110 transition-all px-4 py-2.5 rounded-full">
              <span>Run Payouts</span>
            </button>
          </div>
        </div>

        {/* Finance Stats Row */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <div className="bg-panel border border-hairline rounded-2xl p-5 relative overflow-hidden group">
            <IconArrowUpRight size={80} className="absolute -right-4 -top-4 opacity-5 text-live" />
            <h3 className="font-sans text-xs text-text-2 uppercase tracking-widest mb-2">Total Revenue (Today)</h3>
            <div className="font-sans tracking-wide font-bold text-3xl text-live">₦8.2M</div>
          </div>
          <div className="bg-panel border border-hairline rounded-2xl p-5 relative overflow-hidden group">
            <IconArrowDownRight size={80} className="absolute -right-4 -top-4 opacity-5 text-hazard" />
            <h3 className="font-sans text-xs text-text-2 uppercase tracking-widest mb-2">Pending Payouts</h3>
            <div className="font-sans tracking-wide font-bold text-3xl text-hazard">₦1.4M</div>
          </div>
          <div className="bg-panel border border-hairline rounded-2xl p-5 relative overflow-hidden group">
            <IconReceipt2 size={80} className="absolute -right-4 -top-4 opacity-5 text-sky" />
            <h3 className="font-sans text-xs text-text-2 uppercase tracking-widest mb-2">Net Platform Fees</h3>
            <div className="font-sans tracking-wide font-bold text-3xl text-text-0">₦820k</div>
          </div>
        </div>

        {/* Data Table */}
        <div className="bg-panel border border-hairline rounded-2xl overflow-hidden flex-1">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-panel-2 border-b border-hairline">
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Transaction ID</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Type</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Reference</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Date</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal text-right">Amount</th>
                </tr>
              </thead>
              <tbody className="font-sans text-sm divide-y divide-hairline">
                {transactions.map((txn, idx) => (
                  <tr key={idx} className="hover:bg-panel-2/50 transition-colors cursor-pointer group">
                    <td className="px-6 py-4">
                      <span className="font-mono text-xs font-semibold text-text-0 group-hover:text-hazard transition-colors">{txn.id}</span>
                    </td>
                    <td className="px-6 py-4 text-text-1">{txn.type}</td>
                    <td className="px-6 py-4 text-text-1">{txn.reference}</td>
                    <td className="px-6 py-4 font-mono text-[10px] text-text-2">{txn.date}</td>
                    <td className={`px-6 py-4 text-right font-mono font-semibold ${txn.amountColor}`}>{txn.amount}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          
          <div className="p-4 border-t border-hairline flex items-center justify-between text-xs font-mono text-text-2">
            <span>Showing recent transactions</span>
            <button className="text-text-0 hover:underline">View All →</button>
          </div>
        </div>

      </div>
    </div>
  );
}
