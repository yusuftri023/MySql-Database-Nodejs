DROP TABLE IF EXISTS customer, product, category,variation,variation_option,product_config, shipment,
payment, payment_method, order_detail, order_item, wishlist, cart, customer_address,
address_detail , promotion, promotion_category;

CREATE TABLE customer(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    phone_number varchar(20),
    last_password_update timestamp(0) not null default now()
);
CREATE TABLE address_detail(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    address_line VARCHAR(255),
    city VARCHAR(25),
    region VARCHAR(25),
    postal_code VARCHAR(10)
);
CREATE TABLE customer_address(
    customer_id INT not null,
    address_id INT,
    CONSTRAINT fk_customer_customer_address Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_address_customer_address Foreign Key (address_id) REFERENCES address_detail(id)
);

CREATE TABLE shipment(
    id INT GENERATED ALWAYS as IDENTITY PRIMARY KEY,
    shipment_date timestamp(0),
    address_id INT NOT NULL,
    customer_id INT NOT NULL,
    CONSTRAINT fk_customer_shipment Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_address_shipment Foreign Key (address_id) REFERENCES address_detail(id)
);
CREATE TABLE category(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);
CREATE TABLE promotion(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    discount_rate DECIMAL(5,2) NOT NULL,
    start_date timestamp(0) NOT NULL,
    end_date timestamp(0) NOT NULL
);
CREATE TABLE product(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    stock INT NOT NULL,
    image varchar(255) default 'https://ik.imagekit.io/neuros123/product-placeholder-wp.jpg?updatedAt=1710562973427',
    category_id INT,
    CONSTRAINT fk_product_category Foreign Key (category_id) REFERENCES category(id)
);
create table variation(
	id int generated always as identity primary key,
	category_id int not null,
	name varchar(25) not null,
	constraint fk_category_variation foreign key (category_id) references category(id)
);
create table variation_option(
	id int generated always as identity primary key,
	variation_id int not null,
	value varchar(100) not null,
	constraint fk_variation_option foreign key (variation_id) references variation(id)
);
create table product_config(
	product_id int not null,
	variation_option_id int not null,
	constraint fk_product_config foreign key (product_id) references product(id),
	constraint fk_product_variation_option foreign key (variation_option_id) references variation_option(id)
);

create table payment_method(
	id INT generated always as identity primary key,
	name varchar(25) not null
);
create TABLE payment(
    id INT GENERATED ALWAYS AS identity primary key,
    payment_date timestamp(0) not null default now() + interval '2' day,
    amount INT NOT NULL,
    customer_id INT NOT NULL,
    payment_method_id int not null,
    CONSTRAINT fk_customer_payment Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_payment_method Foreign Key (payment_method_id) REFERENCES payment_method(id)
);


CREATE TABLE order_detail(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date timestamp(0) not null default now(),
    total_price INT NOT NULL,
    customer_id INT NOT NULL,
    shipment_id INT,
    payment_id INT,
    CONSTRAINT fk_customer_order_detail Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_payment_order_detail Foreign Key (payment_id) REFERENCES payment(id),
    CONSTRAINT fk_shipment_order_detail Foreign Key (shipment_id) REFERENCES shipment(id)

);
CREATE TABLE order_item(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quantity INT NOT NULL,
    price INT NOT NULL,
    product_id INT NOT NULL,
    order_id INT,
    CONSTRAINT fk_order_order_item Foreign Key (order_id) REFERENCES order_detail(id),
    CONSTRAINT fk_product_order_item Foreign Key (product_id) REFERENCES product(id)


);
CREATE TABLE wishlist(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT,
    product_id INT,
    CONSTRAINT fk_customer_wishlist Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_product_wishlist Foreign Key (product_id) REFERENCES product(id)
);
CREATE TABLE cart(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quantity INT,
    customer_id INT,
    product_id INT,
    CONSTRAINT fk_customer_cart Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_product_cart Foreign Key (product_id) REFERENCES product(id)
);


CREATE TABLE promotion_category(
    category_id INT,
    promotion_id INT,
    CONSTRAINT fk_category_promotion Foreign Key (category_id) REFERENCES category(id),
    CONSTRAINT fk_promotion_promotion_category Foreign Key (promotion_id) REFERENCES promotion(id)
);

INSERT INTO category(name, description)
VALUES ('electronics', 'electronic category'),
       ('home goods', 'home good category'),
       ('clothings', 'clothing category');


create or replace TRIGGER update_password after  UPDATE ON customer
        FOR EACH row
        execute procedure last_updated();
CREATE OR REPLACE FUNCTION last_updated()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS
$$
BEGIN
	IF NEW.password <> OLD.password THEN
		 update customer
		 set last_password_update = now()
		 where id = old.id;
	END IF;

	RETURN NEW;
END;
$$
