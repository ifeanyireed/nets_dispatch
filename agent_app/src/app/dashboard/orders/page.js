import { IconSearch, IconFilter, IconPlus } from "@tabler/icons-react";

export default function Orders() {
  const orders = [
    { id: "NLG-88231", vendor: "Chicken Republic", rider: "Ade O.", status: "In transit", amount: "₦2,400", statusColor: "text-live bg-live/10 border border-live/20" },
    { id: "NLG-88230", vendor: "Fola Foods", rider: "Uche K.", status: "Delivered", amount: "₦1,850", statusColor: "text-text-1 bg-text-2/10 border border-hairline-2" },
    { id: "NLG-88229", vendor: "MedPlus Pharmacy", rider: "Unassigned", status: "Pending", amount: "₦3,100", statusColor: "text-hazard bg-hazard/10 border border-hazard/20" },
    { id: "NLG-88227", vendor: "ShopRite Lekki", rider: "Bello I.", status: "Failed", amount: "₦2,000", statusColor: "text-alert bg-alert/10 border border-alert/20" },
  ];

  return (
    <div className="flex-1 flex flex-col min-w-0">
      <div className="p-6 md:p-8 flex-1 flex flex-col">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8">
          <div>
            <div className="flex items-center gap-3 mb-2">
              <span className="font-mono text-xs tracking-[0.15em] text-hazard uppercase">Orders Management</span>
              <span className="font-mono text-[10px] text-text-2 bg-panel-2 px-2 py-0.5 rounded-full border border-hairline">Live</span>
            </div>
            <h1 className="font-display font-extrabold uppercase text-4xl leading-none tracking-wide text-text-0">Orders Overview</h1>
          </div>
          
          <div className="flex items-center gap-3">
            <button className="flex items-center gap-2 font-sans font-semibold text-xs text-text-0 bg-panel border border-hairline hover:bg-panel-2 hover:border-hairline-2 transition-all px-4 py-2.5 rounded-full">
              <IconFilter size={16} className="text-text-2" />
              <span>Filter</span>
            </button>
            <button className="text-xs text-white bg-gradient-to-r from-[#7a0000] via-[#ff2a2a] to-[#7a0000] shadow-[0_4px_15px_rgba(255,42,42,0.2)] border-none flex items-center gap-2 font-sans font-semibold hover:brightness-110 transition-all px-4 py-2.5 rounded-full">
              <IconPlus size={16} />
              <span>Manual Order</span>
            </button>
          </div>
        </div>

        {/* Search Bar */}
        <div className="flex items-center gap-3 bg-panel border border-hairline rounded-full px-4 py-3 mb-6 focus-within:border-hazard transition-colors">
          <IconSearch size={18} className="text-text-2" />
          <input 
            type="text" 
            placeholder="Search by Order ID, Vendor, or Rider name..." 
            className="bg-transparent border-none outline-none text-text-0 text-sm font-sans w-full"
          />
        </div>

        {/* Data Table */}
        <div className="bg-panel border border-hairline rounded-2xl overflow-hidden flex-1">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-panel-2 border-b border-hairline">
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Order ID</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Vendor</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Rider</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal">Status</th>
                  <th className="px-6 py-4 font-mono text-[10px] uppercase tracking-widest text-text-2 font-normal text-right">Amount</th>
                </tr>
              </thead>
              <tbody className="font-sans text-sm divide-y divide-hairline">
                {orders.map((order) => (
                  <tr key={order.id} className="hover:bg-panel-2/50 transition-colors cursor-pointer group">
                    <td className="px-6 py-4">
                      <span className="font-mono text-xs font-semibold text-text-0 group-hover:text-hazard transition-colors">{order.id}</span>
                    </td>
                    <td className="px-6 py-4 text-text-1">{order.vendor}</td>
                    <td className="px-6 py-4 text-text-1">{order.rider}</td>
                    <td className="px-6 py-4">
                      <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${order.statusColor}`}>
                        {order.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right font-mono font-semibold text-text-0">{order.amount}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          
          <div className="p-4 border-t border-hairline flex items-center justify-between text-xs font-mono text-text-2">
            <span>Showing 4 of 482 orders today</span>
            <div className="flex gap-2">
              <button className="px-3 py-1 rounded-full border border-hairline hover:text-text-0 transition-colors">Prev</button>
              <button className="px-3 py-1 rounded-full border border-hairline hover:text-text-0 transition-colors">Next</button>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
