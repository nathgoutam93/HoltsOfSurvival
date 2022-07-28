import { PrismaClient } from "@prisma/client";

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
  const new_player = await prisma.player.create({
    data: {
      id: id,
      username: username,
      xp: 0,
      trophy: 0,
      townhall: 1,
      gold: 450,
      oil: 450,
      buildings: JSON.stringify([
        { class: 0, level: 1, pos: { x: -256, y: 704 } },
      ]),
    },
  });

  return new_player;
}
