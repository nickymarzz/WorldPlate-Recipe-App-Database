// Seed data extracted from query_2nd.sql to simulate the database in Demo Mode
export const initialDatabaseState = {
  users: [
    { user_id: 1, username: 'chef_mario', email: 'mario@example.com' },
    { user_id: 2, username: 'baker_jane', email: 'jane@example.com' },
    { user_id: 3, username: 'spicy_sam', email: 'sam@food.com' },
    { user_id: 4, username: 'healthy_heather', email: 'heather@fit.com' },
    { user_id: 5, username: 'keto_king', email: 'king@keto.com' },
    { user_id: 6, username: 'vegan_vibe', email: 'vibe@green.com' },
    { user_id: 7, username: 'pasta_pro', email: 'pro@italy.com' },
    { user_id: 8, username: 'grill_master', email: 'master@bbq.com' },
    { user_id: 9, username: 'sweet_sarah', email: 'sarah@dessert.com' },
    { user_id: 10, username: 'quick_cook', email: 'quick@meals.com' }
  ],
  users_audit_log: [
    { audit_id: 1, user_id: 11, username: 'temp_chef', email: 'temp@kitchen.com', action_type: 'INSERT', logged_at: '2025-05-20 10:00:00' },
    { audit_id: 2, user_id: 11, username: 'temp_chef', email: 'temp@kitchen.com', action_type: 'DELETE', logged_at: '2025-05-20 10:05:00' }
  ],
  ingredients: [
    { ingredient_id: 1, name: 'Chicken Breast' },
    { ingredient_id: 2, name: 'Olive Oil' },
    { ingredient_id: 3, name: 'Salt' },
    { ingredient_id: 4, name: 'Black Pepper' },
    { ingredient_id: 5, name: 'Garlic' },
    { ingredient_id: 6, name: 'Onion' },
    { ingredient_id: 7, name: 'Tomato' },
    { ingredient_id: 8, name: 'Flour' },
    { ingredient_id: 9, name: 'Butter' },
    { ingredient_id: 10, name: 'Milk' }
  ],
  units: [
    { unit_id: 1, unit_name: 'Grams' },
    { unit_id: 2, unit_name: 'Kilograms' },
    { unit_id: 3, unit_name: 'Milliliters' },
    { unit_id: 4, unit_name: 'Liters' },
    { unit_id: 5, unit_name: 'Teaspoon' },
    { unit_id: 6, unit_name: 'Tablespoon' },
    { unit_id: 7, unit_name: 'Cup' },
    { unit_id: 8, unit_name: 'Piece' },
    { unit_id: 9, unit_name: 'Clove' },
    { unit_id: 10, unit_name: 'Pinch' }
  ],
  actions: [
    { action_id: 1, action_name: 'Chop' },
    { action_id: 2, action_name: 'Fry' },
    { action_id: 3, action_name: 'Bake' },
    { action_id: 4, action_name: 'Boil' },
    { action_id: 5, action_name: 'Grill' },
    { action_id: 6, action_name: 'Stir' },
    { action_id: 7, action_name: 'Whisk' },
    { action_id: 8, action_name: 'Mince' },
    { action_id: 9, action_name: 'Simmer' },
    { action_id: 10, action_name: 'Steam' }
  ],
  categories: [
    { category_id: 1, name: 'Breakfast' },
    { category_id: 2, name: 'Lunch' },
    { category_id: 3, name: 'Dinner' },
    { category_id: 4, name: 'Dessert' },
    { category_id: 5, name: 'Snack' },
    { category_id: 6, name: 'Vegan' },
    { category_id: 7, name: 'Gluten-Free' },
    { category_id: 8, name: 'Italian' },
    { category_id: 9, name: 'Mexican' },
    { category_id: 10, name: 'Low-Carb' }
  ],
  recipes: [
    { recipe_id: 1, user_id: 1, title: 'Classic Roasted Chicken', prep_time: 15, cook_time: 60, difficulty: 'Medium', created_at: '2025-05-10 10:00:00', total_time: 75 },
    { recipe_id: 2, user_id: 2, title: 'Simple Butter Cookies', prep_time: 20, cook_time: 12, difficulty: 'Easy', created_at: '2025-05-11 11:30:00', total_time: 32 },
    { recipe_id: 3, user_id: 3, title: 'Spicy Tomato Pasta', prep_time: 10, cook_time: 15, difficulty: 'Easy', created_at: '2025-05-12 12:45:00', total_time: 25 },
    { recipe_id: 4, user_id: 4, title: 'Garlic Steamed Veggies', prep_time: 10, cook_time: 10, difficulty: 'Easy', created_at: '2025-05-13 13:15:00', total_time: 20 },
    { recipe_id: 5, user_id: 5, title: 'Keto Grilled Steak', prep_time: 5, cook_time: 12, difficulty: 'Medium', created_at: '2025-05-14 14:00:00', total_time: 17 },
    { recipe_id: 6, user_id: 6, title: 'Vegan Onion Soup', prep_time: 15, cook_time: 40, difficulty: 'Medium', created_at: '2025-05-15 15:20:00', total_time: 55 },
    { recipe_id: 7, user_id: 7, title: 'Homemade Pizza Dough', prep_time: 30, cook_time: 0, difficulty: 'Hard', created_at: '2025-05-16 16:10:00', total_time: 30 },
    { recipe_id: 8, user_id: 8, title: 'BBQ Chicken Wings', prep_time: 10, cook_time: 25, difficulty: 'Medium', created_at: '2025-05-17 17:05:00', total_time: 35 },
    { recipe_id: 9, user_id: 9, title: 'Creamy Garlic Sauce', prep_time: 5, cook_time: 5, difficulty: 'Easy', created_at: '2025-05-18 18:30:00', total_time: 10 },
    { recipe_id: 10, user_id: 10, title: 'Quick Morning Omelet', prep_time: 5, cook_time: 5, difficulty: 'Easy', created_at: '2025-05-19 08:00:00', total_time: 10 }
  ],
  recipe_ingredients: [
    { recipe_id: 1, ingredient_id: 1, unit_id: 8, quantity: 2.00 },
    { recipe_id: 1, ingredient_id: 2, unit_id: 6, quantity: 2.00 },
    { recipe_id: 3, ingredient_id: 7, unit_id: 8, quantity: 4.00 },
    { recipe_id: 3, ingredient_id: 5, unit_id: 9, quantity: 3.00 },
    { recipe_id: 2, ingredient_id: 8, unit_id: 7, quantity: 2.50 },
    { recipe_id: 2, ingredient_id: 9, unit_id: 1, quantity: 200.00 },
    { recipe_id: 6, ingredient_id: 6, unit_id: 8, quantity: 3.00 },
    { recipe_id: 9, ingredient_id: 10, unit_id: 3, quantity: 100.00 },
    { recipe_id: 10, ingredient_id: 9, unit_id: 6, quantity: 1.00 },
    { recipe_id: 1, ingredient_id: 3, unit_id: 10, quantity: 2.00 }
  ],
  steps: [
    { recipe_id: 1, step_number: 1, action_id: 1, duration: 10 },
    { recipe_id: 1, step_number: 2, action_id: 3, duration: 50 },
    { recipe_id: 3, step_number: 1, action_id: 8, duration: 5 },
    { recipe_id: 3, step_number: 2, action_id: 2, duration: 10 },
    { recipe_id: 10, step_number: 1, action_id: 7, duration: 2 },
    { recipe_id: 10, step_number: 2, action_id: 2, duration: 3 },
    { recipe_id: 8, step_number: 1, action_id: 5, duration: 20 },
    { recipe_id: 4, step_number: 1, action_id: 10, duration: 10 },
    { recipe_id: 6, step_number: 1, action_id: 1, duration: 5 },
    { recipe_id: 6, step_number: 2, action_id: 9, duration: 35 }
  ],
  recipe_categories: [
    { recipe_id: 1, category_id: 3 },
    { recipe_id: 2, category_id: 4 },
    { recipe_id: 3, category_id: 8 },
    { recipe_id: 4, category_id: 6 },
    { recipe_id: 5, category_id: 10 },
    { recipe_id: 6, category_id: 6 },
    { recipe_id: 7, category_id: 8 },
    { recipe_id: 8, category_id: 3 },
    { recipe_id: 9, category_id: 5 },
    { recipe_id: 10, category_id: 1 }
  ],
  ratings: [
    { rating_id: 1, user_id: 2, recipe_id: 1, rating_score: 5, created_at: '2025-05-11 10:00:00' },
    { rating_id: 2, user_id: 1, recipe_id: 2, rating_score: 4, created_at: '2025-05-12 11:00:00' },
    { rating_id: 3, user_id: 3, recipe_id: 3, rating_score: 5, created_at: '2025-05-13 12:00:00' },
    { rating_id: 4, user_id: 4, recipe_id: 4, rating_score: 3, created_at: '2025-05-14 13:00:00' },
    { rating_id: 5, user_id: 5, recipe_id: 5, rating_score: 5, created_at: '2025-05-15 14:00:00' },
    { rating_id: 6, user_id: 6, recipe_id: 6, rating_score: 4, created_at: '2025-05-16 15:00:00' },
    { rating_id: 7, user_id: 7, recipe_id: 7, rating_score: 2, created_at: '2025-05-17 16:00:00' },
    { rating_id: 8, user_id: 8, recipe_id: 8, rating_score: 5, created_at: '2025-05-18 17:00:00' },
    { rating_id: 9, user_id: 9, recipe_id: 9, rating_score: 4, created_at: '2025-05-19 18:00:00' },
    { rating_id: 10, user_id: 10, recipe_id: 10, rating_score: 5, created_at: '2025-05-20 19:00:00' }
  ],
  favorites: [
    { user_id: 1, recipe_id: 3, saved_at: '2025-05-15 10:00:00' },
    { user_id: 1, recipe_id: 5, saved_at: '2025-05-16 11:00:00' },
    { user_id: 2, recipe_id: 1, saved_at: '2025-05-17 12:00:00' },
    { user_id: 3, recipe_id: 8, saved_at: '2025-05-18 13:00:00' },
    { user_id: 4, recipe_id: 6, saved_at: '2025-05-19 14:00:00' },
    { user_id: 5, recipe_id: 5, saved_at: '2025-05-20 15:00:00' },
    { user_id: 6, recipe_id: 4, saved_at: '2025-05-21 16:00:00' },
    { user_id: 7, recipe_id: 3, saved_at: '2025-05-22 17:00:00' },
    { user_id: 8, recipe_id: 1, saved_at: '2025-05-23 18:00:00' },
    { user_id: 9, recipe_id: 2, saved_at: '2025-05-24 19:00:00' }
  ],
  recipe_audit_log: [
    { log_id: 1, action: 'insert', recipe_id: 11, title: 'Test Recipe', timestamp: '2025-05-20 12:00:00' }
  ]
};

