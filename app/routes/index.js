import express from "express";
import userRoute from "./user.js";
import classRoute from "./class.js";
import modeRoute from "./mode.js";
import subjectRoute from "./subject.js";
import chapterRoute from "./chapter.js";
import subChapterRoute from "./sub-chapter.js";
import materialRoute from "./material.js";
const router = express.Router();

router.use(userRoute);
router.use(classRoute);
router.use(modeRoute);
router.use(subjectRoute);
router.use(chapterRoute);
router.use(subChapterRoute);
router.use(materialRoute);
export default router;
