import mongoose from "mongoose";
import crypto from "crypto";

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, unique: true, required: true },
  password: { type: String, required: true },
  username: { type: String, unique: true },
  phoneNumber: {
  type: String,
  unique: true,
  sparse: true, // allows multiple nulls
  match: [/^\+?[1-9]\d{7,14}$/, "Invalid phone number"]
}

}, { timestamps: true });

export default mongoose.model("User", userSchema);
