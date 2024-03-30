import { showLearningMode } from "../models/mode.js";

export const getLearningMode = async (req, res) => {
  const { classid } = req.query;
  const result = await showLearningMode(classid);
  res.status(200).json(result);
};
