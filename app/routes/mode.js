import express from "express";
import { getLearningMode } from "../controllers/mode.js";
const route = express.Router();
route.get("/modes", getLearningMode);
export default route;
