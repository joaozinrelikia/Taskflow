<?php

require_once __DIR__ . '/../../src/helpers/response.php';
require_once __DIR__ . '/../../src/helpers/auth.php';
require_once __DIR__ . '/../../config/database.php';

verificar_autenticacao();

$metodo = $_SERVER['REQUEST_METHOD'];

if ($metodo !== 'GET') {
    json_response(405, [
        'mensagem' => 'Método não permitido.'
    ]);
    exit;
}

try {

    $pdo = conectar_banco();

    $sql = '
        SELECT id, nome, email, created_at, updated_at
        FROM users
        ORDER BY id
    ';

    $stmt = $pdo->prepare($sql);

    $stmt->execute();

    $usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);

    json_response(200, [
        'usuarios' => $usuarios
    ]);

} catch (PDOException $e) {

    json_response(500, [
        'mensagem' => 'Erro interno do servidor.'
    ]);

    exit;
}