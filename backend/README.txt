Al'Ard App Backend (PHP)
========================

This is the backend for the Al'Ard Flutter application.

Structure:
----------
- /api: Contains the REST API endpoints.
- /config: Database connection configuration.
- /includes: Helper functions.
- /models: Database models (can be expanded).
- database.sql: SQL script to initialize the database.

Setup Instructions:
-------------------
1. Install a local PHP server environment like XAMPP, WAMP, or MAMP.
2. Open phpMyAdmin (usually at http://localhost/phpmyadmin).
3. Create a new database named `alard_db`.
4. Import the `database.sql` file provided in this folder into the `alard_db` database.
5. Move the entire `backend` folder to your server's root directory (e.g., `C:/xampp/htdocs/backend`).
6. Update `config/database.php` if your database username or password is different from the default (root/empty).

API Endpoints:
--------------
- Auth:
  - POST api/auth.php?action=register (Name, Email, Password, etc.)
  - POST api/auth.php?action=login (Email, Password)
- Products:
  - GET api/products.php (Optional: ?category=..., ?query=...)
- Orders:
  - POST api/orders.php (Requires Bearer Token)
  - GET api/orders.php (Requires Bearer Token)
- Feedback:
  - POST api/feedback.php (Requires Bearer Token for user_id, otherwise name/feedback)
  - GET api/feedback.php (Optional: ?country=...)
- Recipes:
  - GET api/recipes.php (Optional: ?category=...)
- Profile:
  - GET api/profile.php (Requires Bearer Token)
  - POST api/profile.php (Requires Bearer Token)

Note:
-----
This backend is designed to handle all the data requirements of the Al'Ard app.
The Flutter application should be updated in the future to point to these endpoints instead of using local simulation.
