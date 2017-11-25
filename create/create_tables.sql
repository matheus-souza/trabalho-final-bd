CREATE TABLE pais (
    idpais serial NOT NULL,
    abreviacao char(3),
    nome varchar(150) NOT NULL,
    PRIMARY KEY (idpais)
);

CREATE TABLE estado (
    idestado serial NOT NULL,
    idpais int NOT NULL UNIQUE,
    nome varchar(150) NOT NULL,
    uf char(2) NOT NULL,
    PRIMARY KEY (idestado)
);

CREATE TABLE cidade (
    idcidade serial NOT NULL,
    idestado int NOT NULL UNIQUE,
    nome varchar(150) NOT NULL,
    PRIMARY KEY (idcidade)
);

CREATE TABLE endereco (
    idendereco serial NOT NULL,
    idcidade int NOT NULL,
    rua varchar(150) NOT NULL,
    bairro varchar(150) NOT NULL,
    numero int,
    PRIMARY KEY (idendereco)
);

CREATE TABLE email (
    idemail serial NOT NULL,
    idpessoa int NOT NULL,
    email varchar(100) NOT NULL,
    receber_promocoes boolean NOT NULL,
    PRIMARY KEY (idemail)
);

CREATE TABLE pessoa (
    idpessoa serial NOT NULL,
    idendereco int NOT NULL,
    PRIMARY KEY (idpessoa)
);

CREATE TABLE tipo_documento (
    idtipo_documento serial NOT NULL,
    descricao varchar(45) NOT NULL,
    PRIMARY KEY (idtipo_documento)
);

CREATE TABLE documento (
    iddocumento serial NOT NULL,
    idtipo_documento int NOT NULL,
    valor varchar(100) NOT NULL,
    PRIMARY KEY (iddocumento)
);

CREATE TABLE fisica (
    idpessoa int NOT NULL,
    iddocumento int NOT NULL,
    nome varchar(150),
    dt_nascimento date,
    PRIMARY KEY (idpessoa)
);

CREATE TABLE juridica (
    idpessoa int NOT NULL,
    iddocumento int NOT NULL,
    nome_fantasia varchar(150),
    razao_social varchar(150) NOT NULL,
    data_fundacao date,
    PRIMARY KEY (idpessoa)
);

CREATE TABLE telefone (
    idtelefone serial NOT NULL,
    idpessoa int NOT NULL,
    ddd int NOT NULL,
    telefone bigint NOT NULL,
    receber_promocoes boolean NOT NULL,
    operadora varchar(45),
    PRIMARY KEY (idtelefone)
);

CREATE TABLE dia_atendimento (
    iddia_atendimento serial NOT NULL,
    dia_semana int NOT NULL,
    trabalha_feriado boolean NOT NULL,
    PRIMARY KEY (iddia_atendimento)
);

CREATE TABLE horario_atendimento (
    idhorario_atendimento serial NOT NULL,
    iddia_atendimento int NOT NULL,
    hora_inicio time NOT NULL,
    hora_fim time NOT NULL,
    PRIMARY KEY (idhorario_atendimento)
);

CREATE TABLE servicos (
    idservicos serial NOT NULL,
    servico varchar(150) NOT NULL,
    tempo_medio_atendimento time NOT NULL,
    aceita_desconto boolean NOT NULL,
    valor decimal(8, 2),
    PRIMARY KEY (idservicos)
);

CREATE TABLE reservas (
    idreservas serial NOT NULL,
    idpessoa int NOT NULL,
    iddia_atendimento int NOT NULL,
    hora_inicio time NOT NULL,
    hora_fim time,
    lembrete boolean NOT NULL,
    PRIMARY KEY (idreservas)
);

CREATE TABLE reservas_has_servicos (
    idreservas int NOT NULL,
    idservicos int NOT NULL,
    PRIMARY KEY (idreservas)
);

ALTER TABLE estado ADD CONSTRAINT pais_estado_fk FOREIGN KEY (idpais) REFERENCES pais(idpais);

ALTER TABLE cidade ADD CONSTRAINT estado_cidade_fk FOREIGN KEY (idestado) REFERENCES estado(idestado);

ALTER TABLE endereco ADD CONSTRAINT cidade_endereco_fk FOREIGN KEY (idcidade) REFERENCES cidade(idcidade);

ALTER TABLE email ADD CONSTRAINT pessoa_email_fk FOREIGN KEY (idpessoa) REFERENCES pessoa(idpessoa);

ALTER TABLE pessoa ADD CONSTRAINT endereco_pessoa_fk FOREIGN KEY (idendereco) REFERENCES endereco(idendereco);

ALTER TABLE documento ADD CONSTRAINT tipo_documento_documento_fk FOREIGN KEY (idtipo_documento) REFERENCES tipo_documento(idtipo_documento);

ALTER TABLE fisica ADD CONSTRAINT pessoa_fisica_fk FOREIGN KEY (idpessoa) REFERENCES pessoa(idpessoa) ON DELETE CASCADE;

ALTER TABLE fisica ADD CONSTRAINT documento_fisica_fk FOREIGN KEY (iddocumento) REFERENCES documento(iddocumento);

ALTER TABLE juridica ADD CONSTRAINT pessoa_juridica_fk FOREIGN KEY (idpessoa) REFERENCES pessoa(idpessoa) ON DELETE CASCADE;

ALTER TABLE juridica ADD CONSTRAINT documento_juridica_fk FOREIGN KEY (iddocumento) REFERENCES documento(iddocumento);

ALTER TABLE telefone ADD CONSTRAINT pessoa_telefone_fk FOREIGN KEY (idpessoa) REFERENCES pessoa(idpessoa);

ALTER TABLE horario_atendimento ADD CONSTRAINT dia_atendimento_horario_atendimento_fk FOREIGN KEY (iddia_atendimento) REFERENCES dia_atendimento(iddia_atendimento);

ALTER TABLE reservas ADD CONSTRAINT pessoa_reservas_fk FOREIGN KEY (idpessoa) REFERENCES pessoa(idpessoa);

ALTER TABLE reservas ADD CONSTRAINT dia_atendimento_reservas_fk FOREIGN KEY (iddia_atendimento) REFERENCES dia_atendimento(iddia_atendimento);

ALTER TABLE reservas_has_servicos ADD CONSTRAINT reservas_reservas_has_servicos_fk FOREIGN KEY (idreservas) REFERENCES reservas(idreservas);

ALTER TABLE reservas_has_servicos ADD CONSTRAINT servicos_reservas_has_servicos_fk1 FOREIGN KEY (idservicos) REFERENCES servicos(idservicos);
