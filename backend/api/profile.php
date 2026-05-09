<?php
require_once '../config/database.php';
require_once '../includes/functions.php';

$database = new Database();
$db = $database->getConnection();

$user_id = validateToken(getBearerToken());

if (!$user_id) {
    sendResponse(false, "Unauthorized", null, 401);
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $query = "SELECT id, name, email, phone, location, is_trader, profile_image FROM users WHERE id = :id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":id", $user_id);
    $stmt->execute();
    
    if ($stmt->rowCount() > 0) {
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        $user['is_trader'] = (bool)$user['is_trader'];
        sendResponse(true, "Profile fetched successfully", $user);
    } else {
        sendResponse(false, "User not found", null, 404);
    }
} 

elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));

    if (empty($data->name) || empty($data->email)) {
        sendResponse(false, "Name and email are required", null, 400);
    }

    $query = "UPDATE users SET name = :name, email = :email, phone = :phone, location = :location WHERE id = :id";
    $stmt = $db->prepare($query);
    $stmt->bindValue(":name", $data->name);
    $stmt->bindValue(":email", $data->email);
    $stmt->bindValue(":phone", $data->phone);
    $stmt->bindValue(":location", $data->location);
    $stmt->bindValue(":id", $user_id);

    if ($stmt->execute()) {
        sendResponse(true, "Profile updated successfully");
    } else {
        sendResponse(false, "Failed to update profile", null, 500);
    }
}
?>
