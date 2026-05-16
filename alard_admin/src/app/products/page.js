'use client';

import { useEffect, useState } from 'react';
import { collection, getDocs, deleteDoc, doc, setDoc, addDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import DataTable from '@/components/ui/DataTable';
import { Plus } from 'lucide-react';
import ProductFormModal from './ProductFormModal';

export default function ProductsPage() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState(null);

  const fetchProducts = async () => {
    setLoading(true);
    try {
      const snap = await getDocs(collection(db, 'products'));
      const data = snap.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      setProducts(data);
    } catch (error) {
      console.error("Error fetching products", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  const handleDelete = async (row) => {
    if (window.confirm(`Are you sure you want to delete ${row.name?.en || 'this product'}?`)) {
      try {
        await deleteDoc(doc(db, 'products', row.id));
        setProducts(prev => prev.filter(p => p.id !== row.id));
      } catch (error) {
        console.error("Error deleting product", error);
      }
    }
  };

  const handleEdit = (row) => {
    setSelectedProduct(row);
    setIsModalOpen(true);
  };

  const handleAdd = () => {
    setSelectedProduct(null);
    setIsModalOpen(true);
  };

  const handleSaveProduct = async (formData) => {
    try {
      if (selectedProduct) {
        // Update existing
        await setDoc(doc(db, 'products', selectedProduct.id), formData, { merge: true });
      } else {
        // Create new
        await addDoc(collection(db, 'products'), formData);
      }
      setIsModalOpen(false);
      fetchProducts(); // Refresh the list
    } catch (error) {
      console.error("Error saving product", error);
      alert("Failed to save product.");
    }
  };

  const columns = [
    { 
      header: 'Image', 
      accessor: 'image',
      render: (row) => (
        <div style={{ width: '40px', height: '40px', borderRadius: '8px', overflow: 'hidden', backgroundColor: 'var(--color-olive-light)' }}>
          {row.image ? <img src={row.image} alt="Product" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /> : null}
        </div>
      )
    },
    { 
      header: 'Name', 
      accessor: 'name',
      render: (row) => row.name || 'N/A'
    },
    { 
      header: 'Category', 
      accessor: 'category' 
    },
    { 
      header: 'Price (USD)', 
      accessor: 'price',
      render: (row) => `$${(row.price || 0).toFixed(2)}`
    },
    {
      header: 'Sizes',
      accessor: 'sizes',
      render: (row) => row.sizes ? `${row.sizes.length} variants` : 'None'
    }
  ];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <div>
          <h1 style={{ fontSize: '2rem', color: 'var(--color-olive)', fontWeight: '800' }}>Products</h1>
          <p style={{ color: 'var(--color-text-muted)' }}>Manage your catalog items and variants.</p>
        </div>
        <button onClick={handleAdd} className="btn-primary" style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Plus size={18} />
          Add Product
        </button>
      </div>

      {loading ? (
        <div style={{ textAlign: 'center', padding: '3rem', color: 'var(--color-olive)' }}>Loading products...</div>
      ) : (
        <DataTable 
          columns={columns} 
          data={products} 
          onEdit={handleEdit}
          onDelete={handleDelete}
        />
      )}

      <ProductFormModal 
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        initialData={selectedProduct}
        onSave={handleSaveProduct}
      />
    </div>
  );
}
