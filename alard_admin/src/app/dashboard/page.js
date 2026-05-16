'use client';

import { useEffect, useState } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { Package, ShoppingCart, Users, Star } from 'lucide-react';

export default function Dashboard() {
  const [stats, setStats] = useState({
    products: 0,
    orders: 0,
    users: 0,
    feedback: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchStats() {
      try {
        const [productsSnap, ordersSnap, usersSnap, feedbackSnap] = await Promise.all([
          getDocs(collection(db, 'products')),
          getDocs(collection(db, 'orders')),
          getDocs(collection(db, 'users')),
          getDocs(collection(db, 'content/feedback/items')),
        ]);

        setStats({
          products: productsSnap.size,
          orders: ordersSnap.size,
          users: usersSnap.size,
          feedback: feedbackSnap.size,
        });
      } catch (error) {
        console.error("Error fetching stats", error);
      } finally {
        setLoading(false);
      }
    }
    fetchStats();
  }, []);

  const statCards = [
    { title: 'Total Products', value: stats.products, icon: Package, color: 'var(--color-olive)' },
    { title: 'Total Orders', value: stats.orders, icon: ShoppingCart, color: '#C0A062' },
    { title: 'Registered Users', value: stats.users, icon: Users, color: '#0E1A39' },
    { title: 'Customer Feedback', value: stats.feedback, icon: Star, color: '#D35400' },
  ];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
      <h1 style={{ fontSize: '2rem', color: 'var(--color-olive)', marginBottom: '0.5rem', fontWeight: '800' }}>
        Dashboard Overview
      </h1>
      <p style={{ color: 'var(--color-text-muted)', marginBottom: '2rem' }}>
        Welcome to the AL'ARD Admin Panel. Here's what's happening today.
      </p>

      {loading ? (
        <div style={{ padding: '2rem', textAlign: 'center', color: 'var(--color-olive)' }}>Loading metrics...</div>
      ) : (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '1.5rem' }}>
          {statCards.map((stat, i) => (
            <div key={i} className="card glass-panel" style={{ display: 'flex', alignItems: 'center', gap: '1.5rem' }}>
              <div style={{ 
                backgroundColor: stat.color + '15', 
                padding: '1rem', 
                borderRadius: 'var(--radius-md)',
                color: stat.color 
              }}>
                <stat.icon size={32} />
              </div>
              <div>
                <p style={{ color: 'var(--color-text-muted)', fontSize: '0.9rem', fontWeight: '600', marginBottom: '0.25rem' }}>
                  {stat.title}
                </p>
                <h3 style={{ fontSize: '2rem', color: 'var(--color-text-main)', fontWeight: '800' }}>
                  {stat.value}
                </h3>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
