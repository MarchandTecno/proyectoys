// src/routes/userDetailsRoutes.js
const express = require('express');
const router = express.Router();
const { param } = require('express-validator');

const userDetailsController = require('../controllers/userDetailsController');

// Definir reglas de validación para el parámetro de ID de usuario
const validateUserId = [
  param('id').isInt().withMessage('El ID de usuario debe ser un número entero'),
];

// Ruta para obtener detalles de usuario por ID
router.get('/api/detalles-usuario/:id', validateUserId, userDetailsController.getUserDetails);

module.exports = router;
