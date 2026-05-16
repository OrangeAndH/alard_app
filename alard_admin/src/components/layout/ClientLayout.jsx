'use client';

import { usePathname, useRouter } from 'next/navigation';
import { useEffect } from 'react';
import Sidebar from './Sidebar';
import { useAuth } from '@/lib/AuthContext';

export default function ClientLayout({ children }) {
  const { user, isAdmin, loading } = useAuth();
  const pathname = usePathname();
  const router = useRouter();

  const isLoginPage = pathname === '/login';

  useEffect(() => {
    // Authentication is disabled per user request.
    // If we land on the login page, redirect to dashboard.
    if (isLoginPage) {
      router.push('/dashboard');
    }
  }, [isLoginPage, router]);

  if (loading) {
    return (
      <div style={{ display: 'flex', height: '100vh', alignItems: 'center', justifyContent: 'center' }}>
        <p style={{ color: 'var(--color-olive)', fontWeight: 'bold' }}>Loading Alard Admin...</p>
      </div>
    );
  }

  // Authentication is bypassed, rendering children directly.
  if (isLoginPage) {
    return <main>{children}</main>;
  }

  return (
    <div style={{ display: 'flex', minHeight: '100vh' }}>
      <Sidebar />
      <main style={{ flex: 1, marginLeft: '260px', padding: '2rem' }}>
        {children}
      </main>
    </div>
  );
}
