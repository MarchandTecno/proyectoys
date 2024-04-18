// src/server.js
const express = require('express');
const userDetailsRoutes = require('./routes/userDetailsRoutes');

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.use(userDetailsRoutes);

app.listen(port, () => {
  console.log(`Servidor escuchando en http://localhost:${port}`);
});
