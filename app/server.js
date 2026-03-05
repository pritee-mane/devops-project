const http = require("http");

const PORT = process.env.PORT || 3000;
const ENV  = process.env.NODE_ENV || "development";

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({
    message: "Hello from DevOps Project!",
    environment: ENV,
    timestamp: new Date().toISOString(),
  }));
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT} [${ENV}]`);
});
