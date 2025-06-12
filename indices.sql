use TP_BDD;

-- 1
create index idProducto_Publicacion on Publicacion(idProducto);
create index nombreProducto on Producto(nombre);

-- 2
create index 