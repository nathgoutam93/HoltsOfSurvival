import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { Router } from "express";
import {
  getUserByUsername,
  createNewUser,
  createNewPlayer,
} from "../prisma_utils.js";

export const router = Router();

router.get("/", async (req, res) => {
  res.send({
    message: "Hashnode_PlanetScaleDB_Hackathon",
  });
});

router.post("/signup", async (req, res, next) => {
  try {
    const user = await getUserByUsername(req.body.username);

    if (user != null) {
      const error = new Error("Username already taken");
      error.status = 400;
      return next(error);
    }

    const hashedPassword = await bcrypt.hash(req.body.password, 10);

    const new_user = await createNewUser(req.body.username, hashedPassword);

    await createNewPlayer(new_user.id, new_user.username);

    res.json({
      data: "Success",
    });
  } catch (error) {
    next(error);
  }
});

router.post("/signin", async (req, res, next) => {
  try {
    const user = await getUserByUsername(req.body.username);

    if (user == null) {
      const error = new Error("User not found");
      error.status = 400;
      return next(error);
    }

    if (await bcrypt.compare(req.body.password, user.password)) {
      // generate an access token and send it to user
      const access_token = jwt.sign(user.id, process.env.ACCESS_TOKEN_SECRET);

      res.json({
        data: access_token,
      });
    } else {
      const error = new Error("User credentials not matched");
      error.status = 400;
      return next(error);
    }
  } catch (error) {
    next(error);
  }
});
