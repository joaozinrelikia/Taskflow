<?php

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../src/helpers/response.php';
require_once __DIR__ . '/../../src/helpers/validate.php';

session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(405, [
        'mensagem' => 'Método não permitido.'
    ]);
    exit;
}

$dados = json_decode(file_get_contents('php://input'), true);

try {
    // Validar os dados do login
    $erros = validar_login($dados);

    if (!empty($erros)) {
        json_response(422, [
            'mensagem' => 'Dados inválidos.',
            'erros' => $erros
        ]);
        exit;
    }

    $email = trim($dados['email']);
    $senha = $dados['senha'];

    // Conectar ao banco
    $pdo = conectar_banco();

    // Buscar usuário pelo e-mail
    $stmt = $pdo->prepare(
        'SELECT id, nome, email, senha_hash
         FROM users
         WHERE email = :email
         LIMIT 1'
    );

    $stmt->execute([
        ':email' => $email
    ]);

    $usuario = $stmt->fetch();

    // Verificar usuário e senha
    if (
        !$usuario ||
        !password_verify($senha, $usuario['senha_hash'])
    ) {
        json_response(401, [
            'mensagem' => 'Credenciais inválidas.'
        ]);
        exit;
    }

    // Salvar somente depois de confirmar a senha
    $_SESSION['usuario_id'] = $usuario['id'];
    $_SESSION['usuario_nome'] = $usuario['nome'];

    // Responder sucesso sem retornar senha_hash
    json_response(200, [
        'mensagem' => 'Login realizado com sucesso.',
        'usuario' => [
            'id' => $usuario['id'],
            'nome' => $usuario['nome'],
            'email' => $usuario['email']
        ]
    ]);

} catch (PDOException $e) {
    json_response(500, [
        'mensagem' => 'Erro interno do servidor.'
    ]);
    exit;
}