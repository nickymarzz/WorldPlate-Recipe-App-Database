-- =========================================================================================================
-- -- 1. Database Schema (DDL) --
-- =========================================================================================================

-- USERS TABLE
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- INGREDIENTS TABLE
CREATE TABLE Ingredients (
    ingredient_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL UNIQUE
);

-- UNITS TABLE
CREATE TABLE Units (
    unit_id INT PRIMARY KEY IDENTITY(1,1),
    unit_name VARCHAR(50) NOT NULL UNIQUE
);

-- ACTIONS TABLE
CREATE TABLE Actions (
    action_id INT PRIMARY KEY IDENTITY(1,1),
    action_name VARCHAR(50) NOT NULL UNIQUE
);

-- CATEGORIES TABLE
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL UNIQUE
);

-- RECIPES TABLE
CREATE TABLE Recipes (
    recipe_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    title VARCHAR(150) NOT NULL UNIQUE,
    prep_time SMALLINT NOT NULL CHECK (prep_time > 0),
    cook_time SMALLINT NOT NULL CHECK (cook_time >= 0),
    difficulty CHAR(6) CHECK (difficulty IN ('Easy', 'Medium', 'Hard')),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- RECIPE_INGREDIENTS (Many-to-Many Link)
CREATE TABLE Recipe_Ingredients (
    recipe_id INT NOT NULL REFERENCES Recipes(recipe_id) ON DELETE CASCADE,
    ingredient_id INT NOT NULL REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE,
    unit_id INT NULL REFERENCES Units(unit_id) ON DELETE SET NULL, 
    quantity DECIMAL(6,2) NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (recipe_id, ingredient_id)
);

-- STEPS TABLE
CREATE TABLE Steps (
    recipe_id INT NOT NULL REFERENCES Recipes(recipe_id) ON DELETE CASCADE,
    step_number SMALLINT NOT NULL CHECK (step_number > 0),
    action_id INT NULL REFERENCES Actions(action_id) ON DELETE SET NULL,
    duration SMALLINT CHECK (duration >= 0),
    PRIMARY KEY (recipe_id, step_number)
);

-- RECIPE_CATEGORIES (Many-to-Many Link)
CREATE TABLE Recipe_Categories (
    recipe_id INT NOT NULL REFERENCES Recipes(recipe_id) ON DELETE CASCADE,
    category_id INT NOT NULL REFERENCES Categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_id, category_id)
);

-- RATINGS TABLE
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    recipe_id INT NOT NULL REFERENCES Recipes(recipe_id), -- NO ACTION here to prevent circular cascade loops
    rating_score TINYINT NOT NULL CHECK (rating_score BETWEEN 1 AND 5),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- FAVORITES TABLE
CREATE TABLE Favorites (
    user_id INT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    recipe_id INT NOT NULL REFERENCES Recipes(recipe_id), -- NO ACTION here to break execution dependency paths
    saved_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, recipe_id)
);
GO

-- =========================================================================================================
-- -- 2. Data Insertion (DML) --
-- =========================================================================================================

INSERT INTO Users (username, email) VALUES 
('chef_mario', 'mario@example.com'), ('baker_jane', 'jane@example.com'), 
('spicy_sam', 'sam@food.com'), ('healthy_heather', 'heather@fit.com'), 
('keto_king', 'king@keto.com'), ('vegan_vibe', 'vibe@green.com'), 
('pasta_pro', 'pro@italy.com'), ('grill_master', 'master@bbq.com'), 
('sweet_sarah', 'sarah@dessert.com'), ('quick_cook', 'quick@meals.com');

INSERT INTO Ingredients (name) VALUES 
('Chicken Breast'), ('Olive Oil'), ('Salt'), ('Black Pepper'), 
('Garlic'), ('Onion'), ('Tomato'), ('Flour'), ('Butter'), ('Milk');

INSERT INTO Units (unit_name) VALUES 
('Grams'), ('Kilograms'), ('Milliliters'), ('Liters'), 
('Teaspoon'), ('Tablespoon'), ('Cup'), ('Piece'), ('Clove'), ('Pinch');

INSERT INTO Actions (action_name) VALUES 
('Chop'), ('Fry'), ('Bake'), ('Boil'), ('Grill'), 
('Stir'), ('Whisk'), ('Mince'), ('Simmer'), ('Steam');

INSERT INTO Categories (name) VALUES 
('Breakfast'), ('Lunch'), ('Dinner'), ('Dessert'), ('Snack'), 
('Vegan'), ('Gluten-Free'), ('Italian'), ('Mexican'), ('Low-Carb');

INSERT INTO Recipes (user_id, title, prep_time, cook_time, difficulty) VALUES 
(1, 'Classic Roasted Chicken', 15, 60, 'Medium'),
(2, 'Simple Butter Cookies', 20, 12, 'Easy'),
(3, 'Spicy Tomato Pasta', 10, 15, 'Easy'),
(4, 'Garlic Steamed Veggies', 10, 10, 'Easy'),
(5, 'Keto Grilled Steak', 5, 12, 'Medium'),
(6, 'Vegan Onion Soup', 15, 40, 'Medium'),
(7, 'Homemade Pizza Dough', 30, 0, 'Hard'),
(8, 'BBQ Chicken Wings', 10, 25, 'Medium'),
(9, 'Creamy Garlic Sauce', 5, 5, 'Easy'),
(10, 'Quick Morning Omelet', 5, 5, 'Easy');

