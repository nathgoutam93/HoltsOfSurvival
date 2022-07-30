import "dotenv/config";
import express, { json } from "express";
import { createServer } from "http";
import cors from "cors";
import { WebSocketServer } from "ws";
import {
  Authenticate,
  authenticateToken,
} from "./middleware/authenticateToken.js";
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
  ws.on("message", async function message(received_data) {
    const { event, data } = JSON.parse(received_data);

    switch (event) {
      case "update":
        updatePlayerbyId(req.user, data);
        break;
      case "Authenticate":
        const authenticated = Authenticate(data.authorization, req);
        if (!authenticated) return ws.close();

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
