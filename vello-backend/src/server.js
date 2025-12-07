import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { connectDB } from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

connectDB();

// routes

app.get("/test", (req, res) => {
  res.json({ message: "Server route works" });
});

app.use("/api/auth", authRoutes);

app.listen(process.env.PORT || 5000, () =>
  console.log("Server running on port " + process.env.PORT)
);