-- Link Ingredients to Recipes (recipe_id, ingredient_id, unit_id, quantity)
INSERT INTO Recipe_Ingredients (recipe_id, ingredient_id, unit_id, quantity) VALUES 
(1, 1, 8, 2.00), (1, 2, 6, 2.00), (3, 7, 8, 4.00), (3, 5, 9, 3.00),
(2, 8, 7, 2.50), (2, 9, 1, 200.00), (6, 6, 8, 3.00), (9, 10, 3, 100.00),
(10, 9, 6, 1.00), (1, 3, 10, 2.00);

-- Steps for Recipes (recipe_id, step_number, action_id, duration)
INSERT INTO Steps (recipe_id, step_number, action_id, duration) VALUES 
(1, 1, 1, 10), (1, 2, 3, 50), (3, 1, 8, 5), (3, 2, 2, 10),
(10, 1, 7, 2), (10, 2, 2, 3), (8, 1, 5, 20), (4, 1, 10, 10),
(6, 1, 1, 5), (6, 2, 9, 35);

-- Categories for Recipes
INSERT INTO Recipe_Categories (recipe_id, category_id) VALUES 
(1, 3), (2, 4), (3, 8), (4, 6), (5, 10), (6, 6), (7, 8), (8, 3), (9, 5), (10, 1);

INSERT INTO Ratings (user_id, recipe_id, rating_score) VALUES 
(2, 1, 5), (1, 2, 4), (3, 3, 5), (4, 4, 3), (5, 5, 5), 
(6, 6, 4), (7, 7, 2), (8, 8, 5), (9, 9, 4), (10, 10, 5);

INSERT INTO Favorites (user_id, recipe_id) VALUES 
(1, 3), (1, 5), (2, 1), (3, 8), (4, 6), (5, 5), (6, 4), (7, 3), (8, 1), (9, 2);
GO

-- =========================================================================================================
-- -- 3. UPDATE & DELETE --
-- =========================================================================================================

-- Increase cook_time by 10% for all 'Dinner' recipes
UPDATE Recipes 
SET cook_time = cook_time * 1.1
WHERE recipe_id IN (
    SELECT rc.recipe_id 
    FROM Recipe_Categories rc
    JOIN Categories c ON rc.category_id = c.category_id
    WHERE c.name = 'Dinner'
);

-- Update a specific step's duration for a specific recipe
UPDATE Steps 
SET duration = 15
WHERE recipe_id = 5 AND step_number = 2;

-- Delete a specific recipe
DELETE FROM Recipes
WHERE title = 'Bland Pasta';

-- Update cook_time to a default of 20 minutes where it is currently 0 or missing
UPDATE Recipes
SET cook_time = 20
WHERE cook_time = 0 OR cook_time IS NULL;

-- Change the quantity of 'Salt' (e.g., ingredient_id 10) for all 'Easy' difficulty recipes
UPDATE Recipe_Ingredients
SET quantity = 1.00
WHERE ingredient_id = 10 
  AND recipe_id IN (SELECT recipe_id FROM Recipes WHERE difficulty = 'Easy');
GO

-- =========================================================================================================
-- -- 4. Operators & Select -- 
-- =========================================================================================================

/* 1. DISTINCT VALUES & STRING MANIPULATION */
SELECT DISTINCT difficulty FROM Recipes;
SELECT CONCAT(username, ' (Email: ', email, ')') AS user_contact FROM Users;
SELECT title, difficulty FROM Recipes WHERE cook_time > 30;

/* 2. RANGES & SPECIFIC FILTERS */
SELECT title, cook_time FROM Recipes WHERE cook_time BETWEEN 20 AND 60;
SELECT title, difficulty FROM Recipes WHERE difficulty = 'Medium';
SELECT title, prep_time, cook_time FROM Recipes WHERE (difficulty = 'Easy' AND prep_time <= 10) OR difficulty = 'Hard';

/* 3. PATTERN MATCHING (LIKE) */
SELECT title FROM Recipes WHERE title LIKE '%Chicken%';
SELECT username, email FROM Users WHERE username LIKE 'chef%';
SELECT username FROM Users WHERE username NOT LIKE 'chef%';
SELECT name FROM Ingredients WHERE name LIKE '______%'; -- Names with 6 or more characters
SELECT name FROM Ingredients WHERE name LIKE '_a%'; -- Second letter is 'a'
SELECT name FROM Categories WHERE name LIKE '%\.%' ESCAPE '\'; -- Look for actual dots in names

