CREATE TABLE IF NOT EXISTS messages (
    id serial PRIMARY KEY,
    value text NOT NULL,
    event_timestamp bigint NOT NULL,
    process_timestamp bigint NOT NULL
);
