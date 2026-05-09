<?php
require_once '../config/database.php';
require_once '../includes/functions.php';

$database = new Database();
$db = $database->getConnection();

$action = isset($_GET['action']) ? $_GET['action'] : '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));

    if ($action === 'register') {
        if (empty($data->name) || empty($data->email) || empty($data->password)) {
            sendResponse(false, "Please fill all fields", null, 400);
        }

        // Check if user exists
        $query = "SELECT id FROM users WHERE email = :email";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":email", $data->email);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            sendResponse(false, "User already exists with this email", null, 400);
        }

        // Create user
        $query = "INSERT INTO users (name, email, password, phone, location, is_trader) 
                  VALUES (:name, :email, :password, :phone, :location, :is_trader)";
        $stmt = $db->prepare($query);

        $password_hash = password_hash($data->password, PASSWORD_BCRYPT);
        $is_trader = isset($data->is_trader) ? $data->is_trader : false;

        $stmt->bindParam(":name", $data->name);
        $stmt->bindParam(":email", $data->email);
        $stmt->bindParam(":password", $password_hash);
        $stmt->bindParam(":phone", $data->phone);
        $stmt->bindParam(":location", $data->location);
        $stmt->bindParam(":is_trader", $is_trader, PDO::PARAM_BOOL);

        if ($stmt->execute()) {
            $user_id = $db->lastInsertId();
            $token = generateToken($user_id);
            sendResponse(true, "Registration successful", ["token" => $token, "user_id" => $user_id]);
        } else {
            sendResponse(false, "Registration failed", null, 500);
        }
    } 
    
    elseif ($action === 'login') {
        if (empty($data->email) || empty($data->password)) {
            sendResponse(false, "Please provide email and password", null, 400);
        }

        $query = "SELECT id, name, email, password, is_trader FROM users WHERE email = :email";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":email", $data->email);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            if (password_verify($data->password, $row['password'])) {
                $token = generateToken($row['id']);
                unset($row['password']);
                sendResponse(true, "Login successful", ["token" => $token, "user" => $row]);
            } else {
                sendResponse(false, "Invalid password", null, 401);
            }
        } else {
            sendResponse(false, "User not found", null, 404);
        }
    }
} else {
    sendResponse(false, "Method not allowed", null, 405);
}
?>
