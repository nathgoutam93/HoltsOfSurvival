import jwt from "jsonwebtoken";

export function authenticateToken(req, res) {
  const token = req.headers.authorization;

  if (token == null) return res(false, 401, "Unauthorized");

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (error, user) => {
    if (error) return res(false, 403, "Forbidden");

    req.user = user;
    res(true);
  });
}

export function Authenticate(token, req) {
  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (error, user) => {
    if (error) return false;

    req.user = user;
  });

  return true;
}