/* 4. SORTING & TOP RESULTS */
SELECT title, cook_time FROM Recipes ORDER BY cook_time DESC;
SELECT title, difficulty, cook_time FROM Recipes ORDER BY difficulty ASC, cook_time DESC, CASE WHEN cook_time IS NULL THEN 1 ELSE 0 END;
SELECT TOP 2 title, prep_time FROM Recipes ORDER BY prep_time DESC;
SELECT TOP 2 title, cook_time FROM Recipes WHERE difficulty = 'Medium' AND cook_time >= 20 ORDER BY title ASC;

/* 5. PAGINATION (OFFSET/FETCH) */
SELECT title, cook_time FROM Recipes ORDER BY cook_time ASC OFFSET 2 ROWS FETCH NEXT 2 ROWS ONLY;

/* 6. CALCULATED COLUMNS (ARITHMETIC) */
SELECT title, prep_time, prep_time + 5 AS increased_prep FROM Recipes;
SELECT title, cook_time, cook_time - 5 AS reduced_cook FROM Recipes;
SELECT recipe_id, quantity, quantity * 1.10 AS bulk_quantity FROM Recipe_Ingredients;
SELECT title, cook_time, cook_time / 60.0 AS cook_time_hours FROM Recipes;
SELECT recipe_id, quantity, quantity % 1 AS fractional_part FROM Recipe_Ingredients;

/* 7. BOOLEAN & BITWISE LOGIC */
SELECT * FROM Recipes WHERE NOT difficulty = 'Easy';
SELECT user_id, (user_id & 1) AS is_odd_id FROM Users;
SELECT user_id, (user_id ^ 1) AS toggle_bit FROM Users;

/* 8. SET OPERATIONS */
SELECT name FROM Ingredients 
UNION  -- All for showing duplicate
SELECT name FROM Categories; 

SELECT name FROM Ingredients 
INTERSECT 
SELECT name FROM Categories; -- Names appearing in both

SELECT name FROM Ingredients 
EXCEPT 
SELECT name FROM Categories; -- Ingredients that aren't also categories

/* 9. SUBQUERIES (EXISTS) */
SELECT username FROM Users u 
WHERE EXISTS (
    SELECT 1 FROM Recipes r 
    WHERE r.user_id = u.user_id
); -- Shows only users who have actually created a recipe
GO

-- =========================================================================================================
-- -- 5. JOIN --
-- =========================================================================================================

-- INNER JOIN: Only recipes that have an assigned user
SELECT R.recipe_id, R.title, U.username, U.email
FROM Recipes R
INNER JOIN Users U ON R.user_id = U.user_id;

-- INNER JOIN on Multiple Columns: Steps and Actions
SELECT S.recipe_id, S.step_number, S.duration, A.action_name
FROM Steps S
INNER JOIN Actions A ON S.action_id = A.action_id;

-- LEFT JOIN: All Users, including those who haven't posted a recipe yet
SELECT U.username, R.title 
FROM Users U
LEFT JOIN Recipes R ON U.user_id = R.user_id;

-- RIGHT JOIN: All Categories, including those with no recipes assigned
SELECT C.name AS category_name, R.title
FROM Recipe_Categories RC
RIGHT JOIN Categories C ON RC.category_id = C.category_id
LEFT JOIN Recipes R ON RC.recipe_id = R.recipe_id;

-- FULL JOIN: All Ingredients and all Units to see every possible combination
SELECT I.name, U.unit_name 
FROM Ingredients I
FULL JOIN Recipe_Ingredients RI ON I.ingredient_id = RI.ingredient_id
FULL JOIN Units U ON RI.unit_id = U.unit_id;

-- SELF JOIN / MULTI-WAY JOIN: Complex relationship map
SELECT 
    U.username AS Chef, 
    R.title AS Dish, 
    I.name AS Ingredient, 
    C.name AS Category
FROM Users U
JOIN Recipes R ON U.user_id = R.user_id
JOIN Recipe_Ingredients RI ON R.recipe_id = RI.recipe_id
JOIN Ingredients I ON RI.ingredient_id = I.ingredient_id
JOIN Recipe_Categories RC ON R.recipe_id = RC.recipe_id
JOIN Categories C ON RC.category_id = C.category_id;
GO

-- =========================================================================================================
-- -- 6. SUBQUERIES --
-- =========================================================================================================

-- SCALAR Subquery: Show recipe title and the max cook time in the whole DB
SELECT title, (SELECT MAX(cook_time) FROM Recipes) AS max_db_cook_time
FROM Recipes;

-- WHERE Subquery: Recipes with prep time above average
SELECT title, prep_time 
FROM Recipes 
WHERE prep_time > (SELECT AVG(prep_time) FROM Recipes);

-- IN Subquery: Find ingredients used in 'Hard' recipes
SELECT name FROM Ingredients
WHERE ingredient_id IN (
    SELECT ingredient_id FROM Recipe_Ingredients
    WHERE recipe_id IN (SELECT recipe_id FROM Recipes WHERE difficulty = 'Hard')
);

-- ALL Subquery: Recipes with more calories/time than ANY 'Easy' recipe
SELECT title, cook_time FROM Recipes
WHERE cook_time > ALL (SELECT cook_time FROM Recipes WHERE difficulty = 'Easy');

