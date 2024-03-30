import {
  getUserInfo,
  getUserProgress,
  postNewUser,
} from "../controllers/user.js";
import express from "express";
const route = express.Router();
route.get("/users/:id", getUserInfo);
route.get("/users/:id/progress", getUserProgress);
route.post("/users", postNewUser);
export default route;
