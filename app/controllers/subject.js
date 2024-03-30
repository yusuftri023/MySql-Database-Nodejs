import { showSubject } from "../models/subject.js";

export const getSubject = async (req, res) => {
  const { modeid } = req.query;
  if (modeid && Number.isInteger(Number(modeid))) {
    const result = await showSubject(modeid);
    res.status(200).json(result);
  } else {
    res.status(403).json({ message: "You are unauthorized" });
  }
};
