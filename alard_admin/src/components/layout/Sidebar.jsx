'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { LayoutDashboard, Package, ShoppingCart, FileText, Users, LogOut } from 'lucide-react';
import { auth } from '@/lib/firebase';
import { signOut } from 'firebase/auth';

const navItems = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Products', href: '/products', icon: Package },
  { name: 'Orders', href: '/orders', icon: ShoppingCart },
  { name: 'Content', href: '/content', icon: FileText },
  { name: 'Users', href: '/users', icon: Users },
];

export default function Sidebar() {
  const pathname = usePathname();

  const handleLogout = async () => {
    await signOut(auth);
  };

  return (
    <aside style={styles.sidebar} className="glass-panel">
      <div style={styles.logoContainer}>
        <h2 style={styles.logoText}>AL'ARD Admin</h2>
      </div>

      <nav style={styles.nav}>
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = pathname.startsWith(item.href);
          
          return (
            <Link key={item.name} href={item.href} style={{
              ...styles.navItem,
              ...(isActive ? styles.navItemActive : {})
            }}>
              <Icon size={20} color={isActive ? 'white' : 'var(--color-olive)'} />
              <span style={{ 
                ...styles.navText,
                color: isActive ? 'white' : 'var(--color-text-main)'
              }}>
                {item.name}
              </span>
            </Link>
          );
        })}
      </nav>

      <div style={styles.footer}>
        <button onClick={handleLogout} style={styles.logoutBtn}>
          <LogOut size={20} />
          <span>Logout</span>
        </button>
      </div>
    </aside>
  );
}

const styles = {
  sidebar: {
    width: '260px',
    height: '100vh',
    position: 'fixed',
    left: 0,
    top: 0,
    display: 'flex',
    flexDirection: 'column',
    borderRight: '1px solid rgba(0,0,0,0.05)',
    zIndex: 100,
  },
  logoContainer: {
    padding: '2rem 1.5rem',
    borderBottom: '1px solid rgba(0,0,0,0.05)',
  },
  logoText: {
    color: 'var(--color-olive)',
    fontSize: '1.5rem',
    fontWeight: '800',
  },
  nav: {
    padding: '1.5rem 1rem',
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    gap: '0.5rem',
  },
  navItem: {
    display: 'flex',
    alignItems: 'center',
    padding: '0.8rem 1rem',
    borderRadius: 'var(--radius-sm)',
    transition: 'all 0.2s',
  },
  navItemActive: {
    backgroundColor: 'var(--color-olive)',
    boxShadow: '0 4px 12px rgba(85, 104, 42, 0.2)',
  },
  navText: {
    marginLeft: '12px',
    fontWeight: '600',
    fontSize: '0.95rem',
  },
  footer: {
    padding: '1.5rem 1rem',
    borderTop: '1px solid rgba(0,0,0,0.05)',
  },
  logoutBtn: {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    width: '100%',
    padding: '0.8rem 1rem',
    backgroundColor: 'transparent',
    border: 'none',
    color: '#d32f2f',
    fontWeight: '600',
    cursor: 'pointer',
    borderRadius: 'var(--radius-sm)',
    transition: 'background-color 0.2s',
  }
};
