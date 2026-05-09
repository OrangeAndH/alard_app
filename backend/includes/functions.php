<?php

function sendResponse($success, $message = "", $data = null, $code = 200) {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    
    $response = [
        "success" => $success,
        "message" => $message,
        "data" => $data
    ];
    
    echo json_encode($response);
    exit;
}

function getBearerToken() {
    $headers = getallheaders();
    if (isset($headers['Authorization'])) {
        if (preg_match('/Bearer\s(\S+)/', $headers['Authorization'], $matches)) {
            return $matches[1];
        }
    }
    return null;
}

// Simple JWT-like token generator (for demonstration)
function generateToken($user_id) {
    return base64_encode(json_encode(["user_id" => $user_id, "exp" => time() + 3600*24*30]));
}

function validateToken($token) {
    if (!$token) return false;
    $data = json_decode(base64_decode($token), true);
    if (!$data || !isset($data['user_id']) || !isset($data['exp'])) return false;
    if (time() > $data['exp']) return false;
    return $data['user_id'];
}
?>
