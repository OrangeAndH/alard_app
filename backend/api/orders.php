<?php
require_once '../config/database.php';
require_once '../includes/functions.php';

$database = new Database();
$db = $database->getConnection();

$user_id = validateToken(getBearerToken());

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));

    if (empty($data->customer_name) || empty($data->items)) {
        sendResponse(false, "Invalid order data", null, 400);
    }

    try {
        $db->beginTransaction();

        $order_id = "#" . (1000 + rand(1, 9000)); // Simple ID generation
        
        $query = "INSERT INTO orders (id, user_id, customer_name, phone, delivery_address, mailbox_address, note, payment_method, status, subtotal, delivery, total) 
                  VALUES (:id, :user_id, :customer_name, :phone, :delivery_address, :mailbox_address, :note, :payment_method, :status, :subtotal, :delivery, :total)";
        
        $stmt = $db->prepare($query);
        $stmt->bindValue(":id", $order_id);
        $stmt->bindValue(":user_id", $user_id);
        $stmt->bindValue(":customer_name", $data->customer_name);
        $stmt->bindValue(":phone", $data->phone);
        $stmt->bindValue(":delivery_address", $data->delivery_address);
        $stmt->bindValue(":mailbox_address", $data->mailbox_address);
        $stmt->bindValue(":note", $data->note);
        $stmt->bindValue(":payment_method", $data->payment_method);
        $stmt->bindValue(":status", "Processing");
        $stmt->bindValue(":subtotal", $data->subtotal);
        $stmt->bindValue(":delivery", $data->delivery);
        $stmt->bindValue(":total", $data->total);
        $stmt->execute();

        foreach ($data->items as $item) {
            $item_query = "INSERT INTO order_items (order_id, product_id, product_name, subtitle, image, price, quantity) 
                           VALUES (:order_id, :product_id, :product_name, :subtitle, :image, :price, :quantity)";
            $item_stmt = $db->prepare($item_query);
            $item_stmt->bindValue(":order_id", $order_id);
            $item_stmt->bindValue(":product_id", $item->product_id);
            $item_stmt->bindValue(":product_name", $item->product_name);
            $item_stmt->bindValue(":subtitle", $item->subtitle);
            $item_stmt->bindValue(":image", $item->image);
            $item_stmt->bindValue(":price", $item->price);
            $item_stmt->bindValue(":quantity", $item->quantity);
            $item_stmt->execute();
        }

        $db->commit();
        sendResponse(true, "Order placed successfully", ["order_id" => $order_id]);

    } catch (Exception $e) {
        $db->rollBack();
        sendResponse(false, "Order placement failed: " . $e->getMessage(), null, 500);
    }
} 

elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!$user_id) {
        sendResponse(false, "Unauthorized", null, 401);
    }

    $query = "SELECT * FROM orders WHERE user_id = :user_id ORDER BY order_date DESC";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":user_id", $user_id);
    $stmt->execute();
    $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($orders as &$order) {
        $item_query = "SELECT * FROM order_items WHERE order_id = :order_id";
        $item_stmt = $db->prepare($item_query);
        $item_stmt->bindParam(":order_id", $order['id']);
        $item_stmt->execute();
        $order['items'] = $item_stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    sendResponse(true, "Orders fetched successfully", $orders);
}
?>
