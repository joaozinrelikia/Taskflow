<?php

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../src/helpers/response.php';
require_once __DIR__ . '/../../src/helpers/validate.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(405, [
        'mensagem' => 'Método não permitido.'
    ]);
    exit;
}

$dados = json_decode(file_get_contents('php://input'), true);

try {
    // Validar os dados recebidos
    $erros = validar_cadastro($dados);

    if (!empty($erros)) {
        json_response(422, [
            'mensagem' => 'Dados inválidos.',
            'erros' => $erros
        ]);
        exit;
    }

    $nome = trim($dados['nome']);
    $email = trim($dados['email']);
    $senha = $dados['senha'];

    // Conectar ao banco
    $pdo = conectar_banco();

    // Verificar se o e-mail já existe
    $stmt = $pdo->prepare(
        'SELECT id FROM users WHERE email = :email LIMIT 1'
    );

    $stmt->execute([
        ':email' => $email
    ]);

    if ($stmt->fetch()) {
        json_response(409, [
            'mensagem' => 'Este e-mail já está cadastrado.'
        ]);
        exit;
    }

    // Gerar hash da senha
    $senhaHash = password_hash($senha, PASSWORD_DEFAULT);

    // Inserir usuário
    $stmt = $pdo->prepare(
        'INSERT INTO users (nome, email, senha_hash)
         VALUES (:nome, :email, :senha_hash)'
    );

    $stmt->execute([
        ':nome' => $nome,
        ':email' => $email,
        ':senha_hash' => $senhaHash
    ]);

    json_response(201, [
        'mensagem' => 'Users cadastrado com sucesso.'
    ]);

} catch (PDOException $e) {
    json_response(500, [
        'mensagem' => 'Erro interno do servidor.'
    ]);
    exit;
}