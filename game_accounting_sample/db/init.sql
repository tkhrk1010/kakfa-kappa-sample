CREATE TABLE IF NOT EXISTS game_application (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    applied_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS game_usage (
    id UUID PRIMARY KEY,
    game_application_id UUID REFERENCES game_application(id),
    used_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS game_cancel_before_use (
    id UUID PRIMARY KEY,
    game_application_id UUID REFERENCES game_application(id),
    canceled_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS game_cancel_after_use (
    id UUID PRIMARY KEY,
    game_application_id UUID REFERENCES game_application(id),
    canceled_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS credits (
    id UUID PRIMARY KEY,
    game_application_id UUID NOT NULL,
    incurred_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- game_application table dummy data
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM game_application) THEN
        INSERT INTO game_application (id, user_id, applied_at, created_at, updated_at) VALUES
            (gen_random_uuid(), gen_random_uuid(), NOW(), NOW(), NOW()),
            (gen_random_uuid(), gen_random_uuid(), NOW(), NOW(), NOW()),
            (gen_random_uuid(), gen_random_uuid(), NOW(), NOW(), NOW()),
            (gen_random_uuid(), gen_random_uuid(), NOW(), NOW(), NOW()),
            (gen_random_uuid(), gen_random_uuid(), NOW(), NOW(), NOW());
    END IF;
END $$;

-- game_usage table dummy data
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM game_usage) THEN
        WITH ga AS (
            SELECT id FROM game_application LIMIT 3
        )
        INSERT INTO game_usage (id, game_application_id, used_at, created_at, updated_at) 
        SELECT gen_random_uuid(), ga.id, NOW(), NOW(), NOW() FROM ga;
    END IF;
END $$;

-- game_cancel_before_use table dummy data
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM game_cancel_before_use) THEN
        INSERT INTO game_cancel_before_use (id, game_application_id, canceled_at, created_at, updated_at) 
        SELECT 
            gen_random_uuid(), 
            ga.id, 
            NOW(), 
            NOW(), 
            NOW()
        FROM game_application ga
        WHERE ga.id NOT IN (SELECT game_application_id FROM game_usage)
        LIMIT 1;
    END IF;
END $$;


-- game_cancel_after_use table dummy data
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM game_cancel_after_use) THEN
        INSERT INTO game_cancel_after_use (id, game_application_id, canceled_at, created_at, updated_at) 
        SELECT 
            gen_random_uuid(), 
            gu.game_application_id, 
            NOW(), 
            NOW(), 
            NOW()
        FROM game_usage gu
        WHERE gu.game_application_id NOT IN (SELECT game_application_id FROM game_cancel_before_use)
        LIMIT 1;
    END IF;
END $$;
