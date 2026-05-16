'use client';

import { useState } from 'react';
import { ref, uploadBytes, getDownloadURL } from 'firebase/storage';
import { storage } from '@/lib/firebase';
import { UploadCloud, Loader2, Image as ImageIcon } from 'lucide-react';

export default function ImageUploader({ currentUrl, onUploadSuccess }) {
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [isHovered, setIsHovered] = useState(false);

  const handleFileChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setUploading(true);
    setProgress(0);

    const storageRef = ref(storage, `products/${Date.now()}_${file.name}`);
    
    try {
      // We use uploadBytes instead of uploadBytesResumable to avoid infinite hangs on Security Rule rejections
      const snapshot = await uploadBytes(storageRef, file);
      const downloadURL = await getDownloadURL(snapshot.ref);
      onUploadSuccess(downloadURL);
      setUploading(false);
    } catch (error) {
      console.error("Upload error: ", error);
      setUploading(false);
      alert("Upload failed. This usually means your Firebase Storage Rules require you to be logged in. Set them to 'allow read, write: if true;' for testing.");
    }
  };

  return (
    <div style={styles.container}>
      <label style={styles.label}>Product Image</label>
      <div style={styles.uploadBox}>
        {currentUrl && !uploading ? (
          <div 
            style={styles.previewContainer}
            onMouseEnter={() => setIsHovered(true)}
            onMouseLeave={() => setIsHovered(false)}
          >
            <img src={currentUrl} alt="Preview" style={styles.preview} />
            <div style={{...styles.overlay, opacity: isHovered ? 1 : 0}}>
              <label style={styles.changeBtn}>
                Change Image
                <input type="file" accept="image/*" onChange={handleFileChange} style={{ display: 'none' }} />
              </label>
            </div>
          </div>
        ) : (
          <label style={styles.emptyBox}>
            <input type="file" accept="image/*" onChange={handleFileChange} style={{ display: 'none' }} disabled={uploading} />
            {uploading ? (
              <div style={styles.loadingState}>
                <Loader2 size={24} color="var(--color-olive)" style={{ animation: 'spin 1s linear infinite' }} />
                <span>Uploading {Math.round(progress)}%</span>
              </div>
            ) : (
              <div style={styles.emptyState}>
                <UploadCloud size={32} color="var(--color-text-muted)" />
                <span style={{ marginTop: '8px', fontWeight: '500' }}>Click to upload image</span>
                <span style={{ fontSize: '0.8rem', color: '#999' }}>PNG, JPG, WEBP up to 5MB</span>
              </div>
            )}
          </label>
        )}
      </div>
      <style dangerouslySetInnerHTML={{__html: `
        @keyframes spin { 100% { transform: rotate(360deg); } }
      `}} />
    </div>
  );
}

const styles = {
  container: {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.5rem',
    marginBottom: '1rem',
  },
  label: {
    fontSize: '0.9rem',
    fontWeight: '600',
    color: 'var(--color-text-main)',
  },
  uploadBox: {
    width: '100%',
    height: '160px',
    border: '2px dashed #ddd',
    borderRadius: 'var(--radius-sm)',
    overflow: 'hidden',
    position: 'relative',
    backgroundColor: '#fafafa',
    transition: 'border-color 0.2s',
  },
  emptyBox: {
    display: 'block',
    width: '100%',
    height: '100%',
    cursor: 'pointer',
  },
  emptyState: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
    color: 'var(--color-text-muted)',
  },
  loadingState: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
    color: 'var(--color-olive)',
    gap: '8px',
  },
  previewContainer: {
    width: '100%',
    height: '100%',
    position: 'relative',
    group: 'preview',
  },
  preview: {
    width: '100%',
    height: '100%',
    objectFit: 'contain',
    backgroundColor: 'white',
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.5)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    opacity: 0,
    transition: 'opacity 0.2s',
  },
  changeBtn: {
    backgroundColor: 'white',
    color: 'var(--color-text-main)',
    padding: '0.5rem 1rem',
    borderRadius: '4px',
    fontWeight: '600',
    fontSize: '0.9rem',
    cursor: 'pointer',
  }
};
