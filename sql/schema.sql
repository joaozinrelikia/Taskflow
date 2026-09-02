-- TaskFlow - schema inicial do banco de dados
-- PostgreSQL

CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       nome VARCHAR(100) NOT NULL,
                       email VARCHAR(150) NOT NULL UNIQUE,
                       senha_hash VARCHAR(255) NOT NULL,
                       created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                       updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE projects (
                          id SERIAL PRIMARY KEY,
                          nome VARCHAR(150) NOT NULL,
                          descricao TEXT,
                          status VARCHAR(20) NOT NULL DEFAULT 'ativo',
                          user_id INTEGER NOT NULL,
                          created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                          updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

                          CONSTRAINT chk_projects_status
                              CHECK (status IN ('ativo', 'arquivado')),
                          CONSTRAINT fk_projects_user
                              FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE tasks (
                       id SERIAL PRIMARY KEY,
                       titulo VARCHAR(200) NOT NULL,
                       descricao TEXT,
                       status VARCHAR(20) NOT NULL DEFAULT 'pendente',
                       prioridade VARCHAR(10) NOT NULL DEFAULT 'media',
                       data_inicio DATE,
                       data_prazo DATE,
                       project_id INTEGER NOT NULL,
                       user_id INTEGER NOT NULL,
                       created_at TIMESTAMP NOT NULL DEFAULT NOW(),
                       updated_at TIMESTAMP NOT NULL DEFAULT NOW(),

                       CONSTRAINT chk_tasks_status
                           CHECK (status IN ('pendente', 'em_andamento', 'concluido')),
                       CONSTRAINT chk_tasks_prioridade
                           CHECK (prioridade IN ('baixa', 'media', 'alta')),
                       CONSTRAINT chk_tasks_datas
                           CHECK (data_prazo IS NULL OR data_inicio IS NULL
                               OR data_prazo >= data_inicio),
                       CONSTRAINT fk_tasks_project
                           FOREIGN KEY (project_id) REFERENCES projects(id),
                       CONSTRAINT fk_tasks_user
                           FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO users (nome, email, senha_hash)
VALUES
    ('Ana Souza', 'ana@taskflow.com', 'hash_teste_ana'),
    ('Bruno Lima', 'bruno@taskflow.com', 'hash_teste_bruno');

SELECT id, nome, email, created_at
FROM users
ORDER BY id;

INSERT INTO projects (nome, descricao, user_id)
VALUES
    ('Projeto Integrador', 'Organização das entregas do semestre', 1),
    ('Portfólio Web', 'Construção do portfólio profissional', 2);


SELECT id, nome, status, user_id
FROM projects
ORDER BY id;

INSERT INTO tasks
(titulo, descricao, status, prioridade,
 data_inicio, data_prazo, project_id, user_id)
VALUES
    ('Modelar banco de dados',
     'Criar o diagrama entidade-relacionamento',
     'concluido', 'alta', '2026-08-20', '2026-08-22', 1, 1),
    ('Criar schema SQL',
     'Implementar as tabelas do TaskFlow',
     'em_andamento', 'alta', '2026-08-23', '2026-08-28', 1, 2),
    ('Criar página inicial',
     'Montar a estrutura HTML da aplicação',
     'pendente', 'media', '2026-08-29', '2026-09-05', 1, 1),
    ('Atualizar apresentação pessoal',
     'Revisar informações do portfólio',
     'pendente', 'baixa', '2026-08-26', '2026-09-10', 2, 2);
SELECT id, titulo, status, prioridade, project_id, user_id
FROM tasks
ORDER BY id;

INSERT INTO tasks (titulo, project_id, user_id)
VALUES ('Tarefa temporária', 1, 1)
    RETURNING id, titulo, status, prioridade;

SELECT id, titulo, status, prioridade, data_prazo
FROM tasks
WHERE status <> 'concluido'
ORDER BY data_prazo;

UPDATE tasks
SET status = 'concluido',
    updated_at = NOW()
WHERE titulo = 'Criar schema SQL';
SELECT titulo, status, updated_at
FROM tasks
WHERE titulo = 'Criar schema SQL';

DELETE FROM tasks
WHERE titulo = 'Tarefa temporária';
SELECT id, titulo
FROM tasks
ORDER BY id;

SELECT
    t.id,
    t.titulo AS tarefa,
    p.nome AS projeto,
    u.nome AS responsavel,
    t.status,
    t.prioridade,
    t.data_prazo
FROM tasks AS t
         INNER JOIN projects AS p
                    ON p.id = t.project_id
         INNER JOIN users AS u
                    ON u.id = t.user_id
ORDER BY p.nome, t.data_prazo;

SELECT
    t.titulo AS tarefa,
    p.nome AS projeto,
    u.nome AS responsavel,
    t.status
FROM tasks AS t
         INNER JOIN projects AS p ON p.id = t.project_id
         INNER JOIN users AS u ON u.id = t.user_id
WHERE t.prioridade = 'alta'
  AND t.status <> 'concluido'
ORDER BY t.data_prazo;

INSERT INTO users (nome, email, senha_hash)
VALUES ('Outra Ana', 'ana@taskflow.com', 'hash_teste');

INSERT INTO users (nome, email, senha_hash)
VALUES (NULL, 'teste@taskflow.com', 'hash_teste');

INSERT INTO projects (nome, status, user_id)
VALUES ('Projeto inválido', 'cancelado', 1);

INSERT INTO projects (nome, user_id)
VALUES ('Projeto sem dono', 99999);

INSERT INTO tasks
(titulo, data_inicio, data_prazo, project_id, user_id)
VALUES
    ('Datas inválidas', '2026-09-10', '2026-09-01', 1, 1);