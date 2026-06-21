// Beautifully structured queries extracted from query_2nd.sql for the Query Console and local mock executions
export const queryCategories = [
  {
    id: 'selects',
    name: 'Basic Selects & Filtering',
    icon: 'Database',
    queries: [
      {
        id: 'sel-1',
        title: 'Distinct Difficulty Levels',
        explanation: 'Retrieves all unique difficulty levels present in the Recipes table.',
        sql: "SELECT DISTINCT difficulty FROM Recipes;",
        mockResult: [
          { difficulty: 'Easy' },
          { difficulty: 'Medium' },
          { difficulty: 'Hard' }
        ]
      },
      {
        id: 'sel-2',
        title: 'Long Cook Time Recipes',
        explanation: 'Retrieves titles and difficulties for recipes taking more than 30 minutes to cook.',
        sql: "SELECT title, difficulty FROM Recipes WHERE cook_time > 30;",
        mockResult: [
          { title: 'Classic Roasted Chicken', difficulty: 'Medium' },
          { title: 'Vegan Onion Soup', difficulty: 'Medium' }
        ]
      },
      {
        id: 'sel-3',
        title: 'Recipes by Range (BETWEEN)',
        explanation: 'Uses BETWEEN operator to find recipes with a cook time in the range 20 to 60.',
        sql: "SELECT title, cook_time FROM Recipes WHERE cook_time BETWEEN 20 AND 60;",
        mockResult: [
          { title: 'Classic Roasted Chicken', cook_time: 60 },
          { title: 'Vegan Onion Soup', cook_time: 40 },
          { title: 'BBQ Chicken Wings', cook_time: 25 }
        ]
      },
      {
        id: 'sel-4',
        title: 'Pattern Matching (LIKE)',
        explanation: 'Uses the LIKE wildcards to find all recipes that have the substring "Chicken" in their title.',
        sql: "SELECT title FROM Recipes WHERE title LIKE '%Chicken%';",
        mockResult: [
          { title: 'Classic Roasted Chicken' },
          { title: 'BBQ Chicken Wings' }
        ]
      },
      {
        id: 'sel-5',
        title: 'Top 2 Quickest Prep Recipes',
        explanation: 'Retrieves the top 2 recipes with the shortest prep time.',
        sql: "SELECT TOP 2 title, prep_time FROM Recipes ORDER BY prep_time ASC;",
        mockResult: [
          { title: 'Keto Grilled Steak', prep_time: 5 },
          { title: 'Creamy Garlic Sauce', prep_time: 5 }
        ]
      }
    ]
  },
  {
    id: 'operators',
    name: 'Operators & Arithmetic',
    icon: 'Percent',
    queries: [
      {
        id: 'op-1',
        title: 'Increased Prep Time',
        explanation: 'Demonstrates basic arithmetic addition in a SELECT statement (+ 5).',
        sql: "SELECT title, prep_time, prep_time + 5 AS increased_prep FROM Recipes;",
        mockResult: [
          { title: 'Classic Roasted Chicken', prep_time: 15, increased_prep: 20 },
          { title: 'Simple Butter Cookies', prep_time: 20, increased_prep: 25 },
          { title: 'Spicy Tomato Pasta', prep_time: 10, increased_prep: 15 }
        ]
      },
      {
        id: 'op-2',
        title: 'Bulk Quantity Calculation',
        explanation: 'Multiplies ingredient quantities by 1.10 to simulate bulk ordering.',
        sql: "SELECT recipe_id, quantity, quantity * 1.10 AS bulk_quantity FROM Recipe_Ingredients;",
        mockResult: [
          { recipe_id: 1, quantity: 2.00, bulk_quantity: 2.20 },
          { recipe_id: 3, quantity: 4.00, bulk_quantity: 4.40 }
        ]
      },
      {
        id: 'op-3',
        title: 'Union of Ingredients and Categories',
        explanation: 'Combines all names from ingredients and categories.',
        sql: "SELECT name FROM Ingredients\nUNION\nSELECT name FROM Categories;",
        mockResult: [
          { name: 'Chicken Breast' },
          { name: 'Olive Oil' },
          { name: 'Breakfast' },
          { name: 'Dinner' }
        ]
      }
    ]
  },
  {
    id: 'joins',
    name: 'Joins & Relations',
    icon: 'Shuffle',
    queries: [
      {
        id: 'join-1',
        title: 'Inner Join: Recipes & Users',
        explanation: 'Performs a standard inner join to map recipes to their creators.',
        sql: "SELECT R.recipe_id, R.title, U.username, U.email\nFROM Recipes R\nINNER JOIN Users U ON R.user_id = U.user_id;",
        mockResult: [
          { recipe_id: 1, title: 'Classic Roasted Chicken', username: 'chef_mario', email: 'mario@example.com' },
          { recipe_id: 2, title: 'Simple Butter Cookies', username: 'baker_jane', email: 'jane@example.com' },
          { recipe_id: 3, title: 'Spicy Tomato Pasta', username: 'spicy_sam', email: 'sam@food.com' }
        ]
      },
      {
        id: 'join-2',
        title: 'Multi-Way Join: Chef, Dish, Ingredient, Category',
        explanation: 'A highly comprehensive join tracing users to recipes, to ingredients, and categories.',
        sql: "SELECT U.username AS Chef, R.title AS Dish, I.name AS Ingredient, C.name AS Category\nFROM Users U\nJOIN Recipes R ON U.user_id = R.user_id\nJOIN Recipe_Ingredients RI ON R.recipe_id = RI.recipe_id\nJOIN Ingredients I ON RI.ingredient_id = I.ingredient_id\nJOIN Recipe_Categories RC ON R.recipe_id = RC.recipe_id\nJOIN Categories C ON RC.category_id = C.category_id;",
        mockResult: [
          { Chef: 'chef_mario', Dish: 'Classic Roasted Chicken', Ingredient: 'Chicken Breast', Category: 'Dinner' },
          { Chef: 'chef_mario', Dish: 'Classic Roasted Chicken', Ingredient: 'Olive Oil', Category: 'Dinner' },
          { Chef: 'spicy_sam', Dish: 'Spicy Tomato Pasta', Ingredient: 'Tomato', Category: 'Italian' }
        ]
      }
    ]
  },
  {
    id: 'subqueries',
    name: 'Subqueries',
    icon: 'Layers',
    queries: [
      {
        id: 'sub-1',
        title: 'Scalar Subquery: Max Cook Time',
        explanation: 'Shows recipe title and the max cook time in the whole DB as a scalar column.',
        sql: "SELECT title, (SELECT MAX(cook_time) FROM Recipes) AS max_db_cook_time\nFROM Recipes;",
        mockResult: [
          { title: 'Classic Roasted Chicken', max_db_cook_time: 60 },
          { title: 'Vegan Onion Soup', max_db_cook_time: 60 }
        ]
      },
      {
        id: 'sub-2',
        title: 'Subquery in WHERE: Above Average Prep Time',
        explanation: 'Finds recipes whose prep time is greater than the overall average prep time.',
        sql: "SELECT title, prep_time\nFROM Recipes\nWHERE prep_time > (SELECT AVG(prep_time) FROM Recipes);",
        mockResult: [
          { title: 'Simple Butter Cookies', prep_time: 20 },
          { title: 'Homemade Pizza Dough', prep_time: 30 }
        ]
      },
      {
        id: 'sub-3',
        title: 'EXISTS: Users with Saved Favorites',
        explanation: 'Shows only users who have saved a favorite recipe using an EXISTS subquery.',
        sql: "SELECT username FROM Users U\nWHERE EXISTS (\n    SELECT 1 FROM Favorites F WHERE F.user_id = U.user_id\n);",
        mockResult: [
          { username: 'chef_mario' },
          { username: 'baker_jane' },
          { username: 'spicy_sam' }
        ]
      }
    ]
  },
  {
    id: 'conditional',
    name: 'Conditional logic & CASE',
    icon: 'ToggleLeft',
    queries: [
      {
        id: 'cond-1',
        title: 'CASE: Difficulty Descriptions',
        explanation: 'Uses a simple CASE syntax to categorize difficulty levels into descriptions.',
        sql: "SELECT title,\n    CASE difficulty\n        WHEN 'Easy' THEN 'Beginner Friendly'\n        WHEN 'Medium' THEN 'Requires Skill'\n        WHEN 'Hard' THEN 'Expert Only'\n        ELSE 'Unknown'\n    END AS difficulty_label\nFROM Recipes;",
        mockResult: [
          { title: 'Classic Roasted Chicken', difficulty_label: 'Requires Skill' },
          { title: 'Simple Butter Cookies', difficulty_label: 'Beginner Friendly' },
          { title: 'Homemade Pizza Dough', difficulty_label: 'Expert Only' }
        ]
      },
      {
        id: 'cond-2',
        title: 'CASE with Ranges: Rating Feedback',
        explanation: 'Uses a searched CASE expression to classify numeric ratings into descriptions.',
        sql: "SELECT recipe_id, rating_score,\n    CASE\n        WHEN rating_score >= 4 THEN 'Excellent'\n        WHEN rating_score = 3 THEN 'Satisfactory'\n        ELSE 'Needs Improvement'\n    END AS grade_description\nFROM Ratings;",
        mockResult: [
          { recipe_id: 1, rating_score: 5, grade_description: 'Excellent' },
          { recipe_id: 2, rating_score: 4, grade_description: 'Excellent' },
          { recipe_id: 4, rating_score: 3, grade_description: 'Satisfactory' },
          { recipe_id: 7, rating_score: 2, grade_description: 'Needs Improvement' }
        ]
      }
    ]
  },
  {
    id: 'window',
    name: 'Window Functions',
    icon: 'Grid',
    queries: [
      {
        id: 'win-1',
        title: 'Row Number, Rank, and Dense Rank',
        explanation: 'Executes ROW_NUMBER(), RANK(), and DENSE_RANK() ranking recipes by cook time within each difficulty group.',
        sql: "SELECT title, difficulty, cook_time,\n    ROW_NUMBER() OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS row_num,\n    RANK() OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS cook_rank,\n    DENSE_RANK() OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS dense_rank\nFROM Recipes\nORDER BY difficulty, cook_time DESC;",
        mockResult: [
          { title: 'Vegan Onion Soup', difficulty: 'Medium', cook_time: 40, row_num: 1, cook_rank: 1, dense_rank: 1 },
          { title: 'BBQ Chicken Wings', difficulty: 'Medium', cook_time: 25, row_num: 2, cook_rank: 2, dense_rank: 2 }
        ]
      },
      {
        id: 'win-2',
        title: 'Moving Average Cook Times',
        explanation: 'Computes a 3-row moving average of cook times partitioned by difficulty level.',
        sql: "SELECT title, difficulty, cook_time,\n    AVG(cook_time) OVER (PARTITION BY difficulty ORDER BY cook_time DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_cook_time\nFROM Recipes\nORDER BY difficulty, cook_time DESC;",
        mockResult: [
          { title: 'Vegan Onion Soup', difficulty: 'Medium', cook_time: 40, moving_avg_cook_time: 32 },
          { title: 'BBQ Chicken Wings', difficulty: 'Medium', cook_time: 25, moving_avg_cook_time: 25 }
        ]
      }
    ]
  },
  {
    id: 'ctes',
    name: 'CTEs & Views',
    icon: 'GitCommit',
    queries: [
      {
        id: 'cte-1',
        title: 'CTE: Long Cook Time Recipes',
        explanation: 'Defines a Common Table Expression to filter recipes with cook_time > 60.',
        sql: ";WITH LongCookTimeRecipes AS (\n    SELECT recipe_id, user_id, title, cook_time\n    FROM Recipes\n    WHERE cook_time >= 60\n)\nSELECT lcr.title, lcr.cook_time, u.username, u.email\nFROM LongCookTimeRecipes lcr\nLEFT JOIN Users u ON lcr.user_id = u.user_id\nORDER BY lcr.cook_time DESC;",
        mockResult: [
          { title: 'Classic Roasted Chicken', cook_time: 60, username: 'chef_mario', email: 'mario@example.com' }
        ]
      },
      {
        id: 'cte-2',
        title: 'CTE: Bulk Ingredients',
        explanation: 'Finds recipes using bulk ingredients (quantity >= 5.00).',
        sql: ";WITH BulkIngredients AS (\n    SELECT ingredient_id, recipe_id\n    FROM Recipe_Ingredients\n    WHERE quantity >= 5.00\n),\nRecipesWithBulk AS (\n    SELECT r.recipe_id, r.title, r.user_id\n    FROM Recipes r\n    JOIN BulkIngredients bi ON r.recipe_id = bi.recipe_id\n)\nSELECT rb.title AS recipe_name, u.username AS creator\nFROM RecipesWithBulk rb\nJOIN Users u ON rb.user_id = u.user_id;",
        mockResult: [
          { recipe_name: 'Creamy Garlic Sauce', creator: 'sweet_sarah' },
          { recipe_name: 'Simple Butter Cookies', creator: 'baker_jane' }
        ]
      }
    ]
  }
];
