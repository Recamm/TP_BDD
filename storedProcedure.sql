/*STORED PROCEDURE*/
-- 1
delimiter //
create procedure BuscarPublicacion(IN nombreProducto text)
begin
	select pu.idPublicacion, p.nombre, c.nombre, pu.precio from Publicacion as pu join Producto as p ON p.idProducto = pu.idProducto join Categoria as c ON pu.idCategoria = c.idCategoria
	WHERE p.nombre = nombreProducto; 
end //
delimiter ;
call BuscarPublicacion("Celular");
drop procedure BuscarPublicacion;
 
-- 2
delimiter //
create procedure crearPublicacion(IN precio FLOAT, IN nivelPublicacion text, IN estado text, IN idCategoria INT, IN idProducto INT, IN DNIVendedor INT, IN tipoPublicacion text, -- 'Subasta' o 'VentaDirecta'
    IN fechaHoraInicio DATETIME, -- subasta
    IN fechaHoraFin DATETIME,    -- subasta
    IN idPago INT,               -- venta directa
    IN idEnvio INT               -- venta directa
)
begin
    declare idPub INT;
    INSERT INTO Publicacion(precio, nivelPublicacion, estado, idCategoria, idProducto, DNIusuario)
    VALUES (precio, nivelPublicacion, estado, idCategoria, idProducto, DNIVendedor);
	-- idPublicacion de insert recien ingresado 
    set idPub = (SELECT idPublicacion
    FROM Publicacion
    WHERE precio = precio 
      AND nivelPublicacion = nivelPublicacion
      AND estado = estado
      AND idCategoria = idCategoria
      AND idProducto = idProducto
      AND DNIVendedor = DNIVendedor
    ORDER BY idPublicacion DESC
    LIMIT 1);
    IF tipoPublicacion = 'Subasta' THEN
        INSERT INTO Subasta(fechaHoraInicio, fechaHoraFin, idPublicacion, DNIUsuario)
        VALUES (fechaHoraInicio, fechaHoraFin, idPub, DNIVendedor);
    ELSEIF tipoPublicacion = 'VentaDirecta' THEN
        INSERT INTO VentaDirecta(idPago, idEnvio, idPublicacion)
        VALUES (idPago, idEnvio, idPub);
    END IF;
end //
delimiter ;
CALL crearPublicacion(
  1500,               -- precio
  'Oro',              -- nivelPublicacion
  'En Progreso',      -- estado
  1,                  -- idCategoria
  1,                  -- idProducto
  1001,               -- DNIVendedor
  'VentaDirecta',     -- tipoPublicacion
  NULL, NULL,         -- fechas (no se usan para VentaDirecta)
  1,                  -- idPago
  1                   -- idEnvio
);
DROP PROCEDURE crearPublicacion;
 
 
-- 3
delimiter //
create procedure verPreguntas (IN idPubli text)
begin 
	select pregunta, fechaHora from Pregunta
    where idPublicacion = idPubli;
end //
delimiter ;
CALL verPreguntas('1'); 
DROP PROCEDURE verPreguntas;
 
-- 4
delimiter //
create procedure actualizarReputacionUsuario ()
begin
	declare promedio float;
    declare Idventass, suma, cantidad, iDNI int;
    declare hayFilas int default 0;
    declare recorrer CURSOR FOR select DNI from Usuario;
    declare continue HANDLER FOR not found set hayFilas = 1;
	open recorrer;
    bucle:loop
		fetch recorrer into iDNI;
        if hayFilas = 1 then
			leave bucle;
		end if;
	set Idventass = (select idVenta from Venta where DNIUsuario = iDNI);
    set suma = (select sum(calificacion) from Calificacion where idVenta = Idventass);
    set cantidad = (select count(idCalificacion) from Calificacion where idVenta = Idventass);
    set promedio = suma / cantidad;
    update Usuario set reputacion = promedio where DNI = iDNI;
end loop bucle;
end //
delimiter ;
CALL actualizarReputacionUsuario();
DROP PROCEDURE actualizarReputacionUsuario;