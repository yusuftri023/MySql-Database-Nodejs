import cookieParser from "cookie-parser";

import express from "express";
import router from "./app/routes/index.js";
import logger from "./app/middleware/logger.js";

const app = express();
const PORT = 3000;

app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(logger);
app.use(router);

app.get("/", async (req, res) => {
  const mysqlConnection = await pool.getConnection();
  const [result] = await mysqlConnection.query("SELECT * FROM material");

  mysqlConnection.release();
  res.status(200).json(result);
});
app.listen(PORT, () =>
  console.log(`Server running at port: http://127.0.0.1:${PORT}`)
);
