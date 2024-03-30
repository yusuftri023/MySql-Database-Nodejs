import {
  getChapter,
  getChapterFreeSubChapter,
} from "../controllers/chapter.js";
import express from "express";
const route = express.Router();
route.get("/chapters", getChapter);
route.get("/chapters/freesubchapters", getChapterFreeSubChapter);
export default route;
