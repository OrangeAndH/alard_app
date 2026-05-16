'use client';

import { useEffect, useState } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import DataTable from '@/components/ui/DataTable';

export default function UsersPage() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchUsers() {
      try {
        const snap = await getDocs(collection(db, 'users'));
        setUsers(snap.docs.map(doc => ({ id: doc.id, ...doc.data() })));
      } catch (error) {
        console.error("Error fetching users", error);
      } finally {
        setLoading(false);
      }
    }
    fetchUsers();
  }, []);

  const columns = [
    { header: 'User ID', accessor: 'id' },
    { header: 'Name', accessor: 'name' },
    { header: 'Email', accessor: 'email' },
    { header: 'Role', accessor: 'isAdmin', render: (r) => r.isAdmin ? 'Admin' : 'User' },
  ];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
      <h1 style={{ fontSize: '2rem', color: 'var(--color-olive)', fontWeight: '800', marginBottom: '1.5rem' }}>Users</h1>
      {loading ? <div>Loading...</div> : <DataTable columns={columns} data={users} />}
    </div>
  );
}
