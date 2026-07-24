import "./globals.css";

export const metadata = {
  title: "NETS Logistics | Agent Dashboard",
  description: "Command center for internal ops agents",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
        <style dangerouslySetInnerHTML={{ __html: `
          :root {
            --font-inter: 'Inter', sans-serif;
            --font-space-grotesk: 'Inter', sans-serif;
            --font-big-shoulders: 'Inter', sans-serif;
          }
        `}} />
      </head>
      <body className="bg-ink text-text-0 min-h-screen flex flex-col font-sans" suppressHydrationWarning>
        {children}
      </body>
    </html>
  );
}
