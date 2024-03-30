import { getUserClasses } from "../controllers/class.js";
import express from "express";
const route = express.Router();
route.get("/users/:userId/classes", getUserClasses);

export default route;
