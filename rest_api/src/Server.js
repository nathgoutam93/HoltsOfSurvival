import "dotenv/config";
import express, { json } from "express";
import { createServer } from "http";
import { WebSocketServer } from "ws";
import { authenticateToken } from "./middleware/authenticateToken.js";
import { PrismaClient } from "@prisma/client";
import { router } from "./routes/api.route.js";

const PORT = process.env.PORT;

const app = express();
app.use(express.json());

const server = createServer(app);

app.use("/api", router);

const prisma = new PrismaClient();

const wss = new WebSocketServer({
  verifyClient: function ({ req }, res) {
    authenticateToken(req, res);
  },
  server,
});

async function getPlayerById(id) {
  const player = await prisma.player.findUnique({
    where: {
      id: id,
    },
  });

  return player;
}

wss.on("connection", function connection(ws, req) {
  ws.on("message", async function message(received_data) {
    const { event, data } = JSON.parse(received_data);

    switch (event) {
      case "player":
        const player = await getPlayerById(req.user);
        ws.send(
          JSON.stringify({
            event: "player",
            data: player,
          })
        );
        break;
      case "message":
        console.log(data);
      default:
        break;
    }
  });

  console.log(`${req.user} connected`);

  ws.on("close", (code, reason) => {
    console.log(`${req.user} dissconnected, reason: ${code}`);
  });
});

app.use((error, req, res, next) => {
  res.status(error.status || 500);
  res.json({
    error: {
      message: error.message,
    },
  });
});

server.listen(PORT, () => {
  console.log(`server listening on port ${PORT}`);
});
