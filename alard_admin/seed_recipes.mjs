import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, getDocs, deleteDoc, doc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyCoDtI6GxYINWvKR8t_BxbngGA4yL7NRFM",
  appId: "1:186705679131:web:7496fc6a68f3a7ceff79be",
  projectId: "alard-56d33",
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

const mockRecipes = [
  {
    title: { en: "Za'atar & Olive Oil Dip", ar: "تغميسة الزعتر وزيت الزيتون" },
    image: "assets/img/recipe_zaatar_dip.jpg",
    duration: "5 mins",
    cookingItems: ["zaatar-packaging", "olive-oil-glass"],
    description: { 
      en: "The classic and simple Palestinian breakfast dip, perfect with fresh bread and tea.", 
      ar: "تغميسة الإفطار الفلسطينية الكلاسيكية والبسيطة، مثالية مع الخبز الطازج والشاي." 
    },
    ingredients: [
      { en: "1/4 cup Al'Ard Za'atar", ar: "ربع كوب من زعتر الأرض" },
      { en: "1/4 cup Al'Ard Extra Virgin Olive Oil", ar: "ربع كوب من زيت زيتون الأرض البكر الممتاز" },
      { en: "Fresh warm pita bread", ar: "خبز بيتا دافئ وطازج" }
    ],
    steps: [
      { en: "Pour the Za'atar into a small, shallow bowl.", ar: "اسكب الزعتر في وعاء صغير وعميق قليلاً." },
      { en: "Slowly pour the Extra Virgin Olive Oil over the Za'atar.", ar: "اسكب زيت الزيتون ببطء فوق الزعتر." },
      { en: "Dip fresh bread into the mixture and enjoy immediately.", ar: "اغمس الخبز الطازج في الخليط واستمتع به فوراً." }
    ]
  },
  {
    title: { en: "Za'atar Roasted Chicken", ar: "دجاج مشوي بالزعتر" },
    image: "assets/img/recipe_chicken.jpg",
    duration: "60 mins",
    cookingItems: ["zaatar-packaging", "olive-oil-glass"],
    description: { 
      en: "Juicy, tender chicken marinated in Palestinian Za'atar and slow-roasted to perfection with lemon and potatoes.", 
      ar: "دجاج طري ولذيذ متبل بالزعتر الفلسطيني ومشوي ببطء حتى الكمال مع الليمون والبطاطس." 
    },
    ingredients: [
      { en: "1 whole chicken, cut into pieces", ar: "دجاجة كاملة مقطعة" },
      { en: "4 tablespoons Al'Ard Za'atar Blend", ar: "٤ ملاعق من خلطة زعتر الأرض" },
      { en: "1/3 cup Al'Ard Extra Virgin Olive Oil", ar: "ثلث كوب زيت زيتون الأرض" },
      { en: "Baby potatoes and sliced lemons", ar: "بطاطس صغيرة وشرائح ليمون" }
    ],
    steps: [
      { en: "Preheat oven to 200°C (400°F).", ar: "سخن الفرن على درجة ٢٠٠ مئوية." },
      { en: "Mix olive oil, Za'atar, and a pinch of salt to create a marinade.", ar: "اخلط زيت الزيتون والزعتر ورشة ملح لعمل تتبيلة." },
      { en: "Rub the chicken and potatoes thoroughly with the marinade.", ar: "افرك الدجاج والبطاطس جيداً بالتتبيلة." },
      { en: "Roast for 45-50 minutes until golden and cooked through.", ar: "اشوي لمدة ٤٥-٥٠ دقيقة حتى يصبح ذهبياً وناضجاً." }
    ]
  },
  {
    title: { en: "Palestinian Fattoush Salad", ar: "سلطة فتوش فلسطينية" },
    image: "assets/img/recipe_salad.jpg",
    duration: "15 mins",
    cookingItems: ["olive-oil-glass"],
    description: { 
      en: "A vibrant, refreshing, and tangy salad full of fresh vegetables and dressed in premium olive oil.", 
      ar: "سلطة نابضة بالحياة ومنعشة وحامضة مليئة بالخضروات الطازجة ومتبلة بزيت الزيتون الفاخر." 
    },
    ingredients: [
      { en: "2 cups mixed greens (lettuce, mint, parsley)", ar: "كوبين من الخضروات الورقية (خس، نعناع، بقدونس)" },
      { en: "Cherry tomatoes and cucumbers, chopped", ar: "طماطم كرزية وخيار، مقطعة" },
      { en: "1/4 cup Al'Ard Olive Oil", ar: "ربع كوب من زيت زيتون الأرض" },
      { en: "2 tablespoons fresh lemon juice", ar: "ملعقتين من عصير الليمون الطازج" }
    ],
    steps: [
      { en: "Combine all chopped vegetables in a large serving bowl.", ar: "اخلط جميع الخضروات المقطعة في وعاء تقديم كبير." },
      { en: "Whisk olive oil, lemon juice, and a pinch of salt together.", ar: "اخفق زيت الزيتون وعصير الليمون ورشة ملح معاً." },
      { en: "Pour the dressing over the salad and toss well.", ar: "اسكب التتبيلة فوق السلطة وقلبها جيداً." }
    ]
  },
  {
    title: { en: "Za'atar Fried Eggs", ar: "بيض مقلي بالزعتر" },
    image: "assets/img/recipe_eggs.jpg",
    duration: "10 mins",
    cookingItems: ["zaatar-packaging", "olive-oil-glass"],
    description: { 
      en: "A protein-packed breakfast staple featuring fried eggs beautifully infused with the flavor of Za'atar.", 
      ar: "وجبة فطور أساسية غنية بالبروتين تتكون من بيض مقلي منكه بشكل جميل بالزعتر." 
    },
    ingredients: [
      { en: "2 large free-range eggs", ar: "بيضتين كبيرتين" },
      { en: "2 tablespoons Al'Ard Extra Virgin Olive Oil", ar: "ملعقتين من زيت زيتون الأرض البكر الممتاز" },
      { en: "1 teaspoon Al'Ard Za'atar", ar: "ملعقة صغيرة من زعتر الأرض" }
    ],
    steps: [
      { en: "Heat the olive oil in a skillet over medium heat.", ar: "سخن زيت الزيتون في مقلاة على نار متوسطة." },
      { en: "Crack the eggs into the skillet and cook to your preference.", ar: "اكسر البيض في المقلاة واطبخه حسب رغبتك." },
      { en: "Sprinkle the Za'atar generously over the eggs just before serving.", ar: "رش الزعتر بسخاء فوق البيض قبل التقديم مباشرة." }
    ]
  }
];

async function seed() {
  console.log("Clearing existing recipes...");
  const snap = await getDocs(collection(db, 'content/recipes/items'));
  const batchDelete = snap.docs.map(d => deleteDoc(doc(db, 'content/recipes/items', d.id)));
  await Promise.all(batchDelete);

  console.log("Seeding 4 user-provided image recipes...");
  let count = 0;
  for (const item of mockRecipes) {
    await addDoc(collection(db, 'content/recipes/items'), item);
    count++;
  }
  
  console.log(`Successfully seeded ${count} recipes!`);
  process.exit(0);
}

seed().catch(console.error);
