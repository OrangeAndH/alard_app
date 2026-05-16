'use client';

import { createContext, useContext, useEffect, useState } from 'react';
import { onAuthStateChanged } from 'firebase/auth';
import { doc, getDoc } from 'firebase/firestore';
import { auth, db } from './firebase';

const AuthContext = createContext({
  user: null,
  isAdmin: false,
  loading: true,
});

export function AuthProvider({ children }) {
  // Authentication is disabled per user request. Mocking an admin user.
  const user = { uid: 'mock-admin', email: 'admin@alard.ps' };
  const isAdmin = true;
  const loading = false;

  return (
    <AuthContext.Provider value={{ user, isAdmin, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
