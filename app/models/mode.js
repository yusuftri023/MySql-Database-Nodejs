import { pool } from "../database/config.js";
export const showLearningMode = async (classid) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `SELECT c.id class_id, c.name class_name,lm.id learning_mode_id, lm.name learning_mode_name FROM class c
    LEFT JOIN learning_mode lm
    ON c.id  = lm.class_id
    WHERE c.id = ?;
`,
    [classid]
  );

  mysqlConnection.release();
  return result;
};
