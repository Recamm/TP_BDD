INSERT INTO Usuario(DNI, nombre, apellido, email, direccion, categoria, reputacion) VALUES
(1001, 'Ana', 'Gomez', 'anagomez@gmail.com', 'Calle 123', 'Normal', 85),
(1002, 'Luis', 'Martinez', 'luismartinez@gmail.com', 'Av. Roca 456', 'Platinium', 92),
(1003, 'Sofia', 'Lopez', 'sofialopez@gmail.com', 'Mitre 789', 'Gold', 76),
(1004, 'Carlos', 'Perez', 'carlosperez@gmail.com', 'Urquiza 321', 'Normal', 64),
(1005, 'Lucia', 'Garcia', 'luciagarcia@gmail.com', 'Belgrano 654', 'Gold', 80);
 
INSERT INTO Producto(nombre, marca, descripcion) VALUES
('Celular', 'Samsung', 'Galaxy A52'),
('Notebook', 'HP', 'Core i5, 8GB RAM'),
('TV', 'LG', 'Smart TV 50 pulgadas'),
('Auriculares', 'Sony', 'Bluetooth noise cancelling'),
('Mouse', 'Logitech', 'Inalámbrico');
 
INSERT INTO Categoria(nombre) VALUES
('Tecnología'),
('Electrodomésticos'),
('Accesorios'),
('Computación'),
('Audio y Video');
 
INSERT INTO Publicacion(precio, nivelPublicacion, estado, fechaHora, idCategoria, idProducto, DNIUsuario) VALUES
(1000, 'Plata', 'En Progreso', NOW(), 1, 1, 1001),
(800, 'Oro', 'En Progreso', NOW(), 1, 2, 1002),
(300, 'Bronce', 'Finalizada', NOW(), 3, 3, 1003),
(150, 'Plata', 'Pausada', NOW(), 3, 4, 1004),
(50, 'Oro', 'En Progreso', NOW(), 3, 5, 1005),
(900, 'Platino', 'En Progreso', NOW(), 2, 1, 1001),
(700, 'Plata', 'En Progreso', NOW(), 2, 2, 1002),
(1200, 'Oro', 'Pausada', NOW(), 4, 3, 1003),
(110, 'Bronce', 'Finalizada', NOW(), 4, 4, 1004),
(90, 'Oro', 'Observada', NOW(), 5, 5, 1005);
 
INSERT INTO Pregunta(pregunta, respuesta, fechaHora, idPublicacion, DNIUsuario) VALUES
('¿Incluye cargador?', 'Sí', NOW(), 1, 1002),
('¿Tiene garantía?', 'Un año', NOW(), 2, 1003),
('¿Funciona correctamente?', NULL, NOW(), 3, 1004),
('¿Entrega en el día?', 'Sí', NOW(), 4, 1005),
('¿Acepta permuta?', 'No', NOW(), 5, 1001);
 
INSERT INTO Envio(empresaEncargada) VALUES
('Correo Argentino'),
('Andreani'),
('DHL'),
('OCA'),
('FedEx');
 
INSERT INTO Pago(tipo) VALUES
('Efectivo'),
('Tarjeta de crédito'),
('Tarjeta de débito'),
('Mercado Pago'),
('Transferencia bancaria');
 
INSERT INTO VentaDirecta(idPago, idEnvio, idPublicacion) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5);
 
INSERT INTO Pago_VentaDirecta(idVentaDirec, idPag) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
 
INSERT INTO Envio_VentaDirecta(idVentaDirec, idEnv) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
 
INSERT INTO Subasta(fechaHoraInicio, fechaHoraFin, idPublicacion) VALUES
('2025-06-01 10:00:00', '2025-06-02 10:00:00', 6),
('2025-06-03 10:00:00', '2025-06-04 10:00:00', 7),
('2025-06-05 10:00:00', '2025-06-06 10:00:00', 8),
('2025-06-07 10:00:00', '2025-06-08 10:00:00', 9),
('2025-06-09 10:00:00', '2025-06-10 10:00:00', 10);
 
INSERT INTO Historial(monto, fechaHora, idSubasta, DNIUsuario) VALUES
(910, NOW(), 1, 1002),
(920, NOW(), 1, 1003),
(710, NOW(), 2, 1004),
(1210, NOW(), 3, 1005),
(115, NOW(), 4, 1001);
 
INSERT INTO Venta(fechaHora, idPublicacion, DNIUsuario, idEnvio, idPago) VALUES
(NOW(), 1, 1002, 1, 1),
(NOW(), 2, 1003, 2, 2),
(NOW(), 3, 1004, 3, 3),
(NOW(), 4, 1005, 4, 4),
(NOW(), 5, 1001, 5, 5);
 
INSERT INTO Calificacion(calificacion, fechaHora, idVenta) VALUES
(4.5, NOW(), 1),
(5.0, NOW(), 2),
(3.5, NOW(), 3),
(4.0, NOW(), 4),
(2.5, NOW(), 5);