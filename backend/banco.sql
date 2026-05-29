-- ============================================================
--  GRB — Good Roads Brasil
--  Sistema de Gestão de Ocorrências em Estradas Rurais
--  IFC Campus Concórdia — Projeto Integrador III (2026)
--  PostgreSQL 16
-- ============================================================

-- Extensão para geração de UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;  -- busca textual por descrição

-- ============================================================
-- TIPOS ENUMERADOS
-- Valores alinhados à seção 4.5 do pré-projeto
-- ============================================================

-- perfis de usuário (seção 4.5: comum, prefeitura ou admin)
CREATE TYPE perfil_usuario AS ENUM ('comum', 'prefeitura', 'admin');

-- tipos de problema (seção 4.5: buraco, alagamento, deslizamento, queda_de_arvore...)
CREATE TYPE tipo_problema_enum AS ENUM (
    'buraco',
    'alagamento',
    'deslizamento',
    'queda_de_arvore',
    'ponte_danificada',
    'erosao',
    'lama_atoleiro',
    'sinalizacao_ausente',
    'drenagem_obstruida',
    'outro'
);

-- urgência (seção 4.5: baixa, media, alta)
CREATE TYPE urgencia_enum AS ENUM ('baixa', 'media', 'alta');

-- status do chamado (seção 5: pendente, em atendimento, resolvido)
CREATE TYPE status_ocorrencia AS ENUM (
    'pendente',
    'em_analise',
    'em_andamento',
    'resolvido',
    'cancelado'
);


-- ============================================================
-- TABELA: usuarios
-- Seção 4.5: id, nome, email, senha_hash, tipo, telefone, criado_em
-- ============================================================
CREATE TABLE usuarios (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome        VARCHAR(150) NOT NULL,
    email       VARCHAR(254) NOT NULL UNIQUE,
    senha_hash  VARCHAR(255) NOT NULL,           -- bcrypt (RNF02)
    tipo        perfil_usuario NOT NULL DEFAULT 'comum',
    telefone    VARCHAR(20),
    ativo       BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- índice para login por e-mail (RF02)
CREATE INDEX idx_usuarios_email ON usuarios(email);


-- ============================================================
-- TABELA: ocorrencias
-- Núcleo do sistema — seção 4.5
-- id, usuario_id, tipo_problema, descricao, urgencia,
-- latitude, longitude, status, criado_em
-- ============================================================
CREATE TABLE ocorrencias (
    id              UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id      UUID            NOT NULL REFERENCES usuarios(id),
    tipo_problema   tipo_problema_enum NOT NULL,
    descricao       TEXT,
    urgencia        urgencia_enum   NOT NULL DEFAULT 'media',  -- RF07
    latitude        DOUBLE PRECISION NOT NULL,
    longitude       DOUBLE PRECISION NOT NULL,
    status          status_ocorrencia NOT NULL DEFAULT 'pendente',
    protocolo       VARCHAR(20)     UNIQUE,   -- ex: GRB-2026-000001
    municipio       VARCHAR(100),
    logradouro      VARCHAR(300),             -- geocodificação reversa (Google Maps)
    criado_em       TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    atualizado_em   TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- geração automática do protocolo no INSERT
CREATE SEQUENCE seq_protocolo_grb START 1;

CREATE OR REPLACE FUNCTION fn_gerar_protocolo()
RETURNS TRIGGER AS $$
BEGIN
    NEW.protocolo := 'GRB-' || TO_CHAR(NOW(), 'YYYY') || '-'
                     || LPAD(nextval('seq_protocolo_grb')::TEXT, 6, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_protocolo_ocorrencia
    BEFORE INSERT ON ocorrencias
    FOR EACH ROW
    EXECUTE FUNCTION fn_gerar_protocolo();

-- índices para o painel da prefeitura e mapa (RF08, RF10)
CREATE INDEX idx_ocorrencias_status     ON ocorrencias(status);
CREATE INDEX idx_ocorrencias_urgencia   ON ocorrencias(urgencia);
CREATE INDEX idx_ocorrencias_usuario    ON ocorrencias(usuario_id);
CREATE INDEX idx_ocorrencias_municipio  ON ocorrencias(municipio);
CREATE INDEX idx_ocorrencias_criado     ON ocorrencias(criado_em DESC);
-- índice para busca geográfica simples via bounding box (sem PostGIS)
CREATE INDEX idx_ocorrencias_latlon     ON ocorrencias(latitude, longitude);
-- busca de texto na descrição (pg_trgm)
CREATE INDEX idx_ocorrencias_descricao  ON ocorrencias USING GIN(to_tsvector('portuguese', COALESCE(descricao, '')));


-- ============================================================
-- TABELA: imagens
-- Seção 4.5: id, ocorrencia_id, url_imagem, data_upload
-- RF04: envio de fotos
-- ============================================================
CREATE TABLE imagens (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    ocorrencia_id   UUID        NOT NULL REFERENCES ocorrencias(id) ON DELETE CASCADE,
    url_imagem      TEXT        NOT NULL,        -- URL pública (Firebase Storage / S3)
    data_upload     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_imagens_ocorrencia ON imagens(ocorrencia_id);


-- ============================================================
-- TABELA: historico_status
-- Seção 4.5: id, ocorrencia_id, status, data_alteracao,
--            usuario_responsavel
-- RF09: acompanhamento de status / RF11: atualização de status
-- ============================================================
CREATE TABLE historico_status (
    id                  UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    ocorrencia_id       UUID            NOT NULL REFERENCES ocorrencias(id) ON DELETE CASCADE,
    status              status_ocorrencia NOT NULL,
    data_alteracao      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    usuario_responsavel UUID            NOT NULL REFERENCES usuarios(id),
    observacao          TEXT
);

-- trigger: mantém ocorrencias.status e atualizado_em sincronizados
CREATE OR REPLACE FUNCTION fn_sync_status_ocorrencia()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE ocorrencias
    SET status        = NEW.status,
        atualizado_em = NOW()
    WHERE id = NEW.ocorrencia_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sync_status
    AFTER INSERT ON historico_status
    FOR EACH ROW
    EXECUTE FUNCTION fn_sync_status_ocorrencia();

CREATE INDEX idx_historico_ocorrencia ON historico_status(ocorrencia_id);


-- ============================================================
-- TABELA: relatorios
-- Seção 4.5: id, data_geracao, total_ocorrencias,
--            ocorrencias_resolvidas, ocorrencias_pendentes
-- RF12: relatórios estatísticos
-- ============================================================
CREATE TABLE relatorios (
    id                      UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    data_geracao            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    periodo_inicio          DATE,
    periodo_fim             DATE,
    municipio               VARCHAR(100),
    total_ocorrencias       INTEGER     NOT NULL DEFAULT 0,
    ocorrencias_resolvidas  INTEGER     NOT NULL DEFAULT 0,
    ocorrencias_pendentes   INTEGER     NOT NULL DEFAULT 0,
    ocorrencias_em_andamento INTEGER    NOT NULL DEFAULT 0,
    gerado_por              UUID        REFERENCES usuarios(id)
);


-- ============================================================
-- TABELA: sessoes
-- Autenticação JWT — seção 4.2
-- ============================================================
CREATE TABLE sessoes (
    id              UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id      UUID        NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    token_hash      VARCHAR(255) NOT NULL UNIQUE,   -- hash do JWT armazenado
    dispositivo     VARCHAR(200),                   -- "Android 14 / Flutter"
    ip_address      INET,
    expira_em       TIMESTAMPTZ NOT NULL,
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sessoes_usuario_expiracao 
ON sessoes (usuario_id, expira_em DESC);


-- ============================================================
-- DADOS INICIAIS
-- ============================================================

-- Usuário administrador padrão (senha deve ser trocada no primeiro acesso)
-- senha_hash corresponde a bcrypt("admin123")
INSERT INTO usuarios (nome, email, senha_hash, tipo)
VALUES (
    'Administrador GRB',
    'admin@grb.local',
    '$2b$12$placeholderHashTrocaNoDeployOk',
    'admin'
);


-- ============================================================
-- VIEWS PARA O PAINEL DA PREFEITURA (RF08, RF10, RF12)
-- ============================================================

-- Lista completa de ocorrências abertas com dados do solicitante
CREATE VIEW vw_ocorrencias_abertas AS
SELECT
    o.id,
    o.protocolo,
    o.tipo_problema,
    o.urgencia,
    o.status,
    o.descricao,
    o.latitude,
    o.longitude,
    o.municipio,
    o.logradouro,
    u.nome        AS solicitante,
    u.telefone    AS telefone_solicitante,
    COUNT(i.id)   AS total_fotos,
    o.criado_em,
    o.atualizado_em
FROM ocorrencias o
JOIN usuarios u        ON u.id = o.usuario_id
LEFT JOIN imagens i    ON i.ocorrencia_id = o.id
WHERE o.status NOT IN ('resolvido', 'cancelado')
GROUP BY o.id, u.nome, u.telefone
ORDER BY
    CASE o.urgencia WHEN 'alta' THEN 1 WHEN 'media' THEN 2 ELSE 3 END,
    o.criado_em;

-- Resumo por status para a tela inicial do painel
CREATE VIEW vw_resumo_status AS
SELECT
    status,
    COUNT(*)                              AS total,
    COUNT(*) FILTER (WHERE urgencia = 'alta')   AS urgentes
FROM ocorrencias
GROUP BY status;

-- Resumo por tipo de problema (para gráficos — RF12)
CREATE VIEW vw_resumo_tipo_problema AS
SELECT
    tipo_problema,
    COUNT(*)                              AS total,
    COUNT(*) FILTER (WHERE status = 'resolvido') AS resolvidos
FROM ocorrencias
GROUP BY tipo_problema
ORDER BY total DESC;

-- Histórico completo de uma ocorrência (linha do tempo para o morador — RF09)
CREATE VIEW vw_historico_ocorrencia AS
SELECT
    h.ocorrencia_id,
    o.protocolo,
    h.status,
    h.observacao,
    h.data_alteracao,
    u.nome AS responsavel
FROM historico_status h
JOIN ocorrencias o ON o.id = h.ocorrencia_id
JOIN usuarios u    ON u.id = h.usuario_responsavel
ORDER BY h.data_alteracao;


-- ============================================================
-- FUNÇÕES UTILITÁRIAS
-- ============================================================

-- RF08 / app mobile: retorna ocorrências num raio aproximado
-- (cálculo simplificado com bounding box — sem PostGIS)
CREATE OR REPLACE FUNCTION ocorrencias_proximo(
    p_lat    DOUBLE PRECISION,
    p_lon    DOUBLE PRECISION,
    p_km     DOUBLE PRECISION DEFAULT 5.0
)
RETURNS TABLE (
    id            UUID,
    protocolo     VARCHAR,
    tipo_problema tipo_problema_enum,
    urgencia      urgencia_enum,
    status        status_ocorrencia,
    latitude      DOUBLE PRECISION,
    longitude     DOUBLE PRECISION,
    distancia_km  DOUBLE PRECISION
) AS $$
DECLARE
    -- 1 grau de latitude ≈ 111 km
    delta_lat DOUBLE PRECISION := p_km / 111.0;
    delta_lon DOUBLE PRECISION := p_km / (111.0 * COS(RADIANS(p_lat)));
BEGIN
    RETURN QUERY
    SELECT
        o.id,
        o.protocolo,
        o.tipo_problema,
        o.urgencia,
        o.status,
        o.latitude,
        o.longitude,
        -- distância aproximada em km (fórmula equiretangular)
        ROUND(
            SQRT(
                POWER((o.latitude  - p_lat) * 111.0, 2) +
                POWER((o.longitude - p_lon) * 111.0 * COS(RADIANS(p_lat)), 2)
            )::NUMERIC, 2
        )::DOUBLE PRECISION AS distancia_km
    FROM ocorrencias o
    WHERE o.latitude  BETWEEN p_lat - delta_lat AND p_lat + delta_lat
      AND o.longitude BETWEEN p_lon - delta_lon AND p_lon + delta_lon
    ORDER BY distancia_km;
END;
$$ LANGUAGE plpgsql;

-- Função auxiliar: gera snapshot de relatório (RF12)
CREATE OR REPLACE FUNCTION gerar_relatorio(
    p_municipio     VARCHAR  DEFAULT NULL,
    p_inicio        DATE     DEFAULT CURRENT_DATE - INTERVAL '30 days',
    p_fim           DATE     DEFAULT CURRENT_DATE,
    p_usuario_id    UUID     DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_id UUID;
BEGIN
    INSERT INTO relatorios (
        periodo_inicio, periodo_fim, municipio,
        total_ocorrencias, ocorrencias_resolvidas,
        ocorrencias_pendentes, ocorrencias_em_andamento,
        gerado_por
    )
    SELECT
        p_inicio,
        p_fim,
        p_municipio,
        COUNT(*),
        COUNT(*) FILTER (WHERE status = 'resolvido'),
        COUNT(*) FILTER (WHERE status = 'pendente'),
        COUNT(*) FILTER (WHERE status IN ('em_analise','em_andamento')),
        p_usuario_id
    FROM ocorrencias
    WHERE criado_em::DATE BETWEEN p_inicio AND p_fim
      AND (p_municipio IS NULL OR municipio = p_municipio)
    RETURNING id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- EXEMPLOS DE USO (comentados — rodar manualmente para testes)
-- ============================================================

/*
-- Criar ocorrência (equivale ao POST /api/ocorrencias)
INSERT INTO ocorrencias (usuario_id, tipo_problema, descricao, urgencia, latitude, longitude, municipio)
VALUES (
    '<uuid-do-usuario>',
    'buraco',
    'Buraco grande na estrada da Linha Pinhal, próximo ao km 3.',
    'alta',
    -27.2345, -52.0123,
    'Concórdia'
);

-- Atualizar status (equivale ao PUT /api/ocorrencias/:id — RF11)
INSERT INTO historico_status (ocorrencia_id, status, usuario_responsavel, observacao)
VALUES (
    '<uuid-da-ocorrencia>',
    'em_andamento',
    '<uuid-do-fiscal>',
    'Equipe enviada. Previsão de conclusão: 3 dias.'
);

-- Buscar ocorrências perto de Concórdia (app mobile — RF05)
SELECT * FROM ocorrencias_proximo(-27.2334, -52.0270, 10);

-- Gerar relatório do mês de maio/2026 para Concórdia (RF12)
SELECT gerar_relatorio('Concórdia', '2026-05-01', '2026-05-31', '<uuid-admin>');
*/