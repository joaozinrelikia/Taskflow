<?php

function json_response(int $status, array $dados): void
{
    http_response_code($status);

    header('Content-Type: application/json; charset=utf-8');

    echo json_encode($dados, JSON_UNESCAPED_UNICODE);
}