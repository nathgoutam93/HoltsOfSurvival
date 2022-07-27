import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { Router } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
export const router = Router();

router.get("/", async (req, res) => {
  res.send({
    message: "Hashnode_PlanetScaleDB_Hackathon",
  });
});

// router.get("/getUser", authenticateToken, async (req, res, next) => {
//   try {
//     const user = await prisma.user.findUnique({
//       where: {
//         id: req.user,
//       },
//     });

//     res.json({
//       data: user,
//     });
//   } catch (error) {
//     next(error);
//   }
// });

router.post("/signup", async (req, res, next) => {
  try {
    const user = await prisma.user.findUnique({
      where: {
        username: req.body.username,
      },
    });

    if (user != null) {
      const error = new Error("Username already taken");
      error.status = 400;
      return next(error);
    }

    const hashedPassword = await bcrypt.hash(req.body.password, 10);

    const new_user = await prisma.user.create({
      data: {
        username: req.body.username,
        password: hashedPassword,
      },
    });

    await prisma.player.create({
      data: {
        id: new_user.id,
        username: new_user.username,
        xp: 0,
        trophy: 0,
        townhall: 1,
        gold: 1000,
        oil: 1000,
        buildings: JSON.stringify([
          { class: 0, level: 1, pos: { x: 256, y: 256 } },
          { class: 1, level: 1, pos: { x: 256, y: 240 } },
          { class: 2, level: 1, pos: { x: 240, y: 256 } },
        ]),
      },
    });

    res.json({
      data: "Success",
    });
  } catch (error) {
    next(error);
  }
});

router.post("/signin", async (req, res, next) => {
  try {
    const user = await prisma.user.findUnique({
      where: {
        username: req.body.username,
      },
    });

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
