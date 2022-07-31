import "dotenv/config";
import express, { json } from "express";
import { createServer } from "http";
import cors from "cors";
import { WebSocketServer } from "ws";
import { Authenticate } from "./middleware/authenticateToken.js";
import { router } from "./routes/api.route.js";
import { getPlayerById, updatePlayerbyId } from "./prisma_utils.js";

const PORT = process.env.PORT;
const app = express();

app.use(cors());
app.use(json());

const server = createServer(app);

app.use("/api", router);

const wss = new WebSocketServer({
  // verifyClient: function ({ req }, res) {
  //   authenticateToken(req, res);
  // },
  server,
});

wss.on("connection", function connection(ws, req) {
  ws.isAlive = true;

  ws.on("message", async function message(received_data) {
    const { event, data } = JSON.parse(received_data);

    switch (event) {
      case "update":
        updatePlayerbyId(req.user, data);
        break;
      case "Authenticate":
        const authenticated = Authenticate(data, req);
        if (!authenticated) return ws.close();

        const player = await getPlayerById(req.user);
        ws.send(
          JSON.stringify({
            event: "player",
            data: player,
          })
        );
        break;
      case "time":
        const timestamp = Math.round(new Date().getTime() / 1000);
        ws.send(
          JSON.stringify({
            event: "time",
            data: timestamp,
          })
        );
      case "pong":
        ws.isAlive = true;

      case "message":
        console.log(data);
        break;
      default:
        break;
    }
  });

  ws.send(
    JSON.stringify({
      event: "Authenticate",
      data: "",
    })
  );

  ws.on("close", (code, reason) => {
    console.log(`${req.user} dissconnected, reason: ${code}`);
  });
});

const interval = setInterval(() => {
  wss.clients.forEach((ws) => {
    if (ws.isAlive === false) return ws.terminate();

    ws.isAlive = false;

    ws.send(
      JSON.stringify({
        event: "ping",
        data: "",
      })
    );
  });
}, 20000);

wss.on("close", function close() {
  clearInterval(interval);
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
