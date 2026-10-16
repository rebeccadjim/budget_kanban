CREATE EXTENSION IF NOT EXISTS timescaledb;

CREATE TABLE site (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  lat DOUBLE PRECISION, lon DOUBLE PRECISION,
  technology TEXT  -- 4G / 5G
);

CREATE TABLE site_metric (
  time TIMESTAMPTZ NOT NULL,
  site_id BIGINT NOT NULL REFERENCES site(id),
  traffic_mbps DOUBLE PRECISION,
  prb_load_pct DOUBLE PRECISION,
  energy_kwh DOUBLE PRECISION,
  temperature_c DOUBLE PRECISION
);
SELECT create_hypertable('site_metric', 'time');