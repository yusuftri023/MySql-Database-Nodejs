import pg from "pg";
import fs from "fs";
const dbConfig = {
  user: "yusuf",
  host: "localhost",
  database: "ecommerce",
  password: "Bagufix1",
  port: 5432,
};
const seedDB = async () => {
  const json = fs.readFileSync("./app/database/MOCK_DATA.json");
  const data = JSON.parse(json);
  const client = new pg.Client(dbConfig);
  client.connect();
  //   await client.query(`
  //     create table product (
  //     akun_id INT primary key generated always as identity,
  //     product_name varchar not null,
  //     price INT not null,
  //     quantity INT not null,
  //     category varchar not null,
  //     brand varchar not null,
  //     image varchar not null,
  //     rate decimal not null,
  //     count INT not null );
  //     `);

  data.forEach(async (val) => {
    await client.query(
      `INSERT INTO product(product_name, price, quantity, category, brand, image,rate,count)
    VALUES ($1::varchar,$2::INT,$3::INT,$4::varchar,$5::varchar,$6::varchar,$7::decimal,$8::INT);`,
      [
        val.product_name,
        val.price,
        val.quantity,
        val.category,
        val.brand,
        val.image,
        val.rate,
        val.count,
      ]
    );
  });
};
seedDB().then(() => console.log("berhasil seeding"));
