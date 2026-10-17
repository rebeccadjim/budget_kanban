-- Active l'extension TimescaleDB dans cette base
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Table normale : les sites radio (peu de lignes, change rarement)
CREATE TABLE site (
    id          BIGSERIAL PRIMARY KEY,
    name        TEXT             NOT NULL,
    lat         DOUBLE PRECISION NOT NULL,
    lon         DOUBLE PRECISION NOT NULL,
    technology  TEXT             NOT NULL CHECK (technology IN ('4G', '5G')),
    status      TEXT             NOT NULL DEFAULT 'ACTIVE'  -- ACTIVE ou SLEEP
);

-- Table de séries temporelles : une ligne par site et par mesure
CREATE TABLE site_metric (
    time           TIMESTAMPTZ      NOT NULL,
    site_id        BIGINT           NOT NULL REFERENCES site (id),
    traffic_mbps   DOUBLE PRECISION,
    prb_load_pct   DOUBLE PRECISION,
    energy_kwh     DOUBLE PRECISION,
    temperature_c  DOUBLE PRECISION,
    PRIMARY KEY (site_id, time)
);

-- Transforme site_metric en hypertable, découpée en chunks par période
SELECT create_hypertable('site_metric', 'time');