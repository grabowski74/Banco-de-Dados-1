-- Questão 1

CREATE TABLE tarefas(
    id BIGINT,
    descricao TEXT,
    func_resp_cpf CHAR(11),
    prioridade SMALLINT,
    status CHAR(1)
);

INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');
INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');
INSERT INTO tarefas VALUES (null, null, null, null, null);

INSERT INTO tarefas VALUES (2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');
-- Retorno de tela: 'ERROR:  value too long for type character(11)'

INSERT INTO tarefas VALUES (2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');
-- Retorno de tela: 'ERROR:  value too long for type character(1)'

--Questão 2

INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');
-- não retornou erro

-- Questão 3

-- Comandos 3

INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal', '32322525199', 32768, 'A');
-- retorno de tela: ERROR:  smallint out of range

INSERT INTO tarefas VALUES (2147483650, 'limpar janelas da entrada principal', '32333233288', 32769, 'A');
-- retorno de tela: ERROR:  smallint out of range

-- Comandos 4

INSERT INTO tarefas VALUES (2147483651, 'limpar portas do 1o  andar', '32323232911', 32767, 'A');
INSERT INTO tarefas VALUES (2147483652, 'limpar portas do 2o  andar', '32323232911', 32766, 'A');

-- Questão 4

ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
--retorno de tela: ERROR:  column "id" contains null values
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
--retorno de tela: ERROR:  column "descricao" contains null values
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
--retorno de tela: ERROR:  column "func_resp_cpf" contains null values
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
--retorno de tela: ERROR:  column "prioridade" contains null values
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;
--retorno de tela: ERROR:  column "status" contains null values

DELETE FROM tarefas WHERE id IS NULL;

ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;

-- Questão 5

ALTER TABLE tarefas ADD CONSTRAINT tarefas_pkey PRIMARY KEY(id);

-- Comandos 5

INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'A');

INSERT INTO tarefas VALUES (2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A');
--retorno de tela: ERROR:  duplicate key value violates unique constraint "tarefas_pkey"
--                 DETAIL:  Key (id)=(2147483653) already exists.

-- Questão 6

--A)

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_func_cpf_valido CHECK(LENGTH(func_resp_cpf) = 11);

INSERT INTO tarefas VALUES (2147483658, 'limpar portas do 1o andar', '32323232', 2, 'A');
-- retorno de tela: ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_func_cpf_valido"
--                  DETAIL:  Failing row contains (2147483654, limpar portas do 1o andar, 32323232   , 2, A).

INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar', '323232329119', 2, 'A');
-- Retorno de tela: 'ERROR:  value too long for type character(11)'

-- B)

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_Status_possiveis CHECK (status = 'P' OR status = 'E' OR status = 'C');
--retorno de tela: ERROR:  check constraint "tarefas_chk_status_possiveis" is violated by some row

UPDATE tarefas SET status = 'P' WHERE status = 'A';
UPDATE tarefas SET status = 'C' WHERE status = 'F';

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_Status_possiveis CHECK (status = 'P' OR status = 'E' OR status = 'C');

INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar', '32323232911', 2, 'A');
-- ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_status_possiveis"
-- DETAIL:  Failing row contains (2147483653, limpar portas do 1o andar, 32323232911, 2, A).

-- Questão 7

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridade_possiveis CHECK (prioridade >= 0 AND prioridade <=5);
-- ERROR:  check constraint "tarefas_chk_prioridade_possiveis" is violated by some row

DELETE FROM tarefas WHERE prioridade > 5;

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridade_possiveis CHECK (prioridade >= 0 AND prioridade <=5);

INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal', '32322525199', 6, 'A');
-- ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_prioridade_possiveis"
-- DETAIL:  Failing row contains (2147483649, limpar portas da entrada principal, 32322525199, 32767, A).

INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal', '32322525199', -1, 'A');
-- ERROR:  new row for relation "tarefas" violates check constraint "tarefas_chk_prioridade_possiveis"
-- DETAIL:  Failing row contains (2147483649, limpar portas da entrada principal, 32322525199, -1, A).

-- Questão 8

CREATE TABLE funcionario(
    cpf CHAR(11) NOT NULL,
    data_nasc DATE NOT NULL,
    nome TEXT NOT NULL,
    funcao TEXT NOT NULL,
    nivel CHAR(1) NOT NULL,
    superior_cpf CHAR(11),
    CONSTRAINT funcionario_pkey PRIMARY KEY(cpf),
    CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES funcionario(cpf),  
    CONSTRAINT sup_cpf_chk CHECK ((funcao = 'LIMPEZA' AND superior_cpf IS NOT NULL) OR (funcao = 'SUP_LIMPEZA')),
    CONSTRAINT funcionario_chk_nivel_possiveis CHECK (nivel = 'J' OR nivel = 'P' OR nivel = 'S')
);

ALTER TABLE funcionario ADD CONSTRAINT funcionario_chk_cpf_valido CHECK(LENGTH(cpf) = 11);
ALTER TABLE funcionario ADD CONSTRAINT funcionario_chk_sup_cpf_valido CHECK(LENGTH(superior_cpf) = 11);


-- Comandos 6
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-09', 'joao da Silva', 'LIMPEZA', 'J', null);
-- ERROR:  new row for relation "funcionario" violates check constraint "sup_cpf_chk"
-- DETAIL:  Failing row contains (12345678913, 1980-04-09, joao da Silva, LIMPEZA, J, null).

-- Questao 9

-- são executados com sucesso
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('81824805403', '1999-09-21', 'Carla', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('41579614809', '1996-01-30', 'Francisco', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('73696773204', '1983-01-22', 'Ana', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('48842264881', '1981-12-10', 'Joao', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('31836649339', '1979-06-29', 'Francisca', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('63496354429', '1984-09-01', 'Matheus', 'LIMPEZA', 'P', '81824805403');
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('17093123511', '1990-07-05', 'Rafael', 'LIMPEZA', 'S', '41579614809');
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('41193430062', '1991-11-03', 'Santos', 'LIMPEZA', 'J', '41579614809');
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('84773351411', '1978-03-12', 'Darla', 'LIMPEZA', 'J', '48842264881');
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('29394581200', '1995-05-11', 'Everton', 'SUP_LIMPEZA', 'P', NULL);

-- Nao devem ser executadas com sucesso

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES(null, '2000-9-18', 'Samuel', 'SUP_LIMPEZA', 'S', NULL);
-- ERROR:  null value in column "cpf" violates not-null constraint
-- DETAIL:  Failing row contains (null, 2000-09-18, Samuel, SUP_LIMPEZA, S, null).

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('29827235141', '1956-12-2', 'Igor', 'SUP_LIMPEZA', 'A', NULL);
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_nivel_possiveis"
-- DETAIL:  Failing row contains (29827235141, 1956-12-02, Igor, SUP_LIMPEZA, A, null).

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('75931865632', '1984-10-13', 'Alice', 'LIMPEZA', 'S', '98618653225');
-- ERROR:  insert or update on table "funcionario" violates foreign key constraint "funcionario_superior_cpf"
-- DETAIL:  Key (superior_cpf)=(98618653225) is not present in table "funcionario".

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('98618653225', '1969-12-18', 'Paulo', 'SUP_LIMPEZA', 'B', NULL);
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_nivel_possiveis"
-- DETAIL:  Failing row contains (98618653225, 1969-12-18, Paulo, SUP_LIMPEZA, B, null).

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('347427966', '1975-11-29', 'Bianca', 'SUP_LIMPEZA', 'P', NULL);
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_cpf_valido"
-- DETAIL:  Failing row contains (347427966  , 1975-11-29, Bianca, SUP_LIMPEZA, P, null).

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('838555103423', '1979-4-23', 'Yasmin', 'SUP_LIMPEZA', 'P', NULL);
--ERROR:  value too long for type character(11)

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('24515537156', '2006-4-13', 'Sarah', 'LIMPEZA', 'S', '87365247860');
-- ERROR:  insert or update on table "funcionario" violates foreign key constraint "funcionario_superior_cpf"
-- DETAIL:  Key (superior_cpf)=(87365247860) is not present in table "funcionario".

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('71216638217', '1951-10-23', 'Marcos', 'LIMPEZA', 'A', 12345678911);
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_nivel_possiveis"
-- DETAIL:  Failing row contains (71216638217, 1951-10-23, Marcos, LIMPEZA, A, 12345678911).

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('87365247860', '1975-04-10', 'Jorge', 'SUP_LIMPEZA', 'F', NULL);
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_nivel_possiveis"
-- DETAIL:  Failing row contains (87365247860, 1975-04-10, Jorge, SUP_LIMPEZA, F, null).

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('63026119970', '1949-11-10', 'Campelo', 'LIMPEZA', 'p', '87365247860');
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_nivel_possiveis"
-- DETAIL:  Failing row contains (63026119970, 1949-11-10, Campelo, LIMPEZA, p, 87365247860).

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES('98618653225', '1969-12-18', 'Paulo', 'SUP_LIMPEZA', 's', NULL);
-- ERROR:  new row for relation "funcionario" violates check constraint "funcionario_chk_nivel_possiveis"
-- DETAIL:  Failing row contains (98618653225, 1969-12-18, Paulo, SUP_LIMPEZA, s, null).

-- Questao 10

INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES
('32323232955', '1980-11-30', 'Gabriela', 'LIMPEZA', 'S', '41579614809'),
('32323232911', '1985-03-03', 'Maria dos Prazeres', 'LIMPEZA', 'P', '48842264881'),
('98765432111', '1992-10-17', 'Enzo', 'LIMPEZA', 'J', '41579614809'),
('98765432122', '1997-08-21', 'Valentina Roberta', 'LIMPEZA', 'J', '48842264881');

-- Opcao 1
ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE CASCADE;
-- deletou o menor cpf em cascata

DELETE FROM funcionario WHERE cpf = '32323232911';

-- Opcao 2

ALTER TABLE tarefas DROP constraint tarefas_func_resp_cpf_fkey;

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE RESTRICT;

DELETE FROM funcionario WHERE cpf = '98765432111';
-- ERROR:  update or delete on table "funcionario" violates foreign key constraint "tarefas_func_resp_cpf_fkey" on table "tarefas"
-- DETAIL:  Key (cpf)=(98765432111) is still referenced from table "tarefas".

-- Questao 11

ALTER TABLE tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL;
ALTER TABLE tarefas ADD CONSTRAINT func_resp_cpf_chk CHECK((status = 'E' AND func_resp_cpf IS NOT NULL) OR (status = 'P' OR status = 'C'));
ALTER TABLE tarefas DROP constraint tarefas_func_resp_cpf_fkey;

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES funcionario(cpf) ON DELETE SET NULL;

INSERT INTO tarefas VALUES (214743, 'limpar chão do corredor central', null, 0, 'E');
-- ERROR:  new row for relation "tarefas" violates check constraint "func_resp_cpf_chk"
-- DETAIL:  Failing row contains (214743, limpar chão do corredor central, null, 0, E).

DELETE FROM funcionario WHERE cpf='12345678911';
-- ERROR:  update or delete on table "funcionario" violates foreign key constraint "funcionario_superior_cpf" on table "funcionario"
-- DETAIL:  Key (cpf)=(12345678911) is still referenced from table "funcionario".
