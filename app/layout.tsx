import type { Metadata } from "next";
import { Layout, Navbar, Footer } from 'nextra-theme-docs'
import { getPageMap } from 'nextra/page-map'
import "./globals.css";

export const metadata: Metadata = {
  title: "Poodle Docs",
  description: "Documentation for Poodle",
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const pageMap = await getPageMap()

  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <Layout
          navbar={
            <Navbar
              logo={<strong>Poodle</strong>}
              projectLink="https://github.com/poodle-kit/poodle-docs"
            />
          }
          footer={
            <Footer>
              <p>© 2026 Poodle Documentation</p>
            </Footer>
          }
          pageMap={pageMap}
        >
          {children}
        </Layout>
      </body>
    </html>
  );
}
