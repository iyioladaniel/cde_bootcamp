CREATE TABLE region (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
CREATE TABLE sales_reps (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES region(id) ON DELETE SET NULL
);
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    website VARCHAR(255),
    lat DECIMAL(10, 7),
    long DECIMAL(10, 7),
    primary_poc VARCHAR(255),
    sales_rep_id INT,
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(id) ON DELETE SET NULL
);
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    occurred_at TIMESTAMP NOT NULL,
    standard_qty INT DEFAULT 0,
    gloss_qty INT DEFAULT 0,
    poster_qty INT DEFAULT 0,
    total INT,
    standard_amt_usd DECIMAL(10, 2),
    gloss_amt_usd DECIMAL(10, 2),
    poster_amt_usd DECIMAL(10, 2),
    total_amt_usd DECIMAL(10, 2),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);
CREATE TABLE web_events (
    id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    occurred_at TIMESTAMP NOT NULL,
    channel VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);