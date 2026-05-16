'use client';

import { useState, useEffect } from 'react';
import Modal from '@/components/ui/Modal';
import ImageUploader from '@/components/ui/ImageUploader';
import { Plus, Trash2 } from 'lucide-react';

export default function RecipeFormModal({ isOpen, onClose, onSave, initialData }) {
  const emptyLocale = { en: '', ar: '' };
  
  const [formData, setFormData] = useState({
    title: { ...emptyLocale },
    image: '',
    duration: '',
    cookingItems: [],
    description: { ...emptyLocale },
    ingredients: [],
    steps: [],
  });

  useEffect(() => {
    if (initialData) {
      setFormData({
        ...initialData,
        title: initialData.title || { ...emptyLocale },
        description: initialData.description || { ...emptyLocale },
        ingredients: initialData.ingredients || [],
        steps: initialData.steps || [],
        cookingItems: initialData.cookingItems || [],
      });
    } else {
      setFormData({
        title: { ...emptyLocale },
        image: '',
        duration: '',
        cookingItems: [],
        description: { ...emptyLocale },
        ingredients: [],
        steps: [],
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

  const handleListChange = (listName, index, val, lang) => {
    const updated = [...formData[listName]];
    updated[index][lang] = val;
    setFormData(prev => ({ ...prev, [listName]: updated }));
  };

  const handleAddListItem = (listName) => {
    setFormData(prev => ({
      ...prev,
      [listName]: [...prev[listName], { en: '', ar: '' }]
    }));
  };

  const handleRemoveListItem = (listName, index) => {
    const updated = formData[listName].filter((_, i) => i !== index);
    setFormData(prev => ({ ...prev, [listName]: updated }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(formData);
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={initialData ? "Edit Recipe" : "Add Recipe"}>
      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
        
        <ImageUploader 
          currentUrl={formData.image} 
          onUploadSuccess={(url) => handleChange('image', url)} 
        />

        <div style={styles.row}>
          <div style={styles.group}>
            <label style={styles.label}>Title (English)</label>
            <input required className="input-field" value={formData.title.en} onChange={e => handleChange('title', e.target.value, 'en')} />
          </div>
          <div style={styles.group}>
            <label style={styles.label}>Title (Arabic)</label>
            <input required className="input-field" value={formData.title.ar} onChange={e => handleChange('title', e.target.value, 'ar')} dir="rtl" />
          </div>
        </div>

        <div style={styles.row}>
          <div style={styles.group}>
            <label style={styles.label}>Duration (e.g., "45 mins")</label>
            <input required className="input-field" value={formData.duration} onChange={e => handleChange('duration', e.target.value)} />
          </div>
        </div>

        <div style={styles.group}>
          <label style={styles.label}>Description (English)</label>
          <textarea required className="input-field" rows={2} value={formData.description.en} onChange={e => handleChange('description', e.target.value, 'en')} />
        </div>
        <div style={styles.group}>
          <label style={styles.label}>Description (Arabic)</label>
          <textarea required className="input-field" rows={2} value={formData.description.ar} onChange={e => handleChange('description', e.target.value, 'ar')} dir="rtl" />
        </div>

        {/* Ingredients */}
        <div style={styles.listSection}>
          <div style={styles.listHeader}>
            <label style={styles.label}>Ingredients</label>
            <button type="button" onClick={() => handleAddListItem('ingredients')} className="btn-outline" style={styles.addBtn}>
              <Plus size={16} /> Add Ingredient
            </button>
          </div>
          {formData.ingredients.map((ing, i) => (
            <div key={i} style={styles.listRow}>
              <input placeholder="English" required className="input-field" value={ing.en} onChange={e => handleListChange('ingredients', i, e.target.value, 'en')} />
              <input placeholder="Arabic" required className="input-field" value={ing.ar} onChange={e => handleListChange('ingredients', i, e.target.value, 'ar')} dir="rtl" />
              <button type="button" onClick={() => handleRemoveListItem('ingredients', i)} style={styles.removeBtn}><Trash2 size={20} color="#dc2626" /></button>
            </div>
          ))}
        </div>

        {/* Steps */}
        <div style={styles.listSection}>
          <div style={styles.listHeader}>
            <label style={styles.label}>Steps</label>
            <button type="button" onClick={() => handleAddListItem('steps')} className="btn-outline" style={styles.addBtn}>
              <Plus size={16} /> Add Step
            </button>
          </div>
          {formData.steps.map((step, i) => (
            <div key={i} style={styles.listRow}>
              <textarea placeholder="English Step" required className="input-field" rows={2} value={step.en} onChange={e => handleListChange('steps', i, e.target.value, 'en')} />
              <textarea placeholder="Arabic Step" required className="input-field" rows={2} value={step.ar} onChange={e => handleListChange('steps', i, e.target.value, 'ar')} dir="rtl" />
              <button type="button" onClick={() => handleRemoveListItem('steps', i)} style={styles.removeBtn}><Trash2 size={20} color="#dc2626" /></button>
            </div>
          ))}
        </div>

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '1rem', marginTop: '1rem' }}>
          <button type="button" onClick={onClose} className="btn-outline">Cancel</button>
          <button type="submit" className="btn-primary">Save Recipe</button>
        </div>
      </form>
    </Modal>
  );
}

const styles = {
  row: { display: 'flex', gap: '1rem' },
  group: { flex: 1, display: 'flex', flexDirection: 'column', gap: '0.5rem' },
  label: { fontSize: '0.9rem', fontWeight: '600', color: 'var(--color-text-main)' },
  listSection: { padding: '1rem', border: '1px solid #ddd', borderRadius: 'var(--radius-sm)', backgroundColor: '#fafafa' },
  listHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' },
  listRow: { display: 'grid', gridTemplateColumns: '1fr 1fr auto', gap: '0.5rem', marginBottom: '0.5rem', alignItems: 'center' },
  addBtn: { padding: '0.4rem 0.8rem', display: 'flex', alignItems: 'center', gap: '4px', fontSize: '0.85rem' },
  removeBtn: { background: 'none', border: 'none', cursor: 'pointer', padding: '8px' }
};
