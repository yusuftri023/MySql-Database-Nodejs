import { showSubChapter } from "../models/sub-chapter.js";

export const getSubChapter = async (req, res) => {
  const { chapterid } = req.query;
  if (chapterid) {
    const result = await showSubChapter(chapterid);
    res.status(200).json(result);
  } else res.status(403).json({ message: "You are unauthorized" });
};
