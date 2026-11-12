ALTER TABLE customers ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);
ALTER TABLE products RENAME CONSTRAINT pk_product_id TO pk_products;

ALTER TABLE customers ADD(
  updated_at TIMESTAMP
);

ALTER TABLE customers MODIFY (
  customer_type CONSTRAINT nn_customers_type NOT NULL,
  status CONSTRAINT nn_customers_status NOT NULL,
  created_at CONSTRAINT nn_customers_created_at NOT NULL
);

ALTER TABLE customers ADD CONSTRAINT uq_customers_national_id UNIQUE (national_id);
ALTER TABLE customers ADD CONSTRAINT uq_customers_tax_number UNIQUE (tax_number);

ALTER TABLE customers ADD CONSTRAINT ck_customers_type
    CHECK (customer_type IN ('I', 'C'));

ALTER TABLE customers ADD CONSTRAINT ck_customers_status
    CHECK (status IN ('ACTIVE', 'PASSIVE'));

ALTER TABLE customers ADD CONSTRAINT ck_customers_national_id
    CHECK (REGEXP_LIKE(national_id, '^[1-9][0-9]{10}$'));

ALTER TABLE customers ADD CONSTRAINT ck_customers_tax_number
    CHECK (REGEXP_LIKE(tax_number, '^[0-9]{10}$'));

ALTER TABLE customers ADD CONSTRAINT ck_customers_email
    CHECK (REGEXP_LIKE(email, '^[^@ ]+@[^@ ]+\.[^@ ]+$'));

ALTER TABLE customers ADD CONSTRAINT ck_customers_identity CHECK (
       (customer_type = 'I' AND national_id  IS NOT NULL
                            AND first_name   IS NOT NULL
                            AND last_name    IS NOT NULL)
    OR (customer_type = 'C' AND tax_number   IS NOT NULL
                            AND company_name IS NOT NULL)
);

ALTER TABLE products ADD CONSTRAINT pk_product_id PRIMARY KEY(product_id);
ALTER TABLE products MODIFY(
  product_code NOT NULL,
  product_name NOT NULL,
  branch NOT NULL,
  min_premium NOT NULL,
  is_active NOT NULL,
  created_at NOT NULL
);
ALTER TABLE products ADD CONSTRAINT ck_min_premium
CHECK (min_premium>0)