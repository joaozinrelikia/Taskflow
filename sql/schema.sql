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


INSERT INTO projects (nome, descricao, user_id)
VALUES
    ('Projeto Integrador', 'Organização das entregas do semestre', 1),
    ('Portfólio Web', 'Construção do portfólio profissional', 2);




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