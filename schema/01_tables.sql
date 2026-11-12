CREATE TABLE customers (
    customer_id     NUMBER GENERATED ALWAYS AS IDENTITY,
    customer_type   VARCHAR2(1),    
    national_id     VARCHAR2(11),    
    tax_number      VARCHAR2(10),    
    first_name      VARCHAR2(50),
    last_name       VARCHAR2(50),
    company_name    VARCHAR2(150),
    birth_date      DATE,
    email           VARCHAR2(150),
    phone           VARCHAR2(20),
    city            VARCHAR2(50),
    status          VARCHAR2(10)  DEFAULT 'ACTIVE',
    created_at      TIMESTAMP     DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE  customers               IS 'Sigortalı müşteriler (bireysel ve kurumsal)';
COMMENT ON COLUMN customers.customer_type IS 'I = bireysel, C = kurumsal';
COMMENT ON COLUMN customers.national_id   IS 'T.C. Kimlik No';
COMMENT ON COLUMN customers.tax_number    IS 'Vergi Kimlik No';


CREATE TABLE products(
  product_id NUMBER GENERATED ALWAYS AS IDENTITY,
  product_code VARCHAR2(8 CHAR),
  product_name VARCHAR2(100 CHAR),
  branch VARCHAR2(12 CHAR),
  min_premium NUMBER(12,2),
  is_active CHAR(1) DEFAULT 'Y',
  created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

COMMENT ON TABLE  products              IS 'Sigorta ürünleri: KASKO, TRAFİK, DASK, KONUT, SAĞLIK';
COMMENT ON COLUMN products.product_code IS 'Kısa ürün kodu, ör. KASKO';
COMMENT ON COLUMN products.branch       IS 'Branş: AUTO, PROPERTY, HEALTH, LIFE';
COMMENT ON COLUMN products.min_premium  IS 'En düşük prim tutarı (TL)';

CREATE TABLE policies (
    policy_id      NUMBER GENERATED ALWAYS AS IDENTITY,
    policy_no      VARCHAR2(20 CHAR)  NOT NULL,
    customer_id    NUMBER             NOT NULL,
    product_id     NUMBER             NOT NULL,
    start_date     DATE               NOT NULL,
    end_date       DATE               NOT NULL,
    total_premium  NUMBER(12,2)       NOT NULL,
    status         VARCHAR2(10 CHAR)  DEFAULT 'ACTIVE' NOT NULL,
    cancel_date    DATE,
    created_at     TIMESTAMP          DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at     TIMESTAMP,

    CONSTRAINT pk_policies          PRIMARY KEY (policy_id),
    CONSTRAINT uq_policies_no       UNIQUE (policy_no),
    CONSTRAINT fk_policies_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CONSTRAINT fk_policies_product  FOREIGN KEY (product_id)  REFERENCES products (product_id),
    CONSTRAINT ck_policies_dates    CHECK (end_date > start_date),
    CONSTRAINT ck_policies_premium  CHECK (total_premium > 0),
    CONSTRAINT ck_policies_status   CHECK (status IN ('ACTIVE', 'CANCELLED', 'EXPIRED')),
    CONSTRAINT ck_policies_cancel   CHECK (
           (status =  'CANCELLED' AND cancel_date IS NOT NULL)
        OR (status <> 'CANCELLED' AND cancel_date IS NULL)
    )
);

CREATE INDEX ix_policies_customer ON policies (customer_id);
CREATE INDEX ix_policies_product  ON policies (product_id);