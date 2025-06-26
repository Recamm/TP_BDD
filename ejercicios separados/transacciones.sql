-- 1
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

    start transaction;
    IF tipoPublicacion = 'Subasta' THEN
        INSERT INTO Subasta(fechaHoraInicio, fechaHoraFin, idPublicacion, DNIUsuario)
        VALUES (fechaHoraInicio, fechaHoraFin, idPub, DNIVendedor);
        commit;
    ELSEIF tipoPublicacion = 'VentaDirecta' THEN
        INSERT INTO VentaDirecta(idPago, idEnvio, idPublicacion)
        VALUES (idPago, idEnvio, idPub);
        commit;
    else
        rollback;
        signal sqlstate '45000' set MESSAGE_TEXT = "Error al crear una publicacion"
    end if;

end //
delimiter ;


-- 2
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

    start transaction;
    update Usuario set reputacion = promedio where DNI = iDNI;
    if cantidad > 0 then
        commit;
    else 
        rollback;
        signal sqlstate '45000' set MESSAGE_TEXT = "Error al actualizar reputacion"

end loop bucle;
end //
delimiter ;