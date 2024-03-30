import { showUserClasses } from "../models/class.js";

export const getUserClasses = async (req, res) => {
  const { userId } = req.params;
  const result = await showUserClasses(userId);
  res.status(200).json(result);
};
