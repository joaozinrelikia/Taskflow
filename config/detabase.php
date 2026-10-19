<?php

function conectar_banco(): PDO
{
    $host = 'localhost';
    $dbname = 'taskflow';
    $usuario = 'root';
    $senha = '';

    $dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";

    $opcoes = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false
    ];

    return new PDO($dsn, $usuario, $senha, $opcoes);
}