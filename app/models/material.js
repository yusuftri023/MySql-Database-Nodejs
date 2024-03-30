import { pool } from "../database/config.js";
export const showMaterial = async (subchapterid) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `SELECT m.id, m.name,m.thumbnail,m.is_completed, mc.name as category, mc.exp, mc.gold FROM sub_chapter sc
    LEFT JOIN material m
    on sc.id = m.sub_chapter_id
    INNER JOIN material_category mc
    on m.material_category_id = mc.id
    where sc.id = ?;`,
    [subchapterid]
  );
  mysqlConnection.release();
  return result;
};
