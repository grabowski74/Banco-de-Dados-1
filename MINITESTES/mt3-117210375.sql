CREATE TABLE estudante(
    matricula INTEGER,
    nome TEXT,
    data_nasc Date,
    CONSTRAINT estudante_matricula_pkey PRIMARY KEY(matricula)
);
CREATE TABLE disciplina (
    codigo INTEGER,
    carga_horaria SMALLINT,
    CONSTRAINT disciplina_codigo_pkey PRIMARY KEY(codigo)
);

CREATE TABLE estudanteDisciplina(
    matricula INTEGER,
    disciplina INTEGER,
    periodo_letivo CHAR(6),
    CONSTRAINT estudanteDisciplina_matricula_fkey FOREIGN KEY (matricula) REFERENCES estudante(matricula),
    CONSTRAINT estudanteDisciplina_disciplina_fkey FOREIGN KEY (disciplina) REFERENCES disciplina(codigo)
);