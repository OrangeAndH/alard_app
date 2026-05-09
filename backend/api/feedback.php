<?php
require_once '../config/database.php';
require_once '../includes/functions.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $user_id = validateToken(getBearerToken());

    if (empty($data->feedback_text) || empty($data->name)) {
        sendResponse(false, "Please provide your name and feedback", null, 400);
    }

    $query = "INSERT INTO feedback (user_id, name, country, feedback_text, rating) 
              VALUES (:user_id, :name, :country, :feedback_text, :rating)";
    $stmt = $db->prepare($query);
    $stmt->bindValue(":user_id", $user_id);
    $stmt->bindValue(":name", $data->name);
    $stmt->bindValue(":country", $data->country);
    $stmt->bindValue(":feedback_text", $data->feedback_text);
    $stmt->bindValue(":rating", $data->rating);

    if ($stmt->execute()) {
        sendResponse(true, "Feedback submitted successfully");
    } else {
        sendResponse(false, "Failed to submit feedback", null, 500);
    }
} 

elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $country = isset($_GET['country']) ? $_GET['country'] : 'All';
    
    $sql = "SELECT * FROM feedback WHERE 1=1";
    $params = [];

    if ($country !== 'All') {
        $sql .= " AND country = :country";
        $params[':country'] = $country;
    }

    $sql .= " ORDER BY date DESC";

    $stmt = $db->prepare($sql);
    foreach ($params as $key => $val) {
        $stmt->bindValue($key, $val);
    }
    
    $stmt->execute();
    $feedbacks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    sendResponse(true, "Feedback fetched successfully", $feedbacks);
}
?>
