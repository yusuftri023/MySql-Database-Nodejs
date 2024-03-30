import express from "express";
import { getSubject } from "../controllers/subject.js";
const route = express.Router();
route.get("/subjects", getSubject);
export default route;
