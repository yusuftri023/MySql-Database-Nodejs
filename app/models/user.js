import { pool } from "../database/config.js";

export const showUserInfo = async (id) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `SELECT * FROM user where user.id = ?`,
    [id]
  );
  mysqlConnection.release();
  return result;
};
export const showUserProgress = async (id) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `select sum(mc.exp) userTotalExp, sum(mc.gold) userTotalGold  from material m
    inner join material_category mc
    on m.material_category_id =mc.id
    inner join sub_chapter sc
    on m.sub_chapter_id =sc.id
    inner join chapter c
    on sc.chapter_id = c.id
    inner join subject s
    on c.subject_id = s.id
    inner join learning_mode lm
    on s.learning_mode_id =lm.id
    inner join class c2
    on lm.class_id = c2.id
    inner join user u
    on c2.user_id = u.id
    where u.id = ? and m.is_completed is true;`,
    [id]
  );
  mysqlConnection.release();
  return result;
};
export const userIsExist = async (username, email) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `SELECT * FROM user where username = ? or email = ?`,
    [username, email]
  );
  if (result.length === 0) return false;
  else return true;
};
export const insertUser = async (username, password, email) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `INSERT INTO user(username, email, password)
      VALUES (?,?,?)`,
    [username, email, password]
  );
  mysqlConnection.release();
  return result;
};
