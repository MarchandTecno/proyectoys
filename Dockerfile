# Usa la imagen base de Node.js
FROM node:14

# Establece el directorio de trabajo en /usr/src/app
WORKDIR /usr/src/app

# Copia el archivo package.json y package-lock.json a /usr/src/app
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de la aplicación
COPY . .

# Expone el puerto 3000 para que la aplicación pueda ser accedida desde fuera del contenedor
EXPOSE 3000

# Comando para iniciar la aplicación cuando el contenedor se ejecute
CMD ["node", "src/server.js"]
