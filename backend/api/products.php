<?php
require_once '../config/database.php';
require_once '../includes/functions.php';

$database = new Database();
$db = $database->getConnection();

$category = isset($_GET['category']) ? $_GET['category'] : 'All';
$query_search = isset($_GET['query']) ? $_GET['query'] : '';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM products WHERE 1=1";
    $params = [];

    if ($category !== 'All') {
        $sql .= " AND category = :category";
        $params[':category'] = $category;
    }

    if (!empty($query_search)) {
        $sql .= " AND (name LIKE :query OR subtitle LIKE :query OR description LIKE :query)";
        $params[':query'] = "%$query_search%";
    }

    $stmt = $db->prepare($sql);
    foreach ($params as $key => $val) {
        $stmt->bindValue($key, $val);
    }
    
    $stmt->execute();
    $products = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Convert boolean values
    foreach ($products as &$product) {
        $product['is_best_seller'] = (bool)$product['is_best_seller'];
        $product['price'] = (float)$product['price'];
        $product['rating'] = (float)$product['rating'];
    }

    sendResponse(true, "Products fetched successfully", $products);
} else {
    sendResponse(false, "Method not allowed", null, 405);
}
?>
