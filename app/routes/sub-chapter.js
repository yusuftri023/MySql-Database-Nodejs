import express from "express";
import { getSubChapter } from "../controllers/sub-chapter.js";
const route = express.Router();
route.get("/subchapters", getSubChapter);
export default route;
