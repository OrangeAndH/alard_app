-- Al'Ard App Database Schema

CREATE DATABASE IF NOT EXISTS alard_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE alard_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    location VARCHAR(255),
    is_trader BOOLEAN DEFAULT FALSE,
    profile_image TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    rating DECIMAL(3, 2) DEFAULT 4.7,
    category VARCHAR(100),
    image TEXT,
    is_best_seller BOOLEAN DEFAULT FALSE,
    description TEXT,
    weight VARCHAR(50),
    unit_case VARCHAR(50),
    case_layer VARCHAR(50),
    upc VARCHAR(50),
    catalog_page INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT,
    customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    delivery_address TEXT NOT NULL,
    mailbox_address TEXT,
    note TEXT,
    payment_method VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'Processing',
    subtotal DECIMAL(10, 2) NOT NULL,
    delivery DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    product_name VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    image TEXT,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
);

-- Shipping Addresses Table
CREATE TABLE IF NOT EXISTS shipping_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    title VARCHAR(100) NOT NULL,
    details TEXT NOT NULL,
    mailbox_address TEXT,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Payment Methods Table
CREATE TABLE IF NOT EXISTS payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    title VARCHAR(100) NOT NULL,
    subtitle VARCHAR(255),
    is_default BOOLEAN DEFAULT FALSE,
    is_cash_on_delivery BOOLEAN DEFAULT FALSE,
    card_holder_name VARCHAR(255),
    card_number VARCHAR(20),
    expiry_month VARCHAR(2),
    expiry_year VARCHAR(4),
    cvv VARCHAR(4),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Feedback Table
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    feedback_text TEXT NOT NULL,
    rating INT DEFAULT 5,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Recipes Table
CREATE TABLE IF NOT EXISTS recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    image TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Recipe Ingredients
CREATE TABLE IF NOT EXISTS recipe_ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT,
    ingredient TEXT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
);

-- Recipe Steps
CREATE TABLE IF NOT EXISTS recipe_steps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT,
    step_number INT NOT NULL,
    step_description TEXT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
);

-- Initial Data for Products
INSERT INTO products (id, name, subtitle, price, rating, category, image, is_best_seller) VALUES
('olive-oil-1l', 'prod_name_oil_1l', 'prod_sub_oil_1l', 15.00, 4.9, 'Olive Oil', 'assets/virgin_oil.png', TRUE),
('zaatar-1kg', 'prod_name_zaatar_1kg', 'prod_sub_zaatar_1kg', 10.00, 4.8, 'Herbs & Spices', 'assets/Zaata.png', FALSE),
('dried-sage-100g', 'prod_name_sage_100g', 'prod_sub_sage_100g', 4.00, 4.7, 'Herbs & Spices', 'assets/Dried_sage.png', FALSE),
('green-olives-220g', 'prod_name_olives_220g', 'prod_sub_olives_220g', 4.00, 4.6, 'Pickles', 'assets/green_olive.png', TRUE);