-- Subquery in FROM: Average ingredient quantity per recipe
SELECT AVG(total_qty) AS avg_recipe_quantity
FROM (
    SELECT recipe_id, SUM(quantity) AS total_qty
    FROM Recipe_Ingredients
    GROUP BY recipe_id
) AS QtyTotals;
GO

-- =========================================================================================================
-- -- 7. CONDITIONAL LOGIC --
-- =========================================================================================================

-- EXISTS: Users who have saved a favorite
SELECT username FROM Users U
WHERE EXISTS (
    SELECT 1 FROM Favorites F WHERE F.user_id = U.user_id
);

-- Advanced EXISTS: Recipes that use 'Garlic' and have a high rating
SELECT title FROM Recipes R
WHERE EXISTS (
    SELECT 1 FROM Recipe_Ingredients RI 
    JOIN Ingredients I ON RI.ingredient_id = I.ingredient_id
    WHERE RI.recipe_id = R.recipe_id AND I.name = 'Garlic'
) AND EXISTS (
    SELECT 1 FROM Ratings RT WHERE RT.recipe_id = R.recipe_id AND RT.rating_score = 5
);

-- CASE: Difficulty descriptions
SELECT title, 
    CASE difficulty
        WHEN 'Easy' THEN 'Beginner Friendly'
        WHEN 'Medium' THEN 'Requires Skill'
        WHEN 'Hard' THEN 'Expert Only'
        ELSE 'Unknown'
    END AS difficulty_label
FROM Recipes;

-- CASE with Ranges: Rating feedback
SELECT recipe_id, rating_score,
    CASE 
        WHEN rating_score >= 4 THEN 'Excellent'
        WHEN rating_score = 3 THEN 'Satisfactory'
        ELSE 'Needs Improvement'
    END AS grade_description
FROM Ratings;

-- COALESCE: Handle missing units
SELECT I.name, COALESCE(U.unit_name, 'Count/Whole') AS unit
FROM Ingredients I
LEFT JOIN Recipe_Ingredients RI ON I.ingredient_id = RI.ingredient_id
LEFT JOIN Units U ON RI.unit_id = U.unit_id;

-- NULLIF: Treat 0 duration steps as NULL
SELECT recipe_id, step_number, NULLIF(duration, 0) AS adjusted_duration
FROM Steps;
GO

-- =========================================================================================================
-- -- 8. DATE --
-- =========================================================================================================

-- 1. CURRENT DATE & TIME FUNCTIONS
SELECT GETDATE() AS current_datetime, SYSDATETIME() AS current_datetime2;
SELECT CURRENT_TIMESTAMP AS [current_timestamp];

-- 2. DATE MANIPULATION (Adding, Subtracting, and Differences)
-- Add 7 days to a recipe's creation date
SELECT title, created_at, DATEADD(DAY, 7, created_at) AS featured_until 
FROM Recipes;

-- Find recipes created more than 2 months ago
SELECT title, created_at 
FROM Recipes 
WHERE created_at < DATEADD(MONTH, -2, GETDATE());

-- Calculate how many days ago each rating was posted
SELECT rating_id, created_at, DATEDIFF(DAY, created_at, GETDATE()) AS days_ago 
FROM Ratings;

-- 3. EXTRACTING DATE PARTS
SELECT title,
    DATEPART(YEAR, created_at) AS year_created,
    DATEPART(MONTH, created_at) AS month_created, 
    DATEPART(DAY, created_at) AS day_created
FROM Recipes;

-- Simpler Year/Month/Day functions
SELECT title, YEAR(created_at) AS y, MONTH(created_at) AS m, DAY(created_at) AS d 
FROM Recipes;

-- Get the Name of the month and weekday
SELECT title, 
    DATENAME(MONTH, created_at) AS month_name, 
    DATENAME(WEEKDAY, created_at) AS weekday_posted
FROM Recipes;

-- 4. FORMATTING & CONSTRUCTION
-- Format date as "May 10, 2025 02:30 PM"
SELECT title, FORMAT(created_at, 'MMMM dd, yyyy hh:mm tt') AS formatted_creation 
FROM Recipes;

-- Find the last day of the month a recipe was posted
SELECT title, EOMONTH(created_at) AS end_of_month_deadline 
FROM Recipes;

-- Construct a specific date
SELECT DATEFROMPARTS(2025, 12, 25) AS christmas_special_date;

-- 5. FILTERING DATA BY TIME
-- Find recipes created between two specific dates
SELECT title, created_at 
FROM Recipes 
WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';

-- Calculate "age" of a recipe in years
SELECT title, DATEDIFF(YEAR, created_at, GETDATE()) AS years_on_platform 
FROM Recipes;

-- Find all ratings posted specifically in the month of March
SELECT rating_id, rating_score, created_at 
FROM Ratings 
WHERE MONTH(created_at) = 3;

-- Format the 'saved_at' time for User Favorites
SELECT user_id, recipe_id, FORMAT(saved_at, 'MMM dd, yyyy') AS date_favorited 
FROM Favorites;
GO

