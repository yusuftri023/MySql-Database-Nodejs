import express from "express";
import { getMaterial } from "../controllers/material.js";
const route = express.Router();
route.get("/material", getMaterial);

export default route;
