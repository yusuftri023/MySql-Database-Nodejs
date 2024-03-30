import {
  insertUser,
  showUserInfo,
  showUserProgress,
  userIsExist,
} from "../models/user.js";

export const getUserInfo = async (req, res) => {
  const { id } = req.params;
  const result = await showUserInfo(id);
  res.status(200).json(result);
};
export const getUserProgress = async (req, res) => {
  const { id } = req.params;
  const result = await showUserProgress(id);
  res.status(200).json(result);
};
export const postNewUser = async (req, res) => {
  const { username, password, email } = req.body;
  const exist = await userIsExist(username, email);
  if (!exist) {
    const result = await insertUser(username, password, email);
    res.status(200).json(result);
  } else {
    res.status(200).json({ message: "username or email already exist" });
  }
};
