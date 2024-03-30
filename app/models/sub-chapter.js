import { pool } from "../database/config.js";

export const showSubChapter = async (chapterid) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `select c.id as chapter_id, sc.id as sub_chapter_id, sc.thumbnail, sc.progress, sc.is_free FROM chapter c
    LEFT JOIN sub_chapter sc
    ON c.id = sc.chapter_id
    WHERE c.id = ?;`,
    [chapterid]
  );
  mysqlConnection.release();
  return result;
};
