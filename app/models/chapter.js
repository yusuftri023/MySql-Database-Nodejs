import { pool } from "../database/config.js";

export const showChapter = async (subjectid) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `SELECT * FROM subject s
    LEFT JOIN chapter c
    ON s.id = c.subject_id
    WHERE c.subject_id = ?`,
    [subjectid]
  );
  mysqlConnection.release();
  return result;
};
export const showFreeSubChapter = async (subjectid) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query(
    `select chapter_id ,chapter_name, chapter_progress,count(sub_chapter_id) as free_sub_chapter_number from
    (SELECT s.id subject_id , s.name  as subject_name, c.id chapter_id, c.name as chapter_name,c.thumbnail,c.progress as chapter_progress, sc.id as sub_chapter_id,sc.name as sub_chapter_name,sc.is_free FROM subject s
    LEFT JOIN chapter c
    ON s.id = c.subject_id
    LEFT JOIN sub_chapter sc
    ON c.id = sc.chapter_id
    WHERE s.id = ? and is_free is true) as subject_content
    group by chapter_id;`,
    [subjectid]
  );
  mysqlConnection.release();
  return result;
};
