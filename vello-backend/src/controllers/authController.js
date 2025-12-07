import User from "../models/User.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

export const registerUser = async (req, res) => {
  try {
    console.log("BODY RECEIVED:", req.body);
    const { name, email, password, username, phoneNumber } = req.body;

    // Validate required fields
    if (!name || !email || !password || !username || !phoneNumber) {
      return res.status(400).json({ msg: "All fields are required" });
    }

    // Check if email already exists
    const emailExists = await User.findOne({ email });
    if (emailExists) {
      return res.status(400).json({ msg: "Email already in use" });
    }

    //Check if username already exists
    const usernameExists = await User.findOne({ username });
    if (usernameExists) {
      return res.status(400).json({ msg: "Username already in use" });
    }

    //Check if phone number already exists
    const phoneNumberExists = await User.findOne({ phoneNumber });
    if (phoneNumberExists) {
      return res.status(400).json({ msg: "Phone number already in use" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    console.log("CREATING USER WITH:", {
  name,
  email,
  password: hashedPassword,
  username,
  phoneNumber,
});

    const newUser = await User.create({
      name,
      email,
      password: hashedPassword,
      username,
      phoneNumber,
    });

    // Create JWT token
    const token = jwt.sign(
      { id: newUser._id },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    // Respond to client
    res.status(201).json({
      msg: "Registration successful",
      user: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        username: newUser.username,
        phoneNumber: newUser.phoneNumber,
      },
      token,
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error", error: error.message });
  }
};

export const loginUser = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Validate
    if (!username || !password) {
      return res.status(400).json({ msg: "Username and password are required" });
    }

    // Find user
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Invalid credentials" });
    }

    // Create JWT
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    // Return data
    res.json({
      msg: "Login successful",
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        username: user.username,
        phoneNumber: user.phoneNumber
      },
      token,
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error", error: error.message });
  }
};

export const getMe = async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password");

    if (!user) {
      return res.status(404).json({ msg: "User not found" });
    }

    res.json({
      msg: "User authenticated",
      user,
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Server error", error: error.message });
  }
};
