import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, getDocs, deleteDoc, doc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyCoDtI6GxYINWvKR8t_BxbngGA4yL7NRFM",
  appId: "1:186705679131:web:7496fc6a68f3a7ceff79be",
  projectId: "alard-56d33",
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

const mockFeedback = [
  {
    name: "Klaus M.",
    flag: "🇩🇪",
    stars: 5,
    country: { en: "Germany", ar: "ألمانيا" },
    text: { 
      en: "The olive oil is absolutely fantastic. Very authentic taste!", 
      ar: "زيت الزيتون رائع جداً. طعم أصيل!" 
    }
  },
  {
    name: "Sarah J.",
    flag: "🇺🇸",
    stars: 5,
    country: { en: "USA", ar: "الولايات المتحدة" },
    text: { 
      en: "I love the Za'atar blend. Brings back so many memories of home.", 
      ar: "أحب خلطة الزعتر. تعيد لي الكثير من ذكريات الوطن." 
    }
  },
  {
    name: "Omar K.",
    flag: "🇦🇪",
    stars: 4,
    country: { en: "UAE", ar: "الإمارات" },
    text: { 
      en: "Great packaging and fast shipping to Dubai. Highly recommended.", 
      ar: "تغليف ممتاز وشحن سريع إلى دبي. أنصح به بشدة." 
    }
  }
];

async function seed() {
  console.log("Clearing existing feedback...");
  const snap = await getDocs(collection(db, 'content/feedback/items'));
  const batchDelete = snap.docs.map(d => deleteDoc(doc(db, 'content/feedback/items', d.id)));
  await Promise.all(batchDelete);

  console.log("Seeding feedback...");
  let count = 0;
  for (const item of mockFeedback) {
    await addDoc(collection(db, 'content/feedback/items'), item);
    count++;
  }
  
  console.log(`Successfully seeded ${count} feedback items!`);
  process.exit(0);
}

seed().catch(console.error);
