import { pool } from "../database/config.js";

export const showSubject = async (modeid) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `SELECT * FROM learning_mode lm
    LEFT JOIN subject s
    ON lm.id = s.learning_mode_id
    WHERE s.learning_mode_id = ?`,
    [modeid]
  );
  mysqlConnection.release();
  return result;
};
