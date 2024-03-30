import { showChapter, showFreeSubChapter } from "./../models/chapter.js";

export const getChapter = async (req, res) => {
  const { subjectid } = req.query;

  if (subjectid) {
    const result = await showChapter(subjectid);
    res.status(200).json(result);
  } else res.status(403).json({ message: "You are unauthorized" });
};
export const getChapterFreeSubChapter = async (req, res) => {
  const { subjectid } = req.query;
  if (subjectid) {
    const result = await showFreeSubChapter(subjectid);
    res.status(200).json(result);
  } else res.status(403).json({ message: "You are unauthorized" });
};
