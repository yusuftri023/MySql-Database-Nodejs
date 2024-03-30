import { showMaterial } from "../models/material.js";

export const getMaterial = async (req, res) => {
  const { subchapterid } = req.query;
  const result = await showMaterial(subchapterid);
  res.status(200).json(result);
};
