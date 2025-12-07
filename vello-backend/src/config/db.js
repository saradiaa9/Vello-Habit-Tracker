import mongoose from "mongoose";

export const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("MongoDB connected");
    console.log("Connected to DB:", mongoose.connection.db.databaseName);
  } catch (error) {
    console.error("Database error", error);
    process.exit(1);
  }
};
