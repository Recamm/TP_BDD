#--TRANSACCIONES--#
delimiter //
create procedure crearpublicacion (
    in p_precio float,
    in p_nivelpublicacion varchar(50),
    in p_estado varchar(50),
    in p_idcategoria int,
    in p_idproducto int,
    in p_dniusuario int,
    in p_tipo varchar(20), -- 'venta' o 'subasta'
    in p_fechainicio datetime,
    in p_fechafin datetime
)
begin
    declare v_idpublicacion int;

    start transaction;

    if p_tipo = 'subasta' and p_fechafin <= p_fechainicio then
        rollback;
        select 'error: la fecha de fin debe ser posterior a la de inicio' as mensaje;
    else
        insert into Publicacion (precio, nivelPublicacion, estado, idCategoria, idProducto, DNIusuario)
        values (p_precio, p_nivelPublicacion, p_estado, p_idCategoria, p_idProducto, p_DNIusuario);

        set v_idpublicacion = last_insert_id();

        if p_tipo = 'subasta' then
            insert into Subasta (fechahorainicio, fechahorafin, idPublicacion)
            values (p_fechainicio, p_fechafin, v_idPublicacion);
        end if;

        commit;
        select 'publicacion creada correctamente' as mensaje;
    end if;
end//
delimiter ;
drop procedure crearpublicacion;
#--Prueba1
insert into Usuario (DNI, nombre, apellido, email, direccion, categoria, reputacion)
values (12345678, 'juan', 'perez', 'juan@email.com', 'av siempre viva 123', 'Normal', 50);

insert into Producto (nombre, marca, descripcion)
values ('celular', 'samsung', 'galaxy a32');

insert into Categoria (nombre)
values ('tecnología');

call crearpublicacion(
    10000,              -- precio
    'Plata',            -- nivelPublicacion
    'En Progreso',      -- estado
    1,                  -- idCategoria (la que insertaste)
    1,                  -- idProducto (el que insertaste)
    12345678,           -- dniUsuario
    'subasta',          -- tipo
    '2025-08-07 10:00:00', -- fecha inicio
    '2025-08-10 10:00:00'  -- fecha fin
);



delimiter //
create procedure actualizarreputacionusuarios()
begin
    start transaction;

    update Usuario u
    join (
        select v.dniusuario, avg(c.calificacion) * 20 as reputacion_calculada
        from Calificacion c
        join Venta v on c.idventa = v.idventa
        group by v.dniusuario
    ) r on u.dni = r.dniusuario
    set u.reputacion = round(r.reputacion_calculada);
    commit;
    
    select 'reputacion de usuarios actualizada' as mensaje;
end//
delimiter ;
# --PRUEBA2
insert into Envio (idEnvio, empresaencargada) values (1, 'correo arg');
insert into Pago (idPago, tipo) values (1, 'efectivo');
insert into Publicacion (idPublicacion, precio, nivelpublicacion, estado, idcategoria, idproducto, dniusuario)
values (10, 2000, 'Bronce', 'En Progreso', 1, 1, 12345678);
insert into Venta (idVenta, fechahora, idPublicacion, dniusuario, idenvio, idpago)
values (11, now(), 10, 12345678, 1, 1);
insert into Calificacion (calificacion, fechahora, idventa)
values (4.5, now(), 11);

drop procedure actualizarreputacionusuarios;
call actualizarreputacionusuarios();

#------FUNCIONES
#------------8------------#
delimiter //
create function responderPregunta(id_pregunta int, id_usuario int, respuesta text) returns text deterministic
begin
    if not exists (select 1 from Pregunta where idPregunta = id_pregunta) then
        return "La pregunta no existe";
    end if;
 
    if id_usuario = (select DNIUsuario from Pregunta where idPregunta = id_pregunta) then
        if (select respuesta from Pregunta where idPregunta = id_pregunta) is not null then
            update Pregunta set Pregunta.respuesta = respuesta where idPregunta = id_pregunta;
            return "Pregunta respondida con exito";
        else
            return "La pregunta ya fue respondida";
        end if;
    else
        return "El usuario no es el vendedor";
    end if;
end//
delimiter ;

select * from Pregunta;
select responderPregunta(1234, 1001, "PRUEBA");
drop function responderPregunta;

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
 
INSERT INTO Publicacion(idPublicacion, precio, nivelPublicacion, estado, fechaHora, idCategoria, idProducto, DNIUsuario) VALUES
(1000, 1000, 'Plata', 'En Progreso', NOW(), 1, 1, 1001);
 
INSERT INTO Pregunta(idPregunta, pregunta, respuesta, fechaHora, idPublicacion, DNIUsuario) VALUES
(1234, '¿Es original?', null, NOW(), 1000, 1001);
 
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