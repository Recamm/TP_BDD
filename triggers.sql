-- 1
delimiter //
create trigger borrarPreguntas before delete on Publicacion
for each row
begin
    delete from `Pregunta` where `idPublicacion` = old.`idPublicacion`;
end//
delimiter ;


-- 2
delimiter //
create trigger calificar after update on Venta
for each row
begin
    if 
end//
delimiter ;