-- =========================================================================================================
-- -- 9. INDEX --
-- =========================================================================================================

-- Create a replica for testing performance
CREATE TABLE Recipes_Large (
    recipe_id INT PRIMARY KEY,
    title VARCHAR(150),
    difficulty CHAR(6),
    prep_time SMALLINT,
    cook_time SMALLINT
);
GO

BEGIN TRANSACTION; 
BEGIN TRY
    WITH Numbers AS (
        SELECT TOP 50000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n 
        FROM sys.objects a CROSS JOIN sys.objects b CROSS JOIN sys.objects c
    )
    INSERT INTO Recipes_Large (recipe_id, title, difficulty, prep_time, cook_time) 
    SELECT
        n, 
        'Recipe Title ' + CAST(n AS VARCHAR(10)),
        CASE
            WHEN n%3 = 0 THEN 'Easy'
            WHEN n%3 = 1 THEN 'Medium'
            ELSE 'Hard'
        END,
        (n%30) + 5,
        (n%60) + 10
    FROM Numbers;

    COMMIT TRANSACTION;
    PRINT 'Successfully inserted 50,000 records into Recipes_Large table';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error inserting records: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Check total count
SELECT COUNT(*) FROM Recipes_Large;
GO

-- 1. TEST WITHOUT INDEX
DECLARE @StartTime DATETIME, @EndTime DATETIME, @Duration INT;
PRINT 'Running Query without index...';
SET @StartTime = GETDATE();

SELECT * FROM Recipes_Large WHERE difficulty = 'Hard';

SET @EndTime = GETDATE();
SET @Duration = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
PRINT 'Query without index completed in ' + CAST(@Duration AS VARCHAR(10)) + 'ms';
GO

-- Clear Cache for a fair test
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
GO

-- Create Index
CREATE INDEX ix_recipe_difficulty ON Recipes_Large (difficulty);
GO

-- 2. TEST WITH INDEX
DECLARE @StartTime DATETIME, @EndTime DATETIME, @Duration INT;
PRINT 'Running Query with index...';
SET @StartTime = GETDATE();

SELECT * FROM Recipes_Large WHERE difficulty = 'Hard';

SET @EndTime = GETDATE();
SET @Duration = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
PRINT 'Query with index completed in ' + CAST(@Duration AS VARCHAR(10)) + 'ms';
GO

-- Manage Index on Recipes (Difficulty)
IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'idx_recipes_difficulty' AND object_id = OBJECT_ID('Recipes')) 
    DROP INDEX idx_recipes_difficulty ON Recipes;

CREATE INDEX idx_recipes_difficulty ON Recipes (difficulty);

-- Manage Index on Ingredients (Name)
IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'idx_ingredient_name' AND object_id = OBJECT_ID('Ingredients')) 
    DROP INDEX idx_ingredient_name ON Ingredients;

CREATE INDEX idx_ingredient_name ON Ingredients (name);

-- Composite Index
IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'idx_steps_recipe_number' AND object_id = OBJECT_ID('Steps')) 
    DROP INDEX idx_steps_recipe_number ON Steps;

CREATE INDEX idx_steps_recipe_number ON Steps (recipe_id, step_number);
GO

-- Example usage of composite index
SELECT * FROM Steps WHERE recipe_id = 5 AND step_number = 2;

-- Cleanup
DROP INDEX idx_steps_recipe_number ON Steps;
GO

-- =========================================================================================================
-- -- 10. VIEWS --
-- =========================================================================================================

-- Create a view for quick-prep recipes
CREATE VIEW RecipeQuickInfo AS
SELECT 
    recipe_id, title, prep_time, difficulty 
FROM Recipes 
WHERE prep_time <= 20; 
GO

-- Query the view
SELECT * FROM RecipeQuickInfo WHERE difficulty = 'Easy';
GO

CREATE VIEW ChefPortfolio AS
SELECT 
    u.user_id,
    u.username AS chef_name,
    r.title AS recipe_title,
    c.name AS category_name,
    r.difficulty,
    r.created_at
FROM Users u
JOIN Recipes r ON u.user_id = r.user_id
JOIN Recipe_Categories rc ON r.recipe_id = rc.recipe_id
JOIN Categories c ON rc.category_id = c.category_id;
GO

-- Usage
SELECT chef_name, recipe_title, category_name 
FROM ChefPortfolio 
WHERE category_name = 'Dessert';
GO

ALTER VIEW RecipeQuickInfo AS
SELECT 
    r.recipe_id, r.title, r.prep_time, r.difficulty, u.email AS creator_email
FROM Recipes r
JOIN Users u ON r.user_id = u.user_id
WHERE r.prep_time <= 20;
GO

-- Drop if exists
DROP VIEW IF EXISTS CategoryRecipeCount;
GO

CREATE VIEW CategoryRecipeCount WITH SCHEMABINDING AS
SELECT 
    c.name AS category_name,
    COUNT_BIG(*) AS recipe_count -- Indexed views require COUNT_BIG
