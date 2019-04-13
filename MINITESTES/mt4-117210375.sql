CREATE TYPE ESTILO_TIP AS ENUM ('R', 'P', 'E', 'S', 'A', 'C');


CREATE TABLE usuarios(
    id INTEGER PRIMARY KEY,
    nickname VARCHAR(15) NOT NULL,
    data_nasc DATE NOT NULL
);

CREATE TABLE musicas(
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    estilo ESTILO_TIP NOT NULL
);

CREATE TABLE avaliacoes(
    id INTEGER PRIMARY KEY,
    musica_id INTEGER NOT NULL,
    usuario INTEGER NOT NULL,
    nota SMALLINT NOT NULL,
    data_aval date,
    CONSTRAINT nota_chk CHECK(nota >= 0 AND nota <= 5),
    CONSTRAINT avaliacao_musica_id_fhk FOREIGN KEY(musica_id) REFERENCES musicas(id) ON DELETE CASCADE,
    CONSTRAINT avaliacao_usuario_id_fhk FOREIGN KEY(usuario) REFERENCES usuarios(id)
);
CREATE TABLE perfil(
    id INTEGER PRIMARY KEY,
    usuario_id INTEGER,
    desc_perfil TEXT NOT NULL,
    cadastra_usuario BOOLEAN NOT NULL,
    cadastra_musica BOOLEAN NOT NULL,
    faz_avaliacao BOOLEAN NOT NULL,
    CONSTRAINT perfil_usuario_id_fhk FOREIGN KEY(usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
);