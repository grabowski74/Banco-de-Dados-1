--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_vendedor_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_produto_receita_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_clienteid_fkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_farmaciaid_fkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_gerente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_vendaid_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_enderecoid_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_clienteid_fkey;
ALTER TABLE ONLY public.enderecos DROP CONSTRAINT enderecos_clienteid_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_venid_pkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_clienteid_un;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_venda_uni;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_medid_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_funcao_uni;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_cpf_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_tipo_ex;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_id_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_gerente_un;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_bairro_un;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_entregaid_un;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_entregaid_pkey;
ALTER TABLE ONLY public.enderecos DROP CONSTRAINT enderecos_endeid_pkey;
ALTER TABLE ONLY public.enderecos DROP CONSTRAINT enderecos_clienteid_un;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_clienteid_pkey;
ALTER TABLE public.vendas ALTER COLUMN venid DROP DEFAULT;
ALTER TABLE public.medicamentos ALTER COLUMN medid DROP DEFAULT;
ALTER TABLE public.farmacias ALTER COLUMN fa_id DROP DEFAULT;
ALTER TABLE public.entregas ALTER COLUMN entregaid DROP DEFAULT;
ALTER TABLE public.enderecos ALTER COLUMN endeid DROP DEFAULT;
ALTER TABLE public.clientes ALTER COLUMN clienteid DROP DEFAULT;
DROP SEQUENCE public.vendas_venid_seq;
DROP TABLE public.vendas;
DROP SEQUENCE public.medicamentos_medid_seq;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP SEQUENCE public.farmacias_fa_id_seq;
DROP TABLE public.farmacias;
DROP SEQUENCE public.entregas_entregaid_seq;
DROP TABLE public.entregas;
DROP SEQUENCE public.enderecos_endeid_seq;
DROP TABLE public.enderecos;
DROP SEQUENCE public.clientes_clienteid_seq;
DROP TABLE public.clientes;
DROP TYPE public.funcao_fun;
DROP TYPE public.estado_ne;
DROP TYPE public.address_tipo;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: address_tipo; Type: TYPE; Schema: public; Owner: eduardo
--

CREATE TYPE public.address_tipo AS ENUM (
    'RESIDENCIA',
    'TRABALHO',
    'OUTRO'
);


ALTER TYPE public.address_tipo OWNER TO eduardo;

--
-- Name: estado_ne; Type: TYPE; Schema: public; Owner: eduardo
--

CREATE TYPE public.estado_ne AS ENUM (
    'PB',
    'PE',
    'RN',
    'BA',
    'CE',
    'PI',
    'SE',
    'AL',
    'MA'
);


ALTER TYPE public.estado_ne OWNER TO eduardo;

--
-- Name: funcao_fun; Type: TYPE; Schema: public; Owner: eduardo
--

CREATE TYPE public.funcao_fun AS ENUM (
    'FARMACEUTICO',
    'VENDEDOR',
    'ENTREGADOR',
    'CAIXA',
    'ADMINISTRADOR'
);


ALTER TYPE public.funcao_fun OWNER TO eduardo;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: eduardo
--

CREATE TABLE public.clientes (
    clienteid integer NOT NULL,
    nome character varying(50) NOT NULL,
    data_nasc date NOT NULL,
    CONSTRAINT clientes_chk_clienteid_valido CHECK ((clienteid > 0)),
    CONSTRAINT clientes_idade_min_chk CHECK ((date_part('year'::text, age((data_nasc)::timestamp with time zone)) >= (18)::double precision))
);


ALTER TABLE public.clientes OWNER TO eduardo;

--
-- Name: clientes_clienteid_seq; Type: SEQUENCE; Schema: public; Owner: eduardo
--

CREATE SEQUENCE public.clientes_clienteid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientes_clienteid_seq OWNER TO eduardo;

--
-- Name: clientes_clienteid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardo
--

ALTER SEQUENCE public.clientes_clienteid_seq OWNED BY public.clientes.clienteid;


--
-- Name: enderecos; Type: TABLE; Schema: public; Owner: eduardo
--

CREATE TABLE public.enderecos (
    endeid integer NOT NULL,
    clienteid integer NOT NULL,
    tipo_endereco public.address_tipo NOT NULL,
    estado public.estado_ne NOT NULL,
    cidade character varying(20) NOT NULL,
    bairro character varying(20) NOT NULL,
    rua character varying(70) NOT NULL,
    CONSTRAINT enderecos_chk_endeid_valido CHECK ((endeid > 0))
);


ALTER TABLE public.enderecos OWNER TO eduardo;

--
-- Name: enderecos_endeid_seq; Type: SEQUENCE; Schema: public; Owner: eduardo
--

CREATE SEQUENCE public.enderecos_endeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enderecos_endeid_seq OWNER TO eduardo;

--
-- Name: enderecos_endeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardo
--

ALTER SEQUENCE public.enderecos_endeid_seq OWNED BY public.enderecos.endeid;


--
-- Name: entregas; Type: TABLE; Schema: public; Owner: eduardo
--

CREATE TABLE public.entregas (
    entregaid integer NOT NULL,
    vendaid integer NOT NULL,
    clienteid integer NOT NULL,
    enderecoid integer NOT NULL,
    CONSTRAINT vendas_chk_entregaid_valido CHECK ((entregaid > 0))
);


ALTER TABLE public.entregas OWNER TO eduardo;

--
-- Name: entregas_entregaid_seq; Type: SEQUENCE; Schema: public; Owner: eduardo
--

CREATE SEQUENCE public.entregas_entregaid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregas_entregaid_seq OWNER TO eduardo;

--
-- Name: entregas_entregaid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardo
--

ALTER SEQUENCE public.entregas_entregaid_seq OWNED BY public.entregas.entregaid;


--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: eduardo
--

CREATE TABLE public.farmacias (
    fa_id integer NOT NULL,
    nome character varying(50) NOT NULL,
    bairro character varying(20) NOT NULL,
    cidade character varying(20) NOT NULL,
    estado public.estado_ne NOT NULL,
    gerente character(11) NOT NULL,
    gerente_fun public.funcao_fun NOT NULL,
    tipo_loja character(1) NOT NULL,
    CONSTRAINT farmacias_chk_fa_id_valido CHECK ((fa_id > 0)),
    CONSTRAINT farmacias_gerente_fun_chk CHECK (((gerente_fun = 'FARMACEUTICO'::public.funcao_fun) OR (gerente_fun = 'ADMINISTRADOR'::public.funcao_fun))),
    CONSTRAINT farmacias_tipo_chk CHECK (((tipo_loja = 'S'::bpchar) OR (tipo_loja = 'F'::bpchar)))
);


ALTER TABLE public.farmacias OWNER TO eduardo;

--
-- Name: farmacias_fa_id_seq; Type: SEQUENCE; Schema: public; Owner: eduardo
--

CREATE SEQUENCE public.farmacias_fa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacias_fa_id_seq OWNER TO eduardo;

--
-- Name: farmacias_fa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardo
--

ALTER SEQUENCE public.farmacias_fa_id_seq OWNED BY public.farmacias.fa_id;


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: eduardo
--

CREATE TABLE public.funcionarios (
    cpf character(11) NOT NULL,
    nome text NOT NULL,
    funcao public.funcao_fun NOT NULL,
    farmaciaid integer,
    CONSTRAINT funcionarios_chk_cpf_valido CHECK ((length(cpf) = 11)),
    CONSTRAINT funcionarios_chk_farmciaid_valido CHECK ((farmaciaid > 0))
);


ALTER TABLE public.funcionarios OWNER TO eduardo;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: eduardo
--

CREATE TABLE public.medicamentos (
    medid integer NOT NULL,
    nome character varying(50) NOT NULL,
    prin_ativo character varying(50) NOT NULL,
    venda_exclusiva boolean NOT NULL,
    valor numeric NOT NULL,
    CONSTRAINT medicamentos_chk_fa_id_valido CHECK ((medid > 0)),
    CONSTRAINT medicamentos_valor_chk CHECK ((valor >= (0)::numeric))
);


ALTER TABLE public.medicamentos OWNER TO eduardo;

--
-- Name: medicamentos_medid_seq; Type: SEQUENCE; Schema: public; Owner: eduardo
--

CREATE SEQUENCE public.medicamentos_medid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamentos_medid_seq OWNER TO eduardo;

--
-- Name: medicamentos_medid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardo
--

ALTER SEQUENCE public.medicamentos_medid_seq OWNED BY public.medicamentos.medid;


--
-- Name: vendas; Type: TABLE; Schema: public; Owner: eduardo
--

CREATE TABLE public.vendas (
    venid integer NOT NULL,
    produto integer NOT NULL,
    produto_receita boolean NOT NULL,
    clienteid integer,
    valor numeric NOT NULL,
    vendedor character(11) NOT NULL,
    vendedor_fun public.funcao_fun NOT NULL,
    CONSTRAINT vendas_chk_venid_valido CHECK ((venid > 0)),
    CONSTRAINT vendas_receita_chk CHECK ((NOT ((clienteid IS NULL) AND (produto_receita = true)))),
    CONSTRAINT vendas_valor_chk CHECK ((valor >= (0)::numeric)),
    CONSTRAINT vendas_vendedor_chk CHECK ((vendedor_fun = 'VENDEDOR'::public.funcao_fun))
);


ALTER TABLE public.vendas OWNER TO eduardo;

--
-- Name: vendas_venid_seq; Type: SEQUENCE; Schema: public; Owner: eduardo
--

CREATE SEQUENCE public.vendas_venid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendas_venid_seq OWNER TO eduardo;

--
-- Name: vendas_venid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eduardo
--

ALTER SEQUENCE public.vendas_venid_seq OWNED BY public.vendas.venid;


--
-- Name: clienteid; Type: DEFAULT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.clientes ALTER COLUMN clienteid SET DEFAULT nextval('public.clientes_clienteid_seq'::regclass);


--
-- Name: endeid; Type: DEFAULT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.enderecos ALTER COLUMN endeid SET DEFAULT nextval('public.enderecos_endeid_seq'::regclass);


--
-- Name: entregaid; Type: DEFAULT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.entregas ALTER COLUMN entregaid SET DEFAULT nextval('public.entregas_entregaid_seq'::regclass);


--
-- Name: fa_id; Type: DEFAULT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.farmacias ALTER COLUMN fa_id SET DEFAULT nextval('public.farmacias_fa_id_seq'::regclass);


--
-- Name: medid; Type: DEFAULT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.medicamentos ALTER COLUMN medid SET DEFAULT nextval('public.medicamentos_medid_seq'::regclass);