FROM dbo.Categories c
JOIN dbo.Recipe_Categories rc ON c.category_id = rc.category_id
GROUP BY c.name;
GO

-- Materialize the view with a clustered index
CREATE UNIQUE CLUSTERED INDEX idx_CatRecipeCount ON CategoryRecipeCount (category_name);
GO

-- Fast lookup
SELECT category_name, recipe_count FROM CategoryRecipeCount;
GO

CREATE VIEW HardRecipesOnly AS
SELECT 
    recipe_id, title, difficulty, cook_time
FROM Recipes
WHERE difficulty = 'Hard'
WITH CHECK OPTION;
GO

-- This INSERT will FAIL because difficulty is 'Easy', not 'Hard'.
-- Left here commented out so automated baseline runners do not halt execution.
-- INSERT INTO HardRecipesOnly (title, difficulty, cook_time) VALUES ('Simple Toast', 'Easy', 5);
-- GO

-- This UPDATE will SUCCEED if the recipe is Hard
UPDATE HardRecipesOnly SET cook_time = 120 WHERE title = 'Beef Wellington';
GO

CREATE VIEW PublicRatings AS
SELECT 
    u.username, r.title AS recipe_name, rt.rating_score, rt.created_at
FROM Users u
JOIN Ratings rt ON u.user_id = rt.user_id
JOIN Recipes r ON rt.recipe_id = r.recipe_id;
GO

-- Grant access to the view without giving access to the raw tables
GRANT SELECT ON PublicRatings TO PUBLIC;
GO

CREATE VIEW KitchenActionLog AS
SELECT 
    r.title, s.step_number, a.action_name, s.duration
FROM Recipes r
JOIN Steps s ON r.recipe_id = s.recipe_id
JOIN Actions a ON s.action_id = a.action_id;
GO

-- Find all long-duration actions
SELECT title, action_name FROM KitchenActionLog WHERE duration > 30;
GO

-- =========================================================================================================
-- -- 11. WINDOW FUNCTIONS --
-- =========================================================================================================

-- Ranking recipes by cook time within each difficulty group
SELECT title, difficulty, cook_time,
    ROW_NUMBER() OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS row_num, 
    RANK() OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS cook_rank,
    DENSE_RANK() OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS dense_rank 
FROM Recipes 
ORDER BY difficulty, cook_time DESC;

-- Numbering ingredients within each specific recipe
SELECT recipe_id, ingredient_id, quantity,
    ROW_NUMBER() OVER (PARTITION BY recipe_id ORDER BY quantity DESC) AS ingredient_seq
FROM Recipe_Ingredients
ORDER BY recipe_id, quantity DESC;

-- Global ranking of users by how many recipes they have created
SELECT user_id, 
    COUNT(recipe_id) AS recipe_count,
    RANK() OVER (ORDER BY COUNT(recipe_id) DESC) AS user_rank
FROM Recipes
GROUP BY user_id;

-- Running total of cook_time across all recipes (ordered by time)
SELECT title, cook_time,
    SUM(cook_time) OVER (ORDER BY cook_time DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_time
FROM Recipes
ORDER BY cook_time DESC;

-- Running sum of ingredient quantities within a single recipe
SELECT recipe_id, ingredient_id, quantity,
    SUM(quantity) OVER (PARTITION BY recipe_id ORDER BY quantity DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_quantity
FROM Recipe_Ingredients
ORDER BY recipe_id, quantity DESC;

-- 3-row moving average of rating scores
SELECT rating_id, recipe_id, rating_score,
    CAST(ROUND(AVG(CAST(rating_score AS DECIMAL(10,2))) 
    OVER (PARTITION BY recipe_id ORDER BY created_at DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 2) AS DECIMAL(10,2)) AS moving_avg_rating
FROM Ratings
ORDER BY recipe_id, created_at DESC;

-- Moving average of cook times within the same difficulty level
SELECT title, difficulty, cook_time,
    AVG(cook_time) OVER (PARTITION BY difficulty ORDER BY cook_time DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_cook_time
FROM Recipes
ORDER BY difficulty, cook_time DESC;

-- Comparing a recipe's cook time to the one immediately slower and faster
SELECT title, difficulty, cook_time,
    LAG(cook_time) OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS slower_recipe_time,
    LEAD(cook_time) OVER (PARTITION BY difficulty ORDER BY cook_time DESC) AS faster_recipe_time
FROM Recipes
ORDER BY difficulty, cook_time DESC;
GO

-- =========================================================================================================
-- -- 12. CTE --
-- =========================================================================================================

;WITH LongCookTimeRecipes AS (
    SELECT recipe_id, user_id, title, cook_time 
    FROM Recipes	
    WHERE cook_time > 60  
)
SELECT lcr.title, lcr.cook_time, u.username, u.email 
FROM LongCookTimeRecipes lcr
LEFT JOIN Users u ON lcr.user_id = u.user_id
ORDER BY lcr.cook_time DESC;

WITH RecipeDetails AS (
    SELECT u.user_id, u.username, 
           r.recipe_id, r.title, r.difficulty,
           c.name AS category_name
    FROM Users u
    JOIN Recipes r ON u.user_id = r.user_id 
    JOIN Recipe_Categories rc ON r.recipe_id = rc.recipe_id
    JOIN Categories c ON rc.category_id = c.category_id
)
SELECT * FROM RecipeDetails
WHERE category_name = 'Dinner' 
  AND difficulty = 'Easy' 
  AND username = 'chef_mario'
ORDER BY title;

WITH BulkIngredients AS ( 
    -- Finding specific ingredients used in large amounts
    SELECT ingredient_id, recipe_id
    FROM Recipe_Ingredients
    WHERE quantity >= 5.00
),
RecipesWithBulk AS (
    -- Linking those ingredients to the recipe title
    SELECT r.recipe_id, r.title, r.user_id
    FROM Recipes r
    JOIN BulkIngredients bi ON r.recipe_id = bi.recipe_id
)
SELECT rb.title AS recipe_name, u.username AS creator, u.email
FROM RecipesWithBulk rb
JOIN Users u ON rb.user_id = u.user_id
LEFT JOIN Favorites f ON rb.recipe_id = f.recipe_id
ORDER BY u.username;

-- Secondary block variations present in the source file
WITH LongCookRecipes AS (
    SELECT recipe_id, user_id, title, cook_time 
    FROM Recipes	
    WHERE cook_time > 60  
)
SELECT lcr.title, lcr.cook_time, u.username 
FROM LongCookRecipes lcr
LEFT JOIN Users u ON lcr.user_id = u.user_id
ORDER BY lcr.cook_time DESC;

WITH RecipeDetailsShort AS (
    SELECT u.username, r.recipe_id, r.title, r.difficulty, r.created_at
    FROM Users u
    JOIN Recipes r ON u.user_id = r.user_id
)
SELECT * FROM RecipeDetailsShort
WHERE difficulty = 'Hard' 
  AND username = 'chef_mario' 
ORDER BY title;

WITH HighQuantityIngredients AS ( 
    SELECT recipe_id
    FROM Recipe_Ingredients
    WHERE quantity >= 5.00 
),
RecipesWithBulkQuantities AS (
    SELECT r.recipe_id, r.title, r.user_id
    FROM Recipes r
    JOIN HighQuantityIngredients hqi ON r.recipe_id = hqi.recipe_id
)
SELECT rb.title, u.username, u.email 
FROM RecipesWithBulkQuantities rb
JOIN Users u ON rb.user_id = u.user_id
ORDER BY rb.recipe_id;
GO

-- =========================================================================================================
-- -- 13. Stored Procedures --
-- =========================================================================================================

CREATE PROCEDURE GetIngredientDetails
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ingredient_id, name 
    FROM Ingredients
    ORDER BY name;
END;
GO

CREATE PROCEDURE CountRecipesByDifficulty
AS
BEGIN
    SET NOCOUNT ON;
    SELECT difficulty, COUNT(*) AS recipe_count
    FROM Recipes
    GROUP BY difficulty
    ORDER BY recipe_count DESC;
END;
GO

CREATE PROCEDURE GetRecipesByCategory 
    @CategoryName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.recipe_id, r.title, r.difficulty
    FROM Recipes r
    JOIN Recipe_Categories rc ON r.recipe_id = rc.recipe_id
    JOIN Categories c ON rc.category_id = c.category_id
    WHERE c.name = @CategoryName;
END;
GO

CREATE PROCEDURE GetRecipeFavoriteCount 
    @RecipeID INT,
    @FavCount INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @FavCount = COUNT(*) 
    FROM Favorites
    WHERE recipe_id = @RecipeID;
END;
GO

CREATE PROCEDURE ScalePrepTime
    @TimeValue SMALLINT OUTPUT, 
    @ScaleFactor DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    SET @TimeValue = @TimeValue * @ScaleFactor;
END;
GO

CREATE PROCEDURE AddNewUser 
    @UserHandle VARCHAR(50), 
    @UserEmail VARCHAR(100),
    @StatusMsg NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO Users (username, email) VALUES (@UserHandle, @UserEmail);
        SET @StatusMsg = 'User created successfully.';
    END TRY
    BEGIN CATCH
        SET @StatusMsg = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE UpdateRecipeCookTime 
    @RID INT,
    @NewTime SMALLINT, 
    @ErrMsg NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Recipes WHERE recipe_id = @RID)
    BEGIN
        SET @ErrMsg = 'Error: Recipe ID not found.';
        RETURN;
    END;

    IF @NewTime < 0
    BEGIN
        SET @ErrMsg = 'Error: Time cannot be negative.';
        RETURN;
    END;

    UPDATE Recipes SET cook_time = @NewTime WHERE recipe_id = @RID;
    SET @ErrMsg = 'Success';
END;
GO

CREATE PROCEDURE RateRecipe
    @UID INT,
    @RID INT,
    @Score TINYINT,
    @Status NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validation
        IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @UID)
            BEGIN SET @Status = 'Invalid User'; RETURN; END
        
        IF NOT EXISTS (SELECT 1 FROM Recipes WHERE recipe_id = @RID)
            BEGIN SET @Status = 'Invalid Recipe'; RETURN; END

        IF @Score < 1 OR @Score > 5
            BEGIN SET @Status = 'Score must be 1-5'; RETURN; END

        INSERT INTO Ratings (user_id, recipe_id, rating_score) 
        VALUES (@UID, @RID, @Score);
        
        SET @Status = 'Rating recorded successfully';
    END TRY
    BEGIN CATCH
        SET @Status = 'Database Error: ' + ERROR_MESSAGE(); 
    END CATCH
END;
GO

-- Execution Traces Mapped for testing routine tracking outputs
EXEC GetIngredientDetails;
EXEC CountRecipesByDifficulty;
EXEC GetRecipesByCategory @CategoryName = 'Dinner';

DECLARE @Total INT;
EXEC GetRecipeFavoriteCount @RecipeID = 1, @FavCount = @Total OUTPUT;
SELECT @Total AS total_favorites;

DECLARE @Minutes SMALLINT = 20;
EXEC ScalePrepTime @TimeValue = @Minutes OUTPUT, @ScaleFactor = 1.5;
SELECT @Minutes AS scaled_minutes; 

-- List all procedures currently in the system
SELECT name, create_date FROM sys.procedures;
GO

-- =========================================================================================================
-- -- 14. Triggers --
-- =========================================================================================================

-- Alter table to simulate calculations syncing properties parameters
ALTER TABLE Recipes ADD total_time SMALLINT NULL;
GO

CREATE TRIGGER trg_update_total_time
ON Recipes
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sync total_time = prep_time + cook_time automatically
    UPDATE r
    SET total_time = i.prep_time + i.cook_time
    FROM Recipes r
    INNER JOIN inserted i ON r.recipe_id = i.recipe_id;
END;
GO

-- Testing the auto-calculation trigger
UPDATE Recipes SET prep_time = 15, cook_time = 45 WHERE recipe_id = 1;
SELECT recipe_id, title, prep_time, cook_time, total_time FROM Recipes WHERE recipe_id = 1;
GO

DROP TRIGGER IF EXISTS check_recipe_cook_time_limit;
GO

CREATE TRIGGER check_recipe_cook_time_limit
ON Recipes
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Custom safety threshold validation
    IF EXISTS (SELECT 1 FROM inserted WHERE cook_time > 480) 
    BEGIN
        RAISERROR('Recipe cooking duration cannot exceed 8 hours (480 minutes).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    
    -- If valid, process the execution explicitly
    INSERT INTO Recipes (user_id, title, prep_time, cook_time, difficulty, created_at)
    SELECT user_id, title, prep_time, cook_time, difficulty, ISNULL(created_at, CURRENT_TIMESTAMP)
    FROM inserted;
END;
GO

-- Custom negative verification insert block for INSTEAD OF trigger catch check criteria.
-- Commented out to ensure batch initializers execute cleanly without halting.
-- INSERT INTO Recipes (user_id, title, prep_time, cook_time, difficulty) VALUES (1, 'Slow Roast Experiment', 20, 600, 'Hard');
-- GO

-- Audit table creation
CREATE TABLE Users_Audit_Log (
    audit_id INT IDENTITY(1,1) PRIMARY KEY, 
    user_id INT,
    username VARCHAR(50),
    email VARCHAR(100),
    action_type VARCHAR(10),
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- Insert Audit Trigger
CREATE TRIGGER log_user_registration
ON Users 
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Users_Audit_Log (user_id, username, email, action_type) 
    SELECT user_id, username, email, 'INSERT' FROM inserted;
END;
GO

-- Delete Audit Trigger
CREATE TRIGGER log_user_deletion
ON Users 
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Users_Audit_Log (user_id, username, email, action_type) 
    SELECT user_id, username, email, 'DELETE' FROM deleted;
END;
GO

-- Test execution
INSERT INTO Users (username, email) VALUES ('temp_chef', 'temp@kitchen.com');
SELECT * FROM Users_Audit_Log;

DELETE FROM Users WHERE username = 'temp_chef';
SELECT * FROM Users_Audit_Log;
GO

CREATE TRIGGER safety_rating_protection
ON Ratings
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Compare state before and after using inserted and deleted context maps
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d ON i.rating_id = d.rating_id
        WHERE i.rating_score < d.rating_score - 2  -- Guard against sudden extreme drops
    )
    BEGIN
        DECLARE @OffendingUser INT;
        SELECT TOP 1 @OffendingUser = i.user_id
        FROM inserted i
        INNER JOIN deleted d ON i.rating_id = d.rating_id
        WHERE i.rating_score < d.rating_score - 2;
        
        RAISERROR('Suspicious rating drop detected. Changes rolled back for User ID: %d', 16, 1, @OffendingUser);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO

SELECT 
    name AS trigger_name,
    parent_id AS table_object_id,
    type_desc AS trigger_execution_type,
    create_date,
    is_disabled
FROM sys.triggers;
GO