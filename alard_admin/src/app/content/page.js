'use client';

import { useEffect, useState } from 'react';
import { collection, getDocs, deleteDoc, doc, setDoc, addDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import DataTable from '@/components/ui/DataTable';
import { Plus } from 'lucide-react';
import ContentFormModal from './ContentFormModal';
import RecipeFormModal from './RecipeFormModal';

export default function ContentPage() {
  const [feedback, setFeedback] = useState([]);
  const [recipes, setRecipes] = useState([]);
  const [loading, setLoading] = useState(true);
  
  const [isFeedbackModalOpen, setIsFeedbackModalOpen] = useState(false);
  const [selectedFeedback, setSelectedFeedback] = useState(null);

  const [isRecipeModalOpen, setIsRecipeModalOpen] = useState(false);
  const [selectedRecipe, setSelectedRecipe] = useState(null);

  const fetchContent = async () => {
    setLoading(true);
    try {
      const [feedbackSnap, recipesSnap] = await Promise.all([
        getDocs(collection(db, 'content/feedback/items')),
        getDocs(collection(db, 'content/recipes/items'))
      ]);
      setFeedback(feedbackSnap.docs.map(doc => ({ id: doc.id, ...doc.data() })));
      setRecipes(recipesSnap.docs.map(doc => ({ id: doc.id, ...doc.data() })));
    } catch (error) {
      console.error("Error fetching content", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchContent();
  }, []);

  // --- Feedback Handlers ---
  const handleEditFeedback = (row) => {
    setSelectedFeedback(row);
    setIsFeedbackModalOpen(true);
  };

  const handleAddFeedback = () => {
    setSelectedFeedback(null);
    setIsFeedbackModalOpen(true);
  };

  const handleDeleteFeedback = async (row) => {
    if (window.confirm(`Delete feedback from ${row.name}?`)) {
      await deleteDoc(doc(db, 'content/feedback/items', row.id));
      setFeedback(prev => prev.filter(f => f.id !== row.id));
    }
  };

  const handleSaveFeedback = async (formData) => {
    try {
      if (selectedFeedback) {
        await setDoc(doc(db, 'content/feedback/items', selectedFeedback.id), formData, { merge: true });
      } else {
        await addDoc(collection(db, 'content/feedback/items'), formData);
      }
      setIsFeedbackModalOpen(false);
      fetchContent();
    } catch (error) {
      console.error("Error saving feedback", error);
      alert("Failed to save.");
    }
  };

  // --- Recipe Handlers ---
  const handleEditRecipe = (row) => {
    setSelectedRecipe(row);
    setIsRecipeModalOpen(true);
  };

  const handleAddRecipe = () => {
    setSelectedRecipe(null);
    setIsRecipeModalOpen(true);
  };

  const handleDeleteRecipe = async (row) => {
    if (window.confirm(`Delete recipe: ${row.title?.en}?`)) {
      await deleteDoc(doc(db, 'content/recipes/items', row.id));
      setRecipes(prev => prev.filter(r => r.id !== row.id));
    }
  };

  const handleSaveRecipe = async (formData) => {
    try {
      if (selectedRecipe) {
        await setDoc(doc(db, 'content/recipes/items', selectedRecipe.id), formData, { merge: true });
      } else {
        await addDoc(collection(db, 'content/recipes/items'), formData);
      }
      setIsRecipeModalOpen(false);
      fetchContent();
    } catch (error) {
      console.error("Error saving recipe", error);
      alert("Failed to save.");
    }
  };

  const feedbackColumns = [
    { header: 'Name', accessor: 'name' },
    { header: 'Country (EN)', accessor: 'country', render: (r) => r.country?.en },
    { header: 'Stars', accessor: 'stars', render: (r) => '⭐'.repeat(r.stars || 0) },
    { header: 'Feedback (EN)', accessor: 'text', render: (r) => r.text?.en },
  ];

  const recipeColumns = [
    { 
      header: 'Image', 
      accessor: 'image',
      render: (row) => (
        <div style={{ width: '40px', height: '40px', borderRadius: '8px', overflow: 'hidden', backgroundColor: 'var(--color-olive-light)' }}>
          {row.image ? <img src={row.image} alt="Recipe" style={{ width: '100%', height: '100%', objectFit: 'cover' }} /> : null}
        </div>
      )
    },
    { header: 'Title (EN)', accessor: 'title', render: (r) => r.title?.en },
    { header: 'Duration', accessor: 'duration' },
    { header: 'Steps', accessor: 'steps', render: (r) => `${r.steps?.length || 0} steps` },
  ];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
      <h1 style={{ fontSize: '2rem', color: 'var(--color-olive)', fontWeight: '800', marginBottom: '1.5rem' }}>Dynamic Content</h1>
      
      {/* RECIPES SECTION */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h2 style={{ fontSize: '1.25rem', color: 'var(--color-text-main)' }}>App Recipes</h2>
        <button onClick={handleAddRecipe} className="btn-primary" style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Plus size={18} />
          Add Recipe
        </button>
      </div>

      {loading ? <div style={{ marginBottom: '2rem' }}>Loading recipes...</div> : (
        <div style={{ marginBottom: '3rem' }}>
          <DataTable 
            columns={recipeColumns} 
            data={recipes} 
            onEdit={handleEditRecipe}
            onDelete={handleDeleteRecipe}
          />
        </div>
      )}

      <hr style={{ border: 'none', borderTop: '2px dashed rgba(0,0,0,0.05)', marginBottom: '3rem' }} />

      {/* FEEDBACK SECTION */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
        <h2 style={{ fontSize: '1.25rem', color: 'var(--color-text-main)' }}>Customer Feedback</h2>
        <button onClick={handleAddFeedback} className="btn-primary" style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Plus size={18} />
          Add Feedback
        </button>
      </div>

      {loading ? <div>Loading feedback...</div> : (
        <DataTable 
          columns={feedbackColumns} 
          data={feedback} 
          onEdit={handleEditFeedback}
          onDelete={handleDeleteFeedback}
        />
      )}

      <ContentFormModal 
        isOpen={isFeedbackModalOpen}
        onClose={() => setIsFeedbackModalOpen(false)}
        initialData={selectedFeedback}
        onSave={handleSaveFeedback}
      />

      <RecipeFormModal 
        isOpen={isRecipeModalOpen}
        onClose={() => setIsRecipeModalOpen(false)}
        initialData={selectedRecipe}
        onSave={handleSaveRecipe}
      />
    </div>
  );
}
