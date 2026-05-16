'use client';

import { useState, useEffect } from 'react';
import Modal from '@/components/ui/Modal';

export default function OrderEditModal({ isOpen, onClose, onSave, initialData }) {
  const [formData, setFormData] = useState({
    status: 'Pending',
    customerName: '',
    phone: '',
    deliveryAddress: '',
    mailboxAddress: '',
    note: ''
  });

  useEffect(() => {
    if (initialData) {
      setFormData({
        status: initialData.status || 'Pending',
        customerName: initialData.customerName || '',
        phone: initialData.phone || '',
        deliveryAddress: initialData.deliveryAddress || '',
        mailboxAddress: initialData.mailboxAddress || '',
        note: initialData.note || ''
      });
    }
  }, [initialData, isOpen]);

  const handleChange = (field, value) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave({ ...initialData, ...formData });
  };

  if (!initialData) return null;

  const items = initialData.items || [];
  const total = initialData.totalAmount || initialData.total || 0;
  const subtotal = initialData.subtotal || 0;
  const delivery = initialData.delivery || 0;
  const date = initialData.createdAt 
    ? new Date(initialData.createdAt.seconds * 1000).toLocaleString() 
    : 'Unknown Date';

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={`Order #${initialData.id}`}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem', maxHeight: '75vh', overflowY: 'auto', paddingRight: '10px' }}>
        
        {/* ORDER SUMMARY BANNER */}
        <div style={{ backgroundColor: 'var(--color-olive-light)', padding: '1.25rem', borderRadius: 'var(--radius-sm)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <p style={{ margin: '0 0 0.5rem 0', fontWeight: 'bold', fontSize: '1.1rem' }}>Total: ${total.toFixed(2)}</p>
            <p style={{ margin: '0 0 0.2rem 0', fontSize: '0.9rem', color: 'var(--color-olive)' }}>Date: {date}</p>
            <p style={{ margin: '0', fontSize: '0.9rem', color: 'var(--color-olive)' }}>Payment: {initialData.paymentMethod || 'Credit Card'}</p>
          </div>
          <div style={{ textAlign: 'right' }}>
            <p style={{ margin: '0 0 0.2rem 0', fontSize: '0.85rem' }}>Subtotal: ${subtotal.toFixed(2)}</p>
            <p style={{ margin: 0, fontSize: '0.85rem' }}>Delivery: ${delivery.toFixed(2)}</p>
          </div>
        </div>

        {/* ORDER ITEMS */}
        <div>
          <h3 style={{ fontSize: '1.1rem', color: 'var(--color-text-main)', marginBottom: '0.75rem', borderBottom: '1px solid #eee', paddingBottom: '0.5rem' }}>Ordered Items ({items.length})</h3>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
            {items.map((item, idx) => (
              <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '1rem', backgroundColor: '#f9f9f9', padding: '0.75rem', borderRadius: '8px' }}>
                <div style={{ width: '45px', height: '45px', borderRadius: '8px', overflow: 'hidden', backgroundColor: 'var(--color-olive-light)' }}>
                  {item.image ? <img src={item.image} alt={item.productName} style={{ width: '100%', height: '100%', objectFit: 'cover' }} /> : null}
                </div>
                <div style={{ flex: 1 }}>
                  <p style={{ margin: '0 0 0.2rem 0', fontWeight: '600', fontSize: '0.95rem' }}>{item.productName}</p>
                  {item.variantSize && <p style={{ margin: 0, fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>Variant: {item.variantSize}</p>}
                </div>
                <div style={{ textAlign: 'right' }}>
                  <p style={{ margin: '0 0 0.2rem 0', fontWeight: 'bold' }}>${(item.price * item.quantity).toFixed(2)}</p>
                  <p style={{ margin: 0, fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>{item.quantity}x @ ${item.price?.toFixed(2)}</p>
                </div>
              </div>
            ))}
            {items.length === 0 && <p style={{ color: 'var(--color-text-muted)' }}>No items found in this order.</p>}
          </div>
        </div>

        {/* FULL EDITABLE DETAILS */}
        <div>
          <h3 style={{ fontSize: '1.1rem', color: 'var(--color-text-main)', marginBottom: '0.75rem', borderBottom: '1px solid #eee', paddingBottom: '0.5rem' }}>Customer & Status</h3>
          
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            <div style={styles.group}>
              <label style={styles.label}>Order Status</label>
              <select required className="input-field" style={{ fontWeight: 'bold', borderColor: 'var(--color-olive)' }} value={formData.status} onChange={e => handleChange('status', e.target.value)}>
                <option value="Pending">Pending</option>
                <option value="Processing">Processing</option>
                <option value="Shipped">Shipped</option>
                <option value="Delivered">Delivered</option>
                <option value="Cancelled">Cancelled</option>
              </select>
            </div>

            <div style={styles.row}>
              <div style={styles.group}>
                <label style={styles.label}>Customer Name</label>
                <input required className="input-field" value={formData.customerName} onChange={e => handleChange('customerName', e.target.value)} />
              </div>
              <div style={styles.group}>
                <label style={styles.label}>Phone Number</label>
                <input required className="input-field" value={formData.phone} onChange={e => handleChange('phone', e.target.value)} />
              </div>
            </div>

            <div style={styles.group}>
              <label style={styles.label}>Delivery Address</label>
              <input required className="input-field" value={formData.deliveryAddress} onChange={e => handleChange('deliveryAddress', e.target.value)} />
            </div>

            <div style={styles.group}>
              <label style={styles.label}>Mailbox Address (Optional)</label>
              <input className="input-field" value={formData.mailboxAddress} onChange={e => handleChange('mailboxAddress', e.target.value)} />
            </div>

            <div style={styles.group}>
              <label style={styles.label}>Customer Note</label>
              <textarea className="input-field" rows={2} value={formData.note} onChange={e => handleChange('note', e.target.value)} />
            </div>
          </div>
        </div>

        {/* SUBMIT */}
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '1rem', marginTop: '1rem', borderTop: '1px solid #eee', paddingTop: '1rem' }}>
          <button type="button" onClick={onClose} className="btn-outline">Cancel</button>
          <button type="submit" className="btn-primary">Save Changes</button>
        </div>
      </form>
    </Modal>
  );
}

const styles = {
  row: { display: 'flex', gap: '1rem' },
  group: { flex: 1, display: 'flex', flexDirection: 'column', gap: '0.4rem' },
  label: { fontSize: '0.85rem', fontWeight: '600', color: 'var(--color-text-main)' },
};
