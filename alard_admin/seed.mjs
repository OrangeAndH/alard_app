import fs from 'fs';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, deleteDoc, doc, setDoc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyCoDtI6GxYINWvKR8t_BxbngGA4yL7NRFM",
  appId: "1:186705679131:web:7496fc6a68f3a7ceff79be",
  projectId: "alard-56d33",
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function seed() {
  console.log("Reading products.json...");
  const rawData = fs.readFileSync('../assets/data/products.json');
  const products = JSON.parse(rawData);

  console.log(`Found ${products.length} products. Clearing existing products...`);
  const snap = await getDocs(collection(db, 'products'));
  const batchDelete = snap.docs.map(d => deleteDoc(doc(db, 'products', d.id)));
  await Promise.all(batchDelete);
  console.log("Cleared existing products.");

  console.log("Seeding products to Firestore...");
  let count = 0;
  for (const product of products) {
    // We set doc ID explicitly
    await setDoc(doc(db, 'products', product.id), product);
    count++;
  }
  
  console.log(`Successfully seeded ${count} products!`);
  process.exit(0);
}

seed().catch(console.error);
