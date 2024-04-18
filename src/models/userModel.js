// src/models/userModel.js
const db = require('../config/dbConfig');

exports.getUserDetails = (userId, callback) => {
  const query = `CALL ObtenerDetallesUsuario(${userId}, @nombre, @email, @resultado)`;
  db.query(query, (error, results) => {
    if (error) {
      callback(error, null); // Devuelve el error a la función de devolución de llamada
    } else {
      db.query('SELECT @nombre AS nombre, @email AS email, @resultado AS resultado', (innerError, innerResults) => {
        if (innerError) {
          callback(innerError, null); // Devuelve el error a la función de devolución de llamada
        } else {
          const { nombre, email, resultado } = innerResults[0];
          callback(null, { nombre, email, resultado }); // Devuelve el resultado a la función de devolución de llamada
        }
      });
    }
  });
};
