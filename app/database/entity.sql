DROP TABLE IF EXISTS customer, product, category, shipment,
payment, order, order_item, wishlist, cart;

CREATE TABLE customer(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    phone_number varchar(20)
)

CREATE TABLE product(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    stock INT NOT NULL,
    category_id INT,
    CONSTRAINT fk_product_category Foreign Key (category_id) REFERENCES category(id)
)
CREATE TABLE category(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
)
CREATE TABLE shipment(
    id INT GENERATED ALWAYS as IDENTITY PRIMARY KEY,
    shipment_date DATETIME,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(20),
    zip_code VARCHAR(10),
    customer_id INT NOT NULL,
    CONSTRAINT fk_customer_shipment Foreign Key (customer_id) REFERENCES customer(id)
)
CREATE TABLE payment(
    id INT GENERATED ALWAYS AS IDENTITY,
    payment_date DATETIME,
    payment_method VARCHAR(100) NOT NULL,
    amount INT NOT NULL,
    customer_id INT NOT NULL,
    CONSTRAINT fk_customer_payment Foreign Key (customer_id) REFERENCES customers(id)
)
CREATE TABLE order(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date DATETIME,
    total_price INT NOT NULL,
    customer_id INT NOT NULL,
    payment_id INT,
    shipment_id INT,
    CONSTRAINT fk_customer_order Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_payment_order Foreign Key (payment_id) REFERENCES payment(id),
    CONSTRAINT fk_shipment_order Foreign Key (shipment_id) REFERENCES shipment(id)

)
CREATE TABLE order_item(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quantity INT NOT NULL,
    price INT NOT NULL,
    product_id INT NOT NULL,
    order_id INT,
    CONSTRAINT fk_order_order_item Foreign Key (order_id) REFERENCES order(id),
    CONSTRAINT fk_product_order_item Foreign Key (product_id) REFERENCES product(id)


)
CREATE TABLE wishlist(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT,
    product_id INT,
    CONSTRAINT fk_customer_wishlist Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_product_wishlist Foreign Key (product_id) REFERENCES product(id)
)
CREATE TABLE cart(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quantity INT,
    customer_id INT,
    product_id INT,
    PRIMARY KEY(cart_id)
    CONSTRAINT fk_customer_cart Foreign Key (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_product_cart Foreign Key (product_id) REFERENCES product(id)
)