import { pool } from "../database/config.js";
export const showUserClasses = async (userId) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `SELECT u.username , c.* FROM user u
    LEFT JOIN class c
    ON u.id = c.user_id
    where u.id = ?`,
    [userId]
  );
  mysqlConnection.release();
  return result;
};
