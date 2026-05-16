'use client';

import { useEffect, useState } from 'react';
import { collection, getDocs, doc, setDoc, deleteDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import DataTable from '@/components/ui/DataTable';
import OrderEditModal from './OrderEditModal';

export default function OrdersPage() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState(null);

  const fetchOrders = async () => {
    setLoading(true);
    try {
      const snap = await getDocs(collection(db, 'orders'));
      setOrders(snap.docs.map(doc => ({ id: doc.id, ...doc.data() })));
    } catch (error) {
      console.error("Error fetching orders", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders();
  }, []);

  const handleEdit = (row) => {
    setSelectedOrder(row);
    setIsModalOpen(true);
  };

  const handleDelete = async (row) => {
    if (window.confirm(`Delete order ${row.id}?`)) {
      await deleteDoc(doc(db, 'orders', row.id));
      setOrders(prev => prev.filter(o => o.id !== row.id));
    }
  };

  const handleSave = async (updatedOrder) => {
    try {
      await setDoc(doc(db, 'orders', updatedOrder.id), updatedOrder, { merge: true });
      setIsModalOpen(false);
      fetchOrders();
    } catch (error) {
      console.error("Error updating order", error);
      alert("Failed to update order.");
    }
  };

  const columns = [
    { header: 'Order ID', accessor: 'id' },
    { header: 'Customer', accessor: 'customerName', render: (r) => r.customerName || 'Unknown' },
    { 
      header: 'Status', 
      accessor: 'status',
      render: (r) => (
        <span style={{
          padding: '4px 8px',
          borderRadius: '4px',
          fontSize: '0.85rem',
          fontWeight: 'bold',
          backgroundColor: r.status === 'Delivered' ? '#dcfce7' : r.status === 'Cancelled' ? '#fee2e2' : '#fef9c3',
          color: r.status === 'Delivered' ? '#166534' : r.status === 'Cancelled' ? '#991b1b' : '#854d0e',
        }}>
          {r.status || 'Pending'}
        </span>
      )
    },
    { header: 'Total', accessor: 'totalAmount', render: (r) => `$${(r.totalAmount || r.total || 0).toFixed(2)}` },
    { header: 'Date', accessor: 'createdAt', render: (r) => r.createdAt ? new Date(r.createdAt.seconds * 1000).toLocaleDateString() : 'N/A' },
  ];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
      <h1 style={{ fontSize: '2rem', color: 'var(--color-olive)', fontWeight: '800', marginBottom: '1.5rem' }}>Orders</h1>
      
      {loading ? <div>Loading...</div> : (
        <DataTable 
          columns={columns} 
          data={orders} 
          onEdit={handleEdit}
          onDelete={handleDelete}
        />
      )}

      <OrderEditModal 
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        initialData={selectedOrder}
        onSave={handleSave}
      />
    </div>
  );
}
