// src/controllers/userDetailsController.js
const userService = require('../services/userService');
const { validationResult } = require('express-validator');

exports.getUserDetails = async (req, res) => {
  try {
    // Validar la entrada utilizando express-validator
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const userId = req.params.id;

    // Obtener detalles del usuario utilizando un servicio
    const userDetails = await userService.getUserDetails(userId);

    // Verificar si se encontraron detalles de usuario
    if (!userDetails) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    // Enviar los detalles del usuario como respuesta
    res.json(userDetails);
  } catch (error) {
    console.error('Error al obtener detalles del usuario:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};