// Simple visual schema metadata showing table descriptions, columns, and relations for UI ER Diagram
export const databaseSchema = [
  {
    name: 'Users',
    description: 'Registered users on the Recipe Platform',
    columns: [
      { name: 'user_id', type: 'INT', key: 'PK' },
      { name: 'username', type: 'VARCHAR(50)', key: 'UNIQUE' },
      { name: 'email', type: 'VARCHAR(100)', key: 'UNIQUE' }
    ],
    relations: []
  },
  {
    name: 'Ingredients',
    description: 'Master list of ingredients',
    columns: [
      { name: 'ingredient_id', type: 'INT', key: 'PK' },
      { name: 'name', type: 'VARCHAR(100)', key: 'UNIQUE' }
    ],
    relations: []
  },
  {
    name: 'Units',
    description: 'Measurement units for ingredients',
    columns: [
      { name: 'unit_id', type: 'INT', key: 'PK' },
      { name: 'unit_name', type: 'VARCHAR(50)', key: 'UNIQUE' }
    ],
    relations: []
  },
  {
    name: 'Actions',
    description: 'Cooking actions for steps',
    columns: [
      { name: 'action_id', type: 'INT', key: 'PK' },
      { name: 'action_name', type: 'VARCHAR(50)', key: 'UNIQUE' }
    ],
    relations: []
  },
  {
    name: 'Categories',
    description: 'Recipe classifications and tags',
    columns: [
      { name: 'category_id', type: 'INT', key: 'PK' },
      { name: 'name', type: 'VARCHAR(100)', key: 'UNIQUE' }
    ],
    relations: []
  },
  {
    name: 'Recipes',
    description: 'Core recipe information created by users',
    columns: [
      { name: 'recipe_id', type: 'INT', key: 'PK' },
      { name: 'user_id', type: 'INT', key: 'FK -> Users.user_id' },
      { name: 'title', type: 'VARCHAR(150)', key: 'UNIQUE' },
      { name: 'prep_time', type: 'SMALLINT', key: '' },
      { name: 'cook_time', type: 'SMALLINT', key: '' },
      { name: 'total_time', type: 'SMALLINT', key: '' },
      { name: 'difficulty', type: 'CHAR(6)', key: 'CHECK' },
      { name: 'created_at', type: 'DATETIME', key: 'DEFAULT' }
    ],
    relations: [{ from: 'user_id', toTable: 'Users', toColumn: 'user_id' }]
  },
  {
    name: 'Users_Audit_Log',
    description: 'Audit log for user insertions and deletions',
    columns: [
      { name: 'audit_id', type: 'INT', key: 'PK' },
      { name: 'user_id', type: 'INT', key: '' },
      { name: 'username', type: 'VARCHAR(50)', key: '' },
      { name: 'email', type: 'VARCHAR(100)', key: '' },
      { name: 'action_type', type: 'VARCHAR(10)', key: '' },
      { name: 'logged_at', type: 'DATETIME', key: '' }
    ],
    relations: []
  },
  {
    name: 'Recipe_Ingredients',
    description: 'Ingredients used in a specific recipe',
    columns: [
      { name: 'recipe_id', type: 'INT', key: 'PK, FK -> Recipes.recipe_id' },
      { name: 'ingredient_id', type: 'INT', key: 'PK, FK -> Ingredients.ingredient_id' },
      { name: 'unit_id', type: 'INT', key: 'FK -> Units.unit_id' },
      { name: 'quantity', type: 'DECIMAL(6,2)', key: '' }
    ],
    relations: [
      { from: 'recipe_id', toTable: 'Recipes', toColumn: 'recipe_id' },
      { from: 'ingredient_id', toTable: 'Ingredients', toColumn: 'ingredient_id' },
      { from: 'unit_id', toTable: 'Units', toColumn: 'unit_id' }
    ]
  },
  {
    name: 'Steps',
    description: 'Step-by-step cooking instructions',
    columns: [
      { name: 'recipe_id', type: 'INT', key: 'PK, FK -> Recipes.recipe_id' },
      { name: 'step_number', type: 'SMALLINT', key: 'PK' },
      { name: 'action_id', type: 'INT', key: 'FK -> Actions.action_id' },
      { name: 'duration', type: 'SMALLINT', key: '' }
    ],
    relations: [
      { from: 'recipe_id', toTable: 'Recipes', toColumn: 'recipe_id' },
      { from: 'action_id', toTable: 'Actions', toColumn: 'action_id' }
    ]
  },
  {
    name: 'Recipe_Categories',
    description: 'Mapping recipes to multiple categories',
    columns: [
      { name: 'recipe_id', type: 'INT', key: 'PK, FK -> Recipes.recipe_id' },
      { name: 'category_id', type: 'INT', key: 'PK, FK -> Categories.category_id' }
    ],
    relations: [
      { from: 'recipe_id', toTable: 'Recipes', toColumn: 'recipe_id' },
      { from: 'category_id', toTable: 'Categories', toColumn: 'category_id' }
    ]
  },
  {
    name: 'Ratings',
    description: 'User ratings for recipes',
    columns: [
      { name: 'rating_id', type: 'INT', key: 'PK' },
      { name: 'user_id', type: 'INT', key: 'FK -> Users.user_id' },
      { name: 'recipe_id', type: 'INT', key: 'FK -> Recipes.recipe_id' },
      { name: 'rating_score', type: 'TINYINT', key: 'CHECK 1-5' },
      { name: 'created_at', type: 'DATETIME', key: 'DEFAULT' }
    ],
    relations: [
      { from: 'user_id', toTable: 'Users', toColumn: 'user_id' },
      { from: 'recipe_id', toTable: 'Recipes', toColumn: 'recipe_id' }
    ]
  },
  {
    name: 'Favorites',
    description: 'User saved favorite recipes',
    columns: [
      { name: 'user_id', type: 'INT', key: 'PK, FK -> Users.user_id' },
      { name: 'recipe_id', type: 'INT', key: 'PK, FK -> Recipes.recipe_id' },
      { name: 'saved_at', type: 'DATETIME', key: 'DEFAULT' }
    ],
    relations: [
      { from: 'user_id', toTable: 'Users', toColumn: 'user_id' },
      { from: 'recipe_id', toTable: 'Recipes', toColumn: 'recipe_id' }
    ]
  }
];
