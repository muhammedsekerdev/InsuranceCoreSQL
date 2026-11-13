INSERT INTO products (product_code, product_name, branch, min_premium) VALUES
    ('KASKO',  'Genişletilmiş Kasko Sigortası', 'AUTO',     2500),
    ('TRAFIK', 'Zorunlu Trafik Sigortası',      'AUTO',     3000),
    ('DASK',   'Zorunlu Deprem Sigortası',      'PROPERTY',  300),
    ('KONUT',  'Konut Paket Sigortası',         'PROPERTY',  800),
    ('SAGLIK', 'Tamamlayıcı Sağlık Sigortası',  'HEALTH',   4000);

INSERT INTO customers (customer_type, national_id, first_name, last_name, birth_date, email, city) VALUES
    ('I', '12345678901', 'Ayşe',   'Yılmaz', DATE '1990-04-12', 'ayse@example.com',   'İstanbul'),
    ('I', '23456789012', 'Mehmet', 'Demir',  DATE '1985-09-30', 'mehmet@example.com', 'Ankara'),
    ('I', '34567890123', 'Zeynep', 'Kaya',   DATE '1998-01-05', NULL,                 'İzmir');

INSERT INTO customers (customer_type, tax_number, company_name, city) VALUES
    ('C', '1234567890', 'Deniz Lojistik A.Ş.', 'İzmir');

INSERT INTO policies (policy_no, customer_id, product_id, start_date, end_date, total_premium)
VALUES ('POL-2026-000001',
        (SELECT customer_id FROM customers WHERE national_id  = '12345678901'),
        (SELECT product_id  FROM products  WHERE product_code = 'KASKO'),
        DATE '2026-01-15', DATE '2027-01-15', 12500);

INSERT INTO policies (policy_no, customer_id, product_id, start_date, end_date, total_premium)
VALUES ('POL-2026-000002',
        (SELECT customer_id FROM customers WHERE national_id  = '23456789012'),
        (SELECT product_id  FROM products  WHERE product_code = 'TRAFIK'),
        DATE '2026-02-01', DATE '2027-02-01', 3800);

INSERT INTO policies (policy_no, customer_id, product_id, start_date, end_date, total_premium)
VALUES ('POL-2026-000003',
        (SELECT customer_id FROM customers WHERE tax_number   = '1234567890'),
        (SELECT product_id  FROM products  WHERE product_code = 'KASKO'),
        DATE '2026-03-10', DATE '2027-03-10', 48000);

COMMIT;