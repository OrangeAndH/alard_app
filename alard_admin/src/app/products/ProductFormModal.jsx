'use client';

import { useState, useEffect } from 'react';
import Modal from '@/components/ui/Modal';
import ImageUploader from '@/components/ui/ImageUploader';
import { Plus, Trash2 } from 'lucide-react';

export default function ProductFormModal({ isOpen, onClose, onSave, initialData }) {
  const [formData, setFormData] = useState({
    name: '',
    category: '',
    price: 0,
    description: '',
    image: '',
    variants: [],
  });

  useEffect(() => {
    if (initialData) {
      setFormData({
        ...initialData,
        name: initialData.name || '',
        description: initialData.description || '',
        price: initialData.price || 0,
        variants: initialData.variants || [],
      });
    } else {
      setFormData({
        name: '',
        category: '',
        price: 0,
        description: '',
        image: '',
        variants: [],
      });
    }
  }, [initialData, isOpen]);

  const handleChange = (field, val) => {
    setFormData(prev => ({ ...prev, [field]: val }));
  };

  const handleAddVariant = () => {
    setFormData(prev => ({
      ...prev,
      variants: [...prev.variants, { id: Date.now().toString(), size: '', price: 0 }]
    }));
  };

  const handleVariantChange = (index, field, val) => {
    const updated = [...formData.variants];
    updated[index][field] = val;
    setFormData(prev => ({ ...prev, variants: updated }));
  };

  const handleRemoveVariant = (index) => {
    const updated = formData.variants.filter((_, i) => i !== index);
    setFormData(prev => ({ ...prev, variants: updated }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(formData);
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={initialData ? "Edit Product" : "Add New Product"}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
        <ImageUploader 
          currentUrl={formData.image} 
          onUploadSuccess={(url) => handleChange('image', url)} 
        />

        <div style={styles.group}>
          <label style={styles.label}>Name</label>
          <input required className="input-field" value={formData.name} onChange={e => handleChange('name', e.target.value)} />
        </div>

        <div style={styles.row}>
          <div style={styles.group}>
            <label style={styles.label}>Category</label>
            <select required className="input-field" value={formData.category} onChange={e => handleChange('category', e.target.value)}>
              <option value="">Select Category</option>
              <option value="Olive Oil">Olive Oil</option>
              <option value="Herbs & Spices">Herbs & Spices</option>
              <option value="Tahini & Halawa">Tahini & Halawa</option>
              <option value="Grains">Grains</option>
              <option value="Dairy">Dairy</option>
              <option value="Pickles">Pickles</option>
              <option value="Natural Products">Natural Products</option>
              <option value="Snacks">Snacks</option>
              <option value="Gift Boxes">Gift Boxes</option>
              <option value="Apparel">Apparel</option>
            </select>
          </div>
          <div style={styles.group}>
            <label style={styles.label}>Base Price (USD)</label>
            <input type="number" required step="0.01" className="input-field" value={formData.price} onChange={e => handleChange('price', parseFloat(e.target.value))} />
          </div>
        </div>

        <div style={styles.group}>
          <label style={styles.label}>Description</label>
          <textarea required className="input-field" rows={3} value={formData.description} onChange={e => handleChange('description', e.target.value)} />
        </div>

        <div style={styles.variantsSection}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
            <label style={styles.label}>Product Variants (Sizes/Weights)</label>
            <button type="button" onClick={handleAddVariant} className="btn-outline" style={{ padding: '0.4rem 0.8rem', display: 'flex', alignItems: 'center', gap: '4px', fontSize: '0.85rem' }}>
              <Plus size={16} /> Add Variant
            </button>
          </div>
          
          {formData.variants.length === 0 ? (
            <p style={{ color: 'var(--color-text-muted)', fontSize: '0.9rem', fontStyle: 'italic' }}>No variants added. Base price will be used.</p>
          ) : (
            formData.variants.map((variant, index) => (
              <div key={variant.id} style={styles.variantRow}>
                <input placeholder="Size" className="input-field" value={variant.size} onChange={e => handleVariantChange(index, 'size', e.target.value)} required />
                <input type="number" placeholder="Variant Price" className="input-field" value={variant.price} onChange={e => handleVariantChange(index, 'price', parseFloat(e.target.value))} required />
                <button type="button" onClick={() => handleRemoveVariant(index)} style={{ background: 'none', border: 'none', cursor: 'pointer', padding: '8px' }}>
                  <Trash2 size={20} color="#dc2626" />
                </button>
              </div>
            ))
          )}
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '1rem', marginTop: '1rem' }}>
          <button type="button" onClick={onClose} className="btn-outline">Cancel</button>
          <button type="submit" className="btn-primary">Save Product</button>
        </div>
      </form>
    </Modal>
  );
}

const styles = {
  row: { display: 'flex', gap: '1rem' },
  group: { flex: 1, display: 'flex', flexDirection: 'column', gap: '0.5rem' },
  label: { fontSize: '0.9rem', fontWeight: '600', color: 'var(--color-text-main)' },
  variantsSection: {
    padding: '1rem',
    border: '1px solid #ddd',
    borderRadius: 'var(--radius-sm)',
    backgroundColor: '#fafafa',
  },
  variantRow: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr auto',
    gap: '0.5rem',
    marginBottom: '0.5rem',
    alignItems: 'center',
  }
};
