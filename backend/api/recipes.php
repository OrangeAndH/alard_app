<?php
require_once '../config/database.php';
require_once '../includes/functions.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $category = isset($_GET['category']) ? $_GET['category'] : 'All';
    
    $sql = "SELECT * FROM recipes WHERE 1=1";
    $params = [];

    if ($category !== 'All') {
        $sql .= " AND category = :category";
        $params[':category'] = $category;
    }

    $stmt = $db->prepare($sql);
    foreach ($params as $key => $val) {
        $stmt->bindValue($key, $val);
    }
    
    $stmt->execute();
    $recipes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($recipes as &$recipe) {
        // Fetch ingredients
        $ing_query = "SELECT ingredient FROM recipe_ingredients WHERE recipe_id = :recipe_id";
        $ing_stmt = $db->prepare($ing_query);
        $ing_stmt->bindValue(":recipe_id", $recipe['id']);
        $ing_stmt->execute();
        $recipe['ingredients'] = $ing_stmt->fetchAll(PDO::FETCH_COLUMN);

        // Fetch steps
        $step_query = "SELECT step_number, step_description FROM recipe_steps WHERE recipe_id = :recipe_id ORDER BY step_number";
        $step_stmt = $db->prepare($step_query);
        $step_stmt->bindValue(":recipe_id", $recipe['id']);
        $step_stmt->execute();
        $recipe['steps'] = $step_stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    sendResponse(true, "Recipes fetched successfully", $recipes);
}
?>
