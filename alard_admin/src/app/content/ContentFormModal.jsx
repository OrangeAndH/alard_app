'use client';

import { useState, useEffect } from 'react';
import Modal from '@/components/ui/Modal';

export default function ContentFormModal({ isOpen, onClose, onSave, initialData }) {
  const [formData, setFormData] = useState({
    name: '',
    flag: '',
    stars: 5,
    country: { en: '', ar: '' },
    text: { en: '', ar: '' },
  });

  useEffect(() => {
    if (initialData) {
      setFormData({
        ...initialData,
        country: initialData.country || { en: '', ar: '' },
        text: initialData.text || { en: '', ar: '' },
      });
    } else {
      setFormData({
        name: '',
        flag: '',
        stars: 5,
        country: { en: '', ar: '' },
        text: { en: '', ar: '' },
      });
    }
  }, [initialData, isOpen]);

  const handleChange = (field, val, lang = null) => {
    if (lang) {
      setFormData(prev => ({ ...prev, [field]: { ...prev[field], [lang]: val } }));
    } else {
      setFormData(prev => ({ ...prev, [field]: val }));
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(formData);
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={initialData ? "Edit Feedback" : "Add Feedback"}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
        
        <div style={styles.row}>
          <div style={styles.group}>
            <label style={styles.label}>Customer Name</label>
            <input required className="input-field" value={formData.name} onChange={e => handleChange('name', e.target.value)} />
          </div>
          <div style={styles.group}>
            <label style={styles.label}>Emoji Flag</label>
            <input required className="input-field" placeholder="e.g. 🇵🇸" value={formData.flag} onChange={e => handleChange('flag', e.target.value)} />
          </div>
          <div style={styles.group}>
            <label style={styles.label}>Rating (1-5)</label>
            <input type="number" min="1" max="5" required className="input-field" value={formData.stars} onChange={e => handleChange('stars', parseInt(e.target.value))} />
          </div>
        </div>

        <div style={styles.row}>
          <div style={styles.group}>
            <label style={styles.label}>Country (English)</label>
            <input required className="input-field" value={formData.country.en} onChange={e => handleChange('country', e.target.value, 'en')} />
          </div>
          <div style={styles.group}>
            <label style={styles.label}>Country (Arabic)</label>
            <input required className="input-field" value={formData.country.ar} onChange={e => handleChange('country', e.target.value, 'ar')} dir="rtl" />
          </div>
        </div>

        <div style={styles.group}>
          <label style={styles.label}>Feedback (English)</label>
          <textarea required className="input-field" rows={3} value={formData.text.en} onChange={e => handleChange('text', e.target.value, 'en')} />
        </div>
        <div style={styles.group}>
          <label style={styles.label}>Feedback (Arabic)</label>
          <textarea required className="input-field" rows={3} value={formData.text.ar} onChange={e => handleChange('text', e.target.value, 'ar')} dir="rtl" />
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '1rem', marginTop: '1rem' }}>
          <button type="button" onClick={onClose} className="btn-outline">Cancel</button>
          <button type="submit" className="btn-primary">Save Feedback</button>
        </div>
      </form>
    </Modal>
  );
}

const styles = {
  row: { display: 'flex', gap: '1rem' },
  group: { flex: 1, display: 'flex', flexDirection: 'column', gap: '0.5rem' },
  label: { fontSize: '0.9rem', fontWeight: '600', color: 'var(--color-text-main)' },
};
