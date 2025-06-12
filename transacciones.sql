-- 1
start transaction;
    insert into Publicacion
    (precio, nivelPublicacion, estado, fechaHora, idCategoria, idProducto, DNIUsuario) value
    (1000, 'Plata', 'En Progreso', NOW(), 1, 1, 1001);
commit;

create procedure sp;
begin
    start transaction;
    if CONDITION then
        --codigo
        commit;
    else
        --codigo
        rollback;
        signal sqlstate '45000' set message_text = "Error al crear una publicacion!"
end