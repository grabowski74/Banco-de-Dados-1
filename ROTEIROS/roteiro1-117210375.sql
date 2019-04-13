-- questao 1 and Questao 2

CREATE TABLE Perito(
P_nome TEXT,
P_cpf INTEGER NOT NULL,
P_telefone INTEGER NOT NULL,
P_endereco TEXT,
P_CEP INTEGER NOT NULL,
P_data_nascimento INTEGER,
P_id varchar(10),
CONSTRAINT Perito_pkey PRIMARY KEY(P_id));

CREATE TABLE Oficina(
O_nome_Fantasia TEXT,
O_razao_social TEXT NOT NULL,
O_cnpj INTEGER,
O_telefone INTEGER,
O_endereco TEXT,
O_CEP INTEGER NOT NULL,
CONSTRAINT Oficina_pkey PRIMARY KEY(O_cnpj));

CREATE TABLE Segurado(
S_nome TEXT,
S_cpf INTEGER,
S_sexo TEXT,
S_telefone INTEGER,
S_endereco TEXT,
S_CEP INTEGER NOT NULL,
S_data_nascimento DATE,
S_classe_bonus INTEGER NOT NULL,
CONSTRAINT Segurado_pkey PRIMARY KEY(S_cpf));

CREATE TABLE Automoveis (
A_placa varchar(8),
A_fabricante text,
A_modelo text,
A_num_Chassi varchar(17) NOT NULL,
A_ano_Fabricacao Integer,
A_estado text,
A_tabela_FIPE Integer,
A_seguroID VARCHAR(10),
CONSTRAINT Automoveis_pkey PRIMARY KEY(A_placa));

CREATE TABLE Seguro (
SE_id varchar(10),
SE_data DATE,
SE_Segurado INTEGER,
SE_placa varchar(8) REFERENCES Automoveis(A_placa),
SE_pago NUMERIC,
SE_valor_apolice_sinistro NUMERIC,
SE_valor_apolice_vidros NUMERIC,
SE_valor_apolice_farol NUMERIC,
SE_valor_terceiros NUMERIC,
SE_condutores TEXT,
CONSTRAINT Seguro_pkey PRIMARY KEY(SE_id),
CONSTRAINT Seguro_SE_Segurado FOREIGN KEY (SE_Segurado) REFERENCES Segurado(S_cpf),
CONSTRAINT Seguro_SE_placa FOREIGN KEY (SE_placa) REFERENCES Automoveis(A_placa));

CREATE TABLE Sinistro (
SI_id VARCHAR(10),
SI_data_ocorrencia TIMESTAMP,
SI_veiculo VARCHAR(8) REFERENCES Automoveis(A_placa),
SI_seguro VARCHAR(10) REFERENCES Seguro(SE_id),
SI_Condutor TEXT,
SI_vitimas BOOLEAN,
SI_terceiros BOOLEAN,
SI_Depoimento TEXT,
CONSTRAINT Sinistro_pkey PRIMARY KEY(SI_id));

CREATE TABLE Pericia (
PER_id VARCHAR(10),
PER_sinistro_id VARCHAR(10) REFERENCES Sinistro(SI_id),
PER_perito VARCHAR(10) REFERENCES Perito(P_id),
PER_veiculo VARCHAR(8) REFERENCES Automoveis(A_placa),
PER_Descricao TEXT,
CONSTRAINT Pericia_pkey PRIMARY KEY(PER_id));

CREATE TABLE Reparo(
R_id VARCHAR(10) NOT NULL,
R_data_entrada TIMESTAMP,
R_pericia_id VARCHAR(10) REFERENCES Pericia(PER_id),
R_veiculo VARCHAR(10) REFERENCES Automoveis(A_placa),
R_oficina INTEGER REFERENCES Oficina(O_cnpj),
R_orcamento NUMERIC,
R_descricao TEXT,
CONSTRAINT Reparo_pkey PRIMARY KEY(R_id));

-- Questao 2
-- não foram nescessarios altecoes de acordo com
-- a modelagem que usei.
--
-- Questao 4
-- as tabelas ja foram criadas com as referencias
-- de chaves estrangeiras.
--
-- Questao 5
-- Tentei fazer isso na criacao das tabelas.
--
-- Questao 6, 7, 8 and 9
--
-- passos pulados, pois as tabelas foram criadas com as
-- CONSTRAINTs, com isso nao é possivel fazer a remocao
-- qualquer ordem.

DROP TABLE Automoveis;

-- retorno de tela "ERROR:  cannot drop table automoveis because other objects depend on it
-- DETAIL:  constraint seguro_se_placa_fkey on table seguro depends on table automoveis
-- constraint sinistro_si_veiculo_fkey on table sinistro depends on table automoveis
-- constraint pericia_per_veiculo_fkey on table pericia depends on table automoveis
-- constraint reparo_r_veiculo_fkey on table reparo depends on table automoveis
-- HINT:  Use DROP ... CASCADE to drop the dependent objects too.".
--
-- Questao 10
 
-- como foi discutido em sala pensei na criacao de outras tabelas que achei nescessarias 
-- como, por exemplo, tabela de dependentes e tabela de pericias inicias. Porem como discutido
-- tambem em sala essa modelagem tem o intuito de ser simples e adicao de outras tabelas deixa
-- a modelagem mais complexa e faz surgir outras problematicas.