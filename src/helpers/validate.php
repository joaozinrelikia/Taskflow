<?php

function validar_cadastro(array $dados): array
{
    $erros = [];

    // Validar nome obrigatório e remover espaços extras
    $nome = trim($dados['nome'] ?? '');

    if ($nome === '') {
        $erros['nome'] = 'O nome é obrigatório.';
    }

    // Validar e-mail com FILTER_VALIDATE_EMAIL
    $email = trim($dados['email'] ?? '');

    if ($email === '') {
        $erros['email'] = 'O e-mail é obrigatório.';
    } elseif (filter_var($email, FILTER_VALIDATE_EMAIL) === false) {
        $erros['email'] = 'O e-mail é inválido.';
    }

    // Validar senha
    $senha = $dados['senha'] ?? '';

    if ($senha === '') {
        $erros['senha'] = 'A senha é obrigatória.';
    } elseif (strlen($senha) < 8) {
        $erros['senha'] = 'A senha deve ter no mínimo 8 caracteres.';
    }

    return $erros;
}

function validar_login(array $dados): array
{
    $erros = [];

    // Login precisa somente de e-mail e senha
    $email = trim($dados['email'] ?? '');
    $senha = $dados['senha'] ?? '';

    if ($email === '') {
        $erros['email'] = 'O e-mail é obrigatório.';
    }

    if ($senha === '') {
        $erros['senha'] = 'A senha é obrigatória.';
    }

    return $erros;
}