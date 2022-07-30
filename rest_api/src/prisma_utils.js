import { PrismaClient } from "@prisma/client";
import { v4 as uuid } from "uuid";

const prisma = new PrismaClient();

export async function getUserByUsername(username) {
  const user = await prisma.user.findUnique({
    where: {
      username: username,
    },
  });

  return user;
}

export async function getPlayerById(id) {
  const player = await prisma.player.findUnique({
    where: {
      id: id,
    },
  });

  return player;
}

export async function createNewUser(username, password) {
  const new_user = await prisma.user.create({
    data: {
      username: username,
      password: password,
    },
  });

  return new_user;
}

export async function createNewPlayer(id, username) {
  const buidling_id = uuid();
  const new_player = await prisma.player.create({
    data: {
      id: id,
      username: username,
      xp: 0,
      trophy: 0,
      townhall: 1,
      wood: 750,
      stone: 750,
      buildings: {
        [buidling_id]: {
          id: buidling_id,
          class: 0,
          level: 1,
          pos: { x: -256, y: 704 },
          upgrade: {
            status: false,
            start: 0,
            end: 0,
          },
        },
      },
    },
  });

  return new_player;
}

export async function updatePlayerbyId(id, data) {
  const updated_player = await prisma.player.update({
    where: {
      id: id,
    },
    data: data,
  });

  return updated_player;
}

// export async function updateBuildingById(id, data){
//   const upgraded_building = await prisma.player.update({
//     where: {
//       buildings: {
//         path: [id],
//         equals:
//       }
//     }
//   })
// }
