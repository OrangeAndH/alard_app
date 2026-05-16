import { initializeApp, getApps, getApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

const firebaseConfig = {
  apiKey: "AIzaSyCoDtI6GxYINWvKR8t_BxbngGA4yL7NRFM",
  appId: "1:186705679131:web:7496fc6a68f3a7ceff79be",
  messagingSenderId: "186705679131",
  projectId: "alard-56d33",
  authDomain: "alard-56d33.firebaseapp.com",
  storageBucket: "alard-56d33.firebasestorage.app",
  measurementId: "G-FVSPT8NFVK",
};

// Initialize Firebase only once
const app = !getApps().length ? initializeApp(firebaseConfig) : getApp();
const auth = getAuth(app);
const db = getFirestore(app);
const storage = getStorage(app);

export { app, auth, db, storage };