--
-- Name: venid; Type: DEFAULT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.vendas ALTER COLUMN venid SET DEFAULT nextval('public.vendas_venid_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: eduardo
--

INSERT INTO public.clientes (clienteid, nome, data_nasc) VALUES (1, 'Eduardo Henrique Pontes Silva', '1997-07-21');
INSERT INTO public.clientes (clienteid, nome, data_nasc) VALUES (2, 'Pedro Junior', '1979-07-07');
INSERT INTO public.clientes (clienteid, nome, data_nasc) VALUES (3, 'Petrônio Domingos', '1981-03-31');
INSERT INTO public.clientes (clienteid, nome, data_nasc) VALUES (4, 'Marleide Silva', '1980-02-03');
INSERT INTO public.clientes (clienteid, nome, data_nasc) VALUES (5, 'Edson Weslley', '1999-05-15');


--
-- Name: clientes_clienteid_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardo
--

SELECT pg_catalog.setval('public.clientes_clienteid_seq', 5, true);


--
-- Data for Name: enderecos; Type: TABLE DATA; Schema: public; Owner: eduardo
--

INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (1, 1, 'RESIDENCIA', 'PB', 'João Pessoa', 'Manaira', 'Rua Joaquim Carneiro de Mesquita, 147');
INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (2, 2, 'RESIDENCIA', 'PB', 'João Pessoa', 'Manaira', 'Rua Joaquim Carneiro de Mesquita, 147');
INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (3, 1, 'OUTRO', 'PB', 'Campina Grande', 'Prata', 'Rua Nilo Peçanha, 446');
INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (4, 2, 'TRABALHO', 'PB', 'João Pessoa', 'Cristo Redentor', 'Av. Raniere Mazille, S/n - PLS Frutas');
INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (5, 1, 'TRABALHO', 'PB', 'João Pessoa', 'Cristo Redentor', 'Av. Raniere Mazille, S/n - PLS Frutas');
INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (6, 3, 'RESIDENCIA', 'PB', 'João Pessoa', 'Geisel', 'Rua João miguel de souza, 721');
INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (7, 4, 'OUTRO', 'PB', 'Campina Grande', 'Prata', 'Rua Nilo Peçanha, 446');
INSERT INTO public.enderecos (endeid, clienteid, tipo_endereco, estado, cidade, bairro, rua) VALUES (8, 5, 'RESIDENCIA', 'PB', 'Campina Grande', 'Prata', 'Rua Silva Barbosa, 1025');


--
-- Name: enderecos_endeid_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardo
--

SELECT pg_catalog.setval('public.enderecos_endeid_seq', 8, true);


--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: eduardo
--

INSERT INTO public.entregas (entregaid, vendaid, clienteid, enderecoid) VALUES (1, 1, 2, 2);
INSERT INTO public.entregas (entregaid, vendaid, clienteid, enderecoid) VALUES (2, 4, 3, 6);
INSERT INTO public.entregas (entregaid, vendaid, clienteid, enderecoid) VALUES (3, 5, 5, 8);


--
-- Name: entregas_entregaid_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardo
--

SELECT pg_catalog.setval('public.entregas_entregaid_seq', 3, true);


--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: eduardo
--

INSERT INTO public.farmacias (fa_id, nome, bairro, cidade, estado, gerente, gerente_fun, tipo_loja) VALUES (1, 'REDEPHARMA Unidade Manaira', 'Manaira', 'João Pessoa', 'PB', '12734805000', 'FARMACEUTICO', 'S');
INSERT INTO public.farmacias (fa_id, nome, bairro, cidade, estado, gerente, gerente_fun, tipo_loja) VALUES (2, 'REDEPHARMA Unidade Geisel', 'geisel', 'João Pessoa', 'PB', '12734805013', 'ADMINISTRADOR', 'F');
INSERT INTO public.farmacias (fa_id, nome, bairro, cidade, estado, gerente, gerente_fun, tipo_loja) VALUES (3, 'PAGUE MENOS Unidade Prata', 'prata', 'Campina Grande', 'PB', '12734805001', 'FARMACEUTICO', 'F');


--
-- Name: farmacias_fa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardo
--

SELECT pg_catalog.setval('public.farmacias_fa_id_seq', 3, true);


--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: eduardo
--

INSERT INTO public.funcionarios (cpf, nome, funcao, farmaciaid) VALUES ('12734805021', 'Carla Silva', 'VENDEDOR', NULL);
INSERT INTO public.funcionarios (cpf, nome, funcao, farmaciaid) VALUES ('12734804002', 'Mario Batista', 'ENTREGADOR', NULL);
INSERT INTO public.funcionarios (cpf, nome, funcao, farmaciaid) VALUES ('12734807001', 'Fernanda Barbosa', 'ADMINISTRADOR', NULL);
INSERT INTO public.funcionarios (cpf, nome, funcao, farmaciaid) VALUES ('12734805002', 'Joao Paulo', 'ENTREGADOR', NULL);
INSERT INTO public.funcionarios (cpf, nome, funcao, farmaciaid) VALUES ('12734805000', 'Carlos Wilson', 'FARMACEUTICO', 1);
INSERT INTO public.funcionarios (cpf, nome, funcao, farmaciaid) VALUES ('12734805013', 'Ana Paula', 'ADMINISTRADOR', 2);
INSERT INTO public.funcionarios (cpf, nome, funcao, farmaciaid) VALUES ('12734805001', 'Pedro Santos', 'FARMACEUTICO', 3);


--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: eduardo
--

INSERT INTO public.medicamentos (medid, nome, prin_ativo, venda_exclusiva, valor) VALUES (1, 'DEXILANT 60 Comprimidos', 'dexlansoprazol 60 mg', false, 126.30);
INSERT INTO public.medicamentos (medid, nome, prin_ativo, venda_exclusiva, valor) VALUES (2, 'Loratamed 12 Comprimidos', 'loratadina 10 mg', false, 21.50);
INSERT INTO public.medicamentos (medid, nome, prin_ativo, venda_exclusiva, valor) VALUES (3, 'Motilium 90 Comprimidos', 'domperidona 10 mg', false, 116.90);
INSERT INTO public.medicamentos (medid, nome, prin_ativo, venda_exclusiva, valor) VALUES (4, 'Klaricid UD 10 Comprimidos', 'claritromicina 50 mg', true, 180);


--
-- Name: medicamentos_medid_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardo
--

SELECT pg_catalog.setval('public.medicamentos_medid_seq', 4, true);


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: eduardo
--

INSERT INTO public.vendas (venid, produto, produto_receita, clienteid, valor, vendedor, vendedor_fun) VALUES (1, 1, false, 2, 126.50, '12734805021', 'VENDEDOR');
INSERT INTO public.vendas (venid, produto, produto_receita, clienteid, valor, vendedor, vendedor_fun) VALUES (2, 2, false, NULL, 21.5, '12734805021', 'VENDEDOR');
INSERT INTO public.vendas (venid, produto, produto_receita, clienteid, valor, vendedor, vendedor_fun) VALUES (3, 3, false, NULL, 116.90, '12734805021', 'VENDEDOR');
INSERT INTO public.vendas (venid, produto, produto_receita, clienteid, valor, vendedor, vendedor_fun) VALUES (4, 4, true, 3, 190, '12734805021', 'VENDEDOR');
INSERT INTO public.vendas (venid, produto, produto_receita, clienteid, valor, vendedor, vendedor_fun) VALUES (5, 2, false, 5, 21.5, '12734805021', 'VENDEDOR');


--
-- Name: vendas_venid_seq; Type: SEQUENCE SET; Schema: public; Owner: eduardo
--

SELECT pg_catalog.setval('public.vendas_venid_seq', 5, true);


--
-- Name: clientes_clienteid_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_clienteid_pkey PRIMARY KEY (clienteid);


--
-- Name: enderecos_clienteid_un; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT enderecos_clienteid_un UNIQUE (endeid, clienteid);


--
-- Name: enderecos_endeid_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT enderecos_endeid_pkey PRIMARY KEY (endeid);


--
-- Name: entregas_entregaid_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_entregaid_pkey PRIMARY KEY (entregaid);


--
-- Name: entregas_entregaid_un; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_entregaid_un UNIQUE (entregaid, vendaid);


--
-- Name: farmacias_bairro_un; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_bairro_un UNIQUE (bairro);


--
-- Name: farmacias_gerente_un; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_gerente_un UNIQUE (gerente, fa_id);


--
-- Name: farmacias_id_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_id_pkey PRIMARY KEY (fa_id);


--
-- Name: farmacias_tipo_ex; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_tipo_ex EXCLUDE USING gist (tipo_loja WITH =) WHERE ((tipo_loja = 'S'::bpchar));


--
-- Name: funcionarios_cpf_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_cpf_pkey PRIMARY KEY (cpf);


--
-- Name: funcionarios_funcao_uni; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_funcao_uni UNIQUE (cpf, funcao);


--
-- Name: medicamentos_medid_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_medid_pkey PRIMARY KEY (medid);


--
-- Name: medicamentos_venda_uni; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_venda_uni UNIQUE (medid, venda_exclusiva);


--
-- Name: vendas_clienteid_un; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_clienteid_un UNIQUE (venid, clienteid);


--
-- Name: vendas_venid_pkey; Type: CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_venid_pkey PRIMARY KEY (venid);


--
-- Name: enderecos_clienteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT enderecos_clienteid_fkey FOREIGN KEY (clienteid) REFERENCES public.clientes(clienteid);


--
-- Name: entregas_clienteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_clienteid_fkey FOREIGN KEY (clienteid) REFERENCES public.clientes(clienteid);


--
-- Name: entregas_enderecoid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_enderecoid_fkey FOREIGN KEY (enderecoid, clienteid) REFERENCES public.enderecos(endeid, clienteid);


--
-- Name: entregas_vendaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_vendaid_fkey FOREIGN KEY (vendaid, clienteid) REFERENCES public.vendas(venid, clienteid);


--
-- Name: farmacias_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_gerente_fkey FOREIGN KEY (gerente, gerente_fun) REFERENCES public.funcionarios(cpf, funcao) ON DELETE RESTRICT;


--
-- Name: funcionarios_farmaciaid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_farmaciaid_fkey FOREIGN KEY (cpf, farmaciaid) REFERENCES public.farmacias(gerente, fa_id);


--
-- Name: vendas_clienteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_clienteid_fkey FOREIGN KEY (clienteid) REFERENCES public.clientes(clienteid);


--
-- Name: vendas_produto_receita_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_produto_receita_fkey FOREIGN KEY (produto, produto_receita) REFERENCES public.medicamentos(medid, venda_exclusiva) ON DELETE RESTRICT;


--
-- Name: vendas_vendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: eduardo
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_vendedor_fkey FOREIGN KEY (vendedor, vendedor_fun) REFERENCES public.funcionarios(cpf, funcao) ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


--
-- COMANDOS ADICIONAIS
--

-- Devem ser executados com sucesso
--

INSERT INTO funcionarios VALUES ('12734806000', 'Bruno Rodrigo', 'FARMACEUTICO', null),
    ('12734806001', 'Pedro Carlos', 'FARMACEUTICO', null),
    ('12734806013', 'Leonardo Jose', 'ADMINISTRADOR', null),
    ('12734806021', 'Antonio Santos', 'VENDEDOR', null),
    ('12734807002', 'Paulo Roberto', 'ENTREGADOR', null),
    ('12734808001', 'Priscila Karla', 'ADMINISTRADOR', null),
    ('12734809002', 'Venancio Carlos', 'ENTREGADOR', null);

INSERT INTO farmacias VALUES (DEFAULT, 'REDEPHARMA Unidade Funcionarios', 'Funcionarios', 'João Pessoa', 'PB', '12734806000', 'FARMACEUTICO', 'F'),
    (DEFAULT,'REDEPHARMA Unidade Monte Santo', 'Monte Santos', 'Campina Grande', 'PB', '12734806013', 'ADMINISTRADOR', 'F'),
    (DEFAULT,'PAGUE MENOS Unidade Boa Viagem', 'Boa Viagem', 'Recife', 'PE', '12734806001', 'FARMACEUTICO', 'F');

UPDATE funcionarios SET farmaciaID = 4 WHERE cpf = '12734806000';
UPDATE funcionarios SET farmaciaID = 5 WHERE cpf = '12734806013';
UPDATE funcionarios SET farmaciaID = 6 WHERE cpf = '12734806001';

INSERT INTO medicamentos VALUES (DEFAULT, 'Pantoprazol 42 Comprimidos', 'Pantoprazol 40 mg', false, 18.65),
    (DEFAULT, 'Dipirona Sódica 30 Comprimidos', 'Dipirona 500 mg', false, 10.90),
    (DEFAULT, 'Nesina 30 Comprimidos', 'Nesina 25 mg', false, 67.65),
    (DEFAULT, 'Amoxilina', 'Amoxilina', true, 60);

INSERT INTO clientes VALUES (DEFAULT, 'Joao Pedro', '1997-07-21'),
    (DEFAULT, 'Rafael Dantas', '1979-07-07'),
    (DEFAULT, 'Gabriel Dantas', '1981-03-31');

INSERT INTO enderecos VALUES (DEFAULT, 6, 'RESIDENCIA', 'PB', 'João Pessoa', 'Manaira', 'Rua Flavio Barbosa, 134'),
    (DEFAULT, 7, 'RESIDENCIA', 'PB', 'João Pessoa', 'MAngabeira', 'Rua Cidade Verde, 12'),
    (DEFAULT, 6, 'OUTRO', 'PB', 'Campina Grande','Prata', 'Rua Silva Barbosa, 975'),
    (DEFAULT, 8, 'RESIDENCIA', 'PB', 'Campina Grande','Prata', 'Rua Silva Barbosa, 975');

INSERT INTO vendas VALUES (DEFAULT, 5, false, 6, 18.65, '12734805021', 'VENDEDOR'),
    (DEFAULT, 6, false, null, 10.9, '12734805021', 'VENDEDOR'),
    (DEFAULT, 8, true, 8, 60, '12734805021', 'VENDEDOR');

INSERT INTO entregas VALUES (DEFAULT, 6, 6, 9),
    (DEFAULT, 8, 8, 12);


-- Devem ser executados com algum erro
--

INSERT INTO funcionarios VALUES ('1273480500', 'pedro Wilson', 'FARMACEUTICO', null);
-- ERROR:  new row for relation "funcionarios" violates check constraint "funcionarios_chk_cpf_valido"
-- DETAIL:  Failing row contains (1273480500 , pedro Wilson, FARMACEUTICO, null).
INSERT INTO funcionarios VALUES ('127348050001', 'joao Wilson', 'FARMACEUTICO', null);
-- ERROR:  value too long for type character(11)
INSERT INTO funcionarios VALUES (null, 'sei la Wilson', 'FARMACEUTICO', null);
-- ERROR:  null value in column "cpf" violates not-null constraint
-- DETAIL:  Failing row contains (null, sei la Wilson, FARMACEUTICO, null).
INSERT INTO funcionarios VALUES ('12734805032', null, 'FARMACEUTICO', null);
-- ERROR:  null value in column "nome" violates not-null constraint
-- DETAIL:  Failing row contains (12734805032, null, FARMACEUTICO, null).
INSERT INTO funcionarios VALUES ('12734805230', 'Carlos Wilson', null, null);
-- ERROR:  null value in column "funcao" violates not-null constraint
-- DETAIL:  Failing row contains (12734805230, Carlos Wilson, null, null)
INSERT INTO funcionarios VALUES ('12734805120', 'Carlos Wilson', 'caseiro', null);
-- ERROR:  invalid input value for enum funcao_fun: "caseiro"
-- LINE 1: ...cionarios VALUES ('12734805120', 'Carlos Wilson', 'caseiro',...
INSERT INTO funcionarios VALUES ('12734805234', 'Carlos Wilson', 'FARMACEUTICO', 1);
-- ERROR:  insert or update on table "funcionarios" violates foreign key constraint "funcionarios_farmaciaid_fkey"
-- DETAIL:  Key (cpf, farmaciaid)=(12734805234, 1) is not present in table "farmacias".
INSERT INTO funcionarios VALUES ('12734805500', 'Carlos Wilson', 'FARMACEUTICO', -1);
-- ERROR:  new row for relation "funcionarios" violates check constraint "funcionarios_chk_farmciaid_valido"
-- DETAIL:  Failing row contains (12734805500, Carlos Wilson, FARMACEUTICO, -1).

INSERT INTO farmacias VALUES (0,'REDEPHARMA Unidade Manaira', 'Manaira', 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', 'S');
-- ERROR:  new row for relation "farmacias" violates check constraint "farmacias_chk_fa_id_valido"
-- DETAIL:  Failing row contains (0, REDEPHARMA Unidade Manaira, Manaira, João Pessoa, PB, 12734807001, ADMINISTRADOR, S).
INSERT INTO farmacias VALUES (null,'REDEPHARMA Unidade Manaira', 'Manaira', 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', 'F');
-- ERROR:  null value in column "fa_id" violates not-null constraint
-- DETAIL:  Failing row contains (null, REDEPHARMA Unidade Manaira, Manaira, João Pessoa, PB, 12734807001, ADMINISTRADOR, F).
INSERT INTO farmacias VALUES (DEFAULT, null, 'Bessa', 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', 'F');
-- ERROR:  null value in column "nome" violates not-null constraint
-- DETAIL:  Failing row contains (7, null, Bessa, João Pessoa, PB, 12734807001, ADMINISTRADOR, F).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', null, 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', 'F');
-- ERROR:  null value in column "bairro" violates not-null constraint
-- DETAIL:  Failing row contains (8, REDEPHARMA Unidade Bessa, null, João Pessoa, PB, 12734807001, ADMINISTRADOR, F).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Manaira', 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', 'F');
-- ERROR:  duplicate key value violates unique constraint "farmacias_bairro_un"
-- DETAIL:  Key (bairro)=(Manaira) already exists.
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', null, 'PB', '12734807001', 'ADMINISTRADOR', 'F');
-- ERROR:  null value in column "cidade" violates not-null constraint
-- DETAIL:  Failing row contains (10, REDEPHARMA Unidade Bessa, Bessa, null, PB, 12734807001, ADMINISTRADOR, F).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', null, '12734807001', 'ADMINISTRADOR', 'F');
-- ERROR:  null value in column "estado" violates not-null constraint
-- DETAIL:  Failing row contains (11, REDEPHARMA Unidade Bessa, Bessa, João Pessoa, null, 12734807001, ADMINISTRADOR, F).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'SP', '12734807001', 'ADMINISTRADOR', 'F');
-- ERROR:  invalid input value for enum estado_ne: "SP"
-- LINE 1: ...EDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'SP', '127...
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', null, 'ADMINISTRADOR', 'F');
-- ERROR:  null value in column "gerente" violates not-null constraint
-- DETAIL:  Failing row contains (12, REDEPHARMA Unidade Bessa, Bessa, João Pessoa, PB, null, ADMINISTRADOR, F).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807013', 'ADMINISTRADOR', 'F');
-- ERROR:  insert or update on table "farmacias" violates foreign key constraint "farmacias_gerente_fkey"
-- DETAIL:  Key (gerente, gerente_fun)=(12734807013, ADMINISTRADOR) is not present in table "funcionarios".
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807015', 'ADMINISTRADOR', 'F');
-- ERROR:  insert or update on table "farmacias" violates foreign key constraint "farmacias_gerente_fkey"
-- DETAIL:  Key (gerente, gerente_fun)=(12734807015, ADMINISTRADOR) is not present in table "funcionarios".
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807001', null, 'F');
-- ERROR:  null value in column "gerente_fun" violates not-null constraint
-- DETAIL:  Failing row contains (15, REDEPHARMA Unidade Bessa, Bessa, João Pessoa, PB, 12734807001, null, F).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807001', 'FARMACEUTICO', 'F');
-- ERROR:  insert or update on table "farmacias" violates foreign key constraint "farmacias_gerente_fkey"
-- DETAIL:  Key (gerente, gerente_fun)=(12734807001, FARMACEUTICO) is not present in table "funcionarios".
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807021', 'VENDEDOR', 'F');
-- ERROR:  new row for relation "farmacias" violates check constraint "farmacias_gerente_fun_chk"
-- DETAIL:  Failing row contains (17, REDEPHARMA Unidade Bessa, Bessa, João Pessoa, PB, 12734807021, VENDEDOR, F).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', null);
-- ERROR:  null value in column "tipo_loja" violates not-null constraint
-- DETAIL:  Failing row contains (18, REDEPHARMA Unidade Bessa, Bessa, João Pessoa, PB, 12734807001, ADMINISTRADOR, null).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', 'S');
-- ERROR:  conflicting key value violates exclusion constraint "farmacias_tipo_ex"
-- DETAIL:  Key (tipo_loja)=(S) conflicts with existing key (tipo_loja)=(S).
INSERT INTO farmacias VALUES (DEFAULT,'REDEPHARMA Unidade Bessa', 'Bessa', 'João Pessoa', 'PB', '12734807001', 'ADMINISTRADOR', 'FI');
-- ERROR:  value too long for type character(1)

INSERT INTO medicamentos VALUES (0, 'DEXILANT 30 Comprimidos', 'dexlansoprazol 60 mg', false, 66.60);
-- ERROR:  new row for relation "medicamentos" violates check constraint "medicamentos_chk_fa_id_valido"
-- DETAIL:  Failing row contains (0, DEXILANT 30 Comprimidos, dexlansoprazol 60 mg, f, 66.60).
INSERT INTO medicamentos VALUES (null, 'DEXILANT 30 Comprimidos', 'dexlansoprazol 60 mg', false, 66.60);
-- ERROR:  null value in column "medid" violates not-null constraint
-- DETAIL:  Failing row contains (null, DEXILANT 30 Comprimidos, dexlansoprazol 60 mg, f, 66.60).
INSERT INTO medicamentos VALUES (1, 'DEXILANT 30 Comprimidos', 'dexlansoprazol 60 mg', false, 66.60);
-- ERROR:  duplicate key value violates unique constraint "medicamentos_medid_pkey"
-- DETAIL:  Key (medid)=(1) already exists.
INSERT INTO medicamentos VALUES (DEFAULT, null, 'dexlansoprazol 60 mg', false, 66.60);
-- ERROR:  null value in column "nome" violates not-null constraint
-- DETAIL:  Failing row contains (10, null, dexlansoprazol 60 mg, f, 66.60).
INSERT INTO medicamentos VALUES (DEFAULT, 'DEXILANT 30 Comprimidos', null, false, 66.60);
-- ERROR:  null value in column "prin_ativo" violates not-null constraint
-- DETAIL:  Failing row contains (11, DEXILANT 30 Comprimidos, null, f, 66.60).
INSERT INTO medicamentos VALUES (DEFAULT, 'DEXILANT 30 Comprimidos', 'dexlansoprazol 60 mg', null, 66.60);
-- ERROR:  null value in column "venda_exclusiva" violates not-null constraint
-- DETAIL:  Failing row contains (12, DEXILANT 30 Comprimidos, dexlansoprazol 60 mg, null, 66.60).
INSERT INTO medicamentos VALUES (DEFAULT, 'DEXILANT 30 Comprimidos', 'dexlansoprazol 60 mg', false, -66.60);
-- ERROR:  new row for relation "medicamentos" violates check constraint "medicamentos_valor_chk"
-- DETAIL:  Failing row contains (13, DEXILANT 30 Comprimidos, dexlansoprazol 60 mg, f, -66.60).
INSERT INTO medicamentos VALUES (DEFAULT, 'DEXILANT 30 Comprimidos', 'dexlansoprazol 60 mg', false, null);
-- ERROR:  null value in column "valor" violates not-null constraint
-- DETAIL:  Failing row contains (14, DEXILANT 30 Comprimidos, dexlansoprazol 60 mg, f, null).

INSERT INTO clientes VALUES (0, 'Pietra Regina', '1998-12-24');
-- ERROR:  new row for relation "clientes" violates check constraint "clientes_chk_clienteid_valido"
-- DETAIL:  Failing row contains (0, Pietra Regina, 1998-12-24).
INSERT INTO clientes VALUES (null, 'Pietra Regina', '1998-12-24');
-- ERROR:  null value in column "clienteid" violates not-null constraint
-- DETAIL:  Failing row contains (null, Pietra Regina, 1998-12-24).
INSERT INTO clientes VALUES (1, 'Pietra Regina', '1998-12-24');
-- ERROR:  duplicate key value violates unique constraint "clientes_clienteid_pkey"
-- DETAIL:  Key (clienteid)=(1) already exists.
INSERT INTO clientes VALUES (DEFAULT, null, '1998-12-24');
-- ERROR:  null value in column "nome" violates not-null constraint
-- DETAIL:  Failing row contains (9, null, 1998-12-24).
INSERT INTO clientes VALUES (DEFAULT, 'Pietra Regina', null);
-- ERROR:  null value in column "data_nasc" violates not-null constraint
-- DETAIL:  Failing row contains (10, Pietra Regina, null).
INSERT INTO clientes VALUES (DEFAULT, 'Pietra Regina', '2001-12-24');
-- ERROR:  new row for relation "clientes" violates check constraint "clientes_idade_min_chk"
-- DETAIL:  Failing row contains (11, Pietra Regina, 2001-12-24).
INSERT INTO clientes VALUES (DEFAULT, 'Pietra Regina', '2001-04-13'); -- Data da Consulta: 2019-04-12
-- ERROR:  new row for relation "clientes" violates check constraint "clientes_idade_min_chk"
-- DETAIL:  Failing row contains (12, Pietra Regina, 2001-04-13).

INSERT INTO enderecos VALUES (0, 1, 'RESIDENCIA', 'PB', 'João Pessoa', 'Manaira', 'Rua Joaquim Carneiro de Mesquita, 147');
-- ERROR:  new row for relation "enderecos" violates check constraint "enderecos_chk_endeid_valido"
-- DETAIL:  Failing row contains (0, 1, RESIDENCIA, PB, João Pessoa, Manaira, Rua Joaquim Carneiro de Mesquita, 147).
INSERT INTO enderecos VALUES (1, 1, 'OUTRO', 'PB', 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  duplicate key value violates unique constraint "enderecos_endeid_pkey"
-- DETAIL:  Key (endeid)=(1) already exists.
INSERT INTO enderecos VALUES (null, 1, 'OUTRO', 'PB', 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  null value in column "endeid" violates not-null constraint
-- DETAIL:  Failing row contains (null, 1, OUTRO, PB, João Pessoa, Geisel, Rua João Miguel de Souza, 721).
INSERT INTO enderecos VALUES (DEFAULT, null, 'OUTRO', 'PB', 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  null value in column "clienteid" violates not-null constraint
-- DETAIL:  Failing row contains (13, null, OUTRO, PB, João Pessoa, Geisel, Rua João Miguel de Souza, 721).
INSERT INTO enderecos VALUES (DEFAULT, 15, 'OUTRO', 'PB', 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  insert or update on table "enderecos" violates foreign key constraint "enderecos_clienteid_fkey"
-- DETAIL:  Key (clienteid)=(15) is not present in table "clientes".
INSERT INTO enderecos VALUES (DEFAULT, 1, 'CASA', 'PB', 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  invalid input value for enum address_tipo: "CASA"
-- LINE 1: INSERT INTO enderecos VALUES (DEFAULT, 1, 'CASA', 'PB', 'Joã...
INSERT INTO enderecos VALUES (DEFAULT, 1, null, 'PB', 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  null value in column "tipo_endereco" violates not-null constraint
-- DETAIL:  Failing row contains (15, 1, null, PB, João Pessoa, Geisel, Rua João Miguel de Souza, 721).
INSERT INTO enderecos VALUES (DEFAULT, 1, 'OUTRO', 'SP', 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  invalid input value for enum estado_ne: "SP"
-- LINE 1: ...NSERT INTO enderecos VALUES (DEFAULT, 1, 'OUTRO', 'SP', 'Joã...
INSERT INTO enderecos VALUES (DEFAULT, 1, 'OUTRO', null, 'João Pessoa', 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  null value in column "estado" violates not-null constraint
-- DETAIL:  Failing row contains (16, 1, OUTRO, null, João Pessoa, Geisel, Rua João Miguel de Souza, 721).
INSERT INTO enderecos VALUES (DEFAULT, 1, 'OUTRO', 'PB', null, 'Geisel', 'Rua João Miguel de Souza, 721');
-- ERROR:  null value in column "cidade" violates not-null constraint
-- DETAIL:  Failing row contains (17, 1, OUTRO, PB, null, Geisel, Rua João Miguel de Souza, 721).
INSERT INTO enderecos VALUES (DEFAULT, 1, 'OUTRO', 'PB', 'João Pessoa', null, 'Rua João Miguel de Souza, 721');
-- ERROR:  null value in column "bairro" violates not-null constraint
-- DETAIL:  Failing row contains (18, 1, OUTRO, PB, João Pessoa, null, Rua João Miguel de Souza, 721).
INSERT INTO enderecos VALUES (DEFAULT, 1, 'OUTRO', 'PB', 'João Pessoa', 'Geisel', null);
-- ERROR:  null value in column "rua" violates not-null constraint
-- DETAIL:  Failing row contains (19, 1, OUTRO, PB, João Pessoa, Geisel, null).

INSERT INTO vendas VALUES (0, 2, false, 2, 21.50, '12734805021', 'VENDEDOR');
-- ERROR:  new row for relation "vendas" violates check constraint "vendas_chk_venid_valido"
-- DETAIL:  Failing row contains (0, 2, f, 2, 21.50, 12734805021, VENDEDOR).
INSERT INTO vendas VALUES (1, 2, false, 2, 21.50, '12734805021', 'VENDEDOR');
-- ERROR:  duplicate key value violates unique constraint "vendas_venid_pkey"
-- DETAIL:  Key (venid)=(1) already exists.
INSERT INTO vendas VALUES (DEFAULT, 10, false, 2, 21.50, '12734805021', 'VENDEDOR');
-- ERROR:  insert or update on table "vendas" violates foreign key constraint "vendas_produto_receita_fkey"
-- DETAIL:  Key (produto, produto_receita)=(10, f) is not present in table "medicamentos".
INSERT INTO vendas VALUES (DEFAULT, null, false, 2, 21.50, '12734805021', 'VENDEDOR');
-- ERROR:  null value in column "produto" violates not-null constraint
-- DETAIL:  Failing row contains (10, null, f, 2, 21.50, 12734805021, VENDEDOR).
INSERT INTO vendas VALUES (DEFAULT, 2, true, 2, 21.50, '12734805021', 'VENDEDOR');
-- ERROR:  insert or update on table "vendas" violates foreign key constraint "vendas_produto_receita_fkey"
-- DETAIL:  Key (produto, produto_receita)=(2, t) is not present in table "medicamentos".
INSERT INTO vendas VALUES (DEFAULT, 2, false, 20, 21.50, '12734805021', 'VENDEDOR');
-- ERROR:  insert or update on table "vendas" violates foreign key constraint "vendas_clienteid_fkey"
-- DETAIL:  Key (clienteid)=(20) is not present in table "clientes".
INSERT INTO vendas VALUES (DEFAULT, 4, true, null, 180, '12734805021', 'VENDEDOR');
-- ERROR:  new row for relation "vendas" violates check constraint "vendas_receita_chk"
-- DETAIL:  Failing row contains (14, 4, t, null, 180, 12734805021, VENDEDOR).
INSERT INTO vendas VALUES (DEFAULT, 2, false, 2, - 21.50, '12734805021', 'VENDEDOR');
-- ERROR:  new row for relation "vendas" violates check constraint "vendas_valor_chk"
-- DETAIL:  Failing row contains (15, 2, f, 2, -21.50, 12734805021, VENDEDOR).
INSERT INTO vendas VALUES (DEFAULT, 2, false, 2, 21.50, '12734805001', 'FARMACEUTICO');
-- ERROR:  new row for relation "vendas" violates check constraint "vendas_vendedor_chk"
-- DETAIL:  Failing row contains (16, 2, f, 2, 21.50, 12734805001, FARMACEUTICO).
INSERT INTO vendas VALUES (DEFAULT, 2, false, 2, 21.50, '12734805021', 'FARMACEUTICO');
-- ERROR:  new row for relation "vendas" violates check constraint "vendas_vendedor_chk"
-- DETAIL:  Failing row contains (17, 2, f, 2, 21.50, 12734805021, FARMACEUTICO).

INSERT INTO entregas VALUES (0, 1, 2, 2);
-- ERROR:  new row for relation "entregas" violates check constraint "vendas_chk_entregaid_valido"
-- DETAIL:  Failing row contains (0, 1, 2, 2).
INSERT INTO entregas VALUES (1, 1, 2, 2);
-- ERROR:  duplicate key value violates unique constraint "entregas_entregaid_pkey"
-- DETAIL:  Key (entregaid)=(1) already exists.
INSERT INTO entregas VALUES (DEFAULT, null, 2, 2);
-- ERROR:  null value in column "vendaid" violates not-null constraint
-- DETAIL:  Failing row contains (6, null, 2, 2).
INSERT INTO entregas VALUES (DEFAULT, 2, 2, 2);
-- ERROR:  insert or update on table "entregas" violates foreign key constraint "entregas_vendaid_fkey"
-- DETAIL:  Key (vendaid, clienteid)=(2, 2) is not present in table "vendas".
INSERT INTO entregas VALUES (DEFAULT, 6, 2, 2);
-- ERROR:  insert or update on table "entregas" violates foreign key constraint "entregas_vendaid_fkey"
-- DETAIL:  Key (vendaid, clienteid)=(6, 2) is not present in table "vendas".
INSERT INTO entregas VALUES (DEFAULT, 1, 3, 2);
-- ERROR:  insert or update on table "entregas" violates foreign key constraint "entregas_vendaid_fkey"
-- DETAIL:  Key (vendaid, clienteid)=(1, 3) is not present in table "vendas".
INSERT INTO entregas VALUES (DEFAULT, 1, null, 2);
-- ERROR:  null value in column "clienteid" violates not-null constraint
-- DETAIL:  Failing row contains (10, 1, null, 2).
INSERT INTO entregas VALUES (DEFAULT, 1, 6, 2);
-- ERROR:  insert or update on table "entregas" violates foreign key constraint "entregas_vendaid_fkey"
-- DETAIL:  Key (vendaid, clienteid)=(1, 6) is not present in table "vendas".
INSERT INTO entregas VALUES (DEFAULT, 1, 2, 3);
-- ERROR:  insert or update on table "entregas" violates foreign key constraint "entregas_enderecoid_fkey"
-- DETAIL:  Key (enderecoid, clienteid)=(3, 2) is not present in table "enderecos".
INSERT INTO entregas VALUES (DEFAULT, 1, 2, null);
-- ERROR:  null value in column "enderecoid" violates not-null constraint
-- DETAIL:  Failing row contains (13, 1, 2, null).
