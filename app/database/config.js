import "dotenv/config";
import mysql from "mysql2/promise";
const {
  DATABASE_HOST,
  DATABASE_USER,
  DATABASE_NAME,
  DATABASE_PASSWORD,
  DATABASE_PORT,
} = process.env;
export const pool = mysql.createPool({
  host: DATABASE_HOST,
  user: DATABASE_USER,
  database: DATABASE_NAME,
  password: DATABASE_PASSWORD,
  multipleStatements: true,
  port: DATABASE_PORT,
});
