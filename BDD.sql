create database TP_BDD;
use TP_BDD;

create table Usuario(
    DNI int primary key not null,
    nombre varchar(50),
    apellido varchar(50),
    direccion varchar(50),
    categoria varchar(50) check (categoria in (null, 'Normal', 'Platinium', 'Gold')),
    reputacion int check (reputacion between 0 and 100)
);
create table Producto(
    idProducto int primary key not null auto_increment,
    nombre varchar(50),
    marca varchar(50),
    descripccion text
);

create table Categoria(
    idCategoria int primary key not null auto_increment,
    nombre varchar(50)
);

create table Publicacion(
    idPublicacion int primary key not null auto_increment,
    precio float,
    nivelPublicacion varchar(50) check (nivelPublicacion in ('Bronce', 'Plata', 'Oro', 'Platino')),
    estado varchar(50) check (estado in ('En Progreso', 'Finalizada', 'Pausada', 'Observada')),
    fecha datetime default now(),
    idCategoria int not null,
    idProducto int not null,
    DNIUsuario int not null,
    foreign key (idCategoria) references Categoria (idCategoria),
    foreign key (idProducto) references Producto (idProducto),
    foreign key (DNIUsuario) references Usuario (DNI)
);

create table Venta(
    idVenta int primary key not null auto_increment,
    fecha date,
    idPublicacion int not null,
    DNIComprador int not null,
    foreign key (idPublicacion) references Publicacion (idPublicacion),
    foreign key (DNIComprador) references Usuario (DNI)
);

create table Calificacion(
    idCalificacion int primary key not null auto_increment,
    calificacion float check (calificacion >= 0 and calificacion <= 5 and (calificacion * 2) = floor(calificacion * 2)),
    idVenta int not null,
    foreign key (idVenta) references Venta (idVenta)
);

create table Pregunta(
    idPregunta int primary key not null auto_increment,
    pregunta text,
    respuesta text,
    fechaHora datetime,
    idPublicacion int not null,
    DNIUsuario int not null,
    foreign key (idPublicacion) references Publicacion (idPublicacion),
    foreign key (DNIUsuario) references Usuario (DNI) 
);

create table Subasta(
    idSubasta int primary key not null auto_increment,
    fechaHoraInicio datetime,
    fechaHoraFin datetime,
    idPublicacion int not null,
    DNIUsuario int not null,
    foreign key (idPublicacion) references Publicacion (idPublicacion),
    foreign key (DNIUsuario) references Usuario (DNI)
);

create table Historial(
    idHistorial int primary key not null auto_increment,
    monto float,
    fechaHora datetime,
    idSubasta int not null,
    foreign key (idSubasta) references Subasta (idSubasta)
);


create table Envio(
    idEnvio int primary key not null auto_increment,
    empresaEncargada varchar(50)
);

create table Pago(
    idPago int primary key not null auto_increment,
    tipo varchar(50)
);

create table VentaDirecta(
    idVentaDirecta int primary key not null auto_increment,
    idPago int,
    idEnvio int not null,
    idPublicacion int not null,
    foreign key (idPago) references Pago (idPago),
    foreign key (idEnvio) references Envio (idEnvio),
    foreign key (idPublicacion) references Publicacion (idPublicacion)
);