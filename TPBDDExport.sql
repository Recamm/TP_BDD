-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: TP_BDD
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Calificacion`
--

DROP TABLE IF EXISTS `Calificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Calificacion` (
  `idCalificacion` int NOT NULL AUTO_INCREMENT,
  `calificacion` float DEFAULT NULL,
  `fechaHora` datetime DEFAULT NULL,
  `idVenta` int NOT NULL,
  PRIMARY KEY (`idCalificacion`),
  UNIQUE KEY `idVenta` (`idVenta`),
  CONSTRAINT `Calificacion_ibfk_1` FOREIGN KEY (`idVenta`) REFERENCES `Venta` (`idVenta`),
  CONSTRAINT `Calificacion_chk_1` CHECK (((`calificacion` >= 0) and (`calificacion` <= 5) and ((`calificacion` * 2) = floor((`calificacion` * 2)))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Calificacion`
--

LOCK TABLES `Calificacion` WRITE;
/*!40000 ALTER TABLE `Calificacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `Calificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Categoria`
--

DROP TABLE IF EXISTS `Categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categoria` (
  `idCategoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Categoria`
--

LOCK TABLES `Categoria` WRITE;
/*!40000 ALTER TABLE `Categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `Categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Envio`
--

DROP TABLE IF EXISTS `Envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Envio` (
  `idEnvio` int NOT NULL AUTO_INCREMENT,
  `empresaEncargada` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idEnvio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Envio`
--

LOCK TABLES `Envio` WRITE;
/*!40000 ALTER TABLE `Envio` DISABLE KEYS */;
/*!40000 ALTER TABLE `Envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Envio_VentaDirecta`
--

DROP TABLE IF EXISTS `Envio_VentaDirecta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Envio_VentaDirecta` (
  `idVentaDirec` int NOT NULL,
  `idEnv` int NOT NULL,
  PRIMARY KEY (`idVentaDirec`,`idEnv`),
  KEY `idEnv` (`idEnv`),
  CONSTRAINT `Envio_VentaDirecta_ibfk_1` FOREIGN KEY (`idVentaDirec`) REFERENCES `VentaDirecta` (`idVentaDirecta`),
  CONSTRAINT `Envio_VentaDirecta_ibfk_2` FOREIGN KEY (`idEnv`) REFERENCES `Envio` (`idEnvio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Envio_VentaDirecta`
--

LOCK TABLES `Envio_VentaDirecta` WRITE;
/*!40000 ALTER TABLE `Envio_VentaDirecta` DISABLE KEYS */;
/*!40000 ALTER TABLE `Envio_VentaDirecta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Historial`
--

DROP TABLE IF EXISTS `Historial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Historial` (
  `idHistorial` int NOT NULL AUTO_INCREMENT,
  `monto` float DEFAULT NULL,
  `fechaHora` datetime DEFAULT NULL,
  `idSubasta` int NOT NULL,
  `DNIUsuario` int NOT NULL,
  PRIMARY KEY (`idHistorial`),
  KEY `idSubasta` (`idSubasta`),
  KEY `DNIUsuario` (`DNIUsuario`),
  CONSTRAINT `Historial_ibfk_1` FOREIGN KEY (`idSubasta`) REFERENCES `Subasta` (`idSubasta`),
  CONSTRAINT `Historial_ibfk_2` FOREIGN KEY (`DNIUsuario`) REFERENCES `Usuario` (`DNI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Historial`
--

LOCK TABLES `Historial` WRITE;
/*!40000 ALTER TABLE `Historial` DISABLE KEYS */;
/*!40000 ALTER TABLE `Historial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pago`
--

DROP TABLE IF EXISTS `Pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pago` (
  `idPago` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idPago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pago`
--

LOCK TABLES `Pago` WRITE;
/*!40000 ALTER TABLE `Pago` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pago_VentaDirecta`
--

DROP TABLE IF EXISTS `Pago_VentaDirecta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pago_VentaDirecta` (
  `idVentaDirec` int NOT NULL,
  `idPag` int NOT NULL,
  PRIMARY KEY (`idVentaDirec`,`idPag`),
  KEY `idPag` (`idPag`),
  CONSTRAINT `Pago_VentaDirecta_ibfk_1` FOREIGN KEY (`idVentaDirec`) REFERENCES `VentaDirecta` (`idVentaDirecta`),
  CONSTRAINT `Pago_VentaDirecta_ibfk_2` FOREIGN KEY (`idPag`) REFERENCES `Pago` (`idPago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pago_VentaDirecta`
--

LOCK TABLES `Pago_VentaDirecta` WRITE;
/*!40000 ALTER TABLE `Pago_VentaDirecta` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pago_VentaDirecta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pregunta`
--

DROP TABLE IF EXISTS `Pregunta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pregunta` (
  `idPregunta` int NOT NULL AUTO_INCREMENT,
  `pregunta` text,
  `respuesta` text,
  `fechaHora` datetime DEFAULT NULL,
  `idPublicacion` int NOT NULL,
  `DNIUsuario` int NOT NULL,
  PRIMARY KEY (`idPregunta`),
  KEY `idPublicacion` (`idPublicacion`),
  KEY `DNIUsuario` (`DNIUsuario`),
  CONSTRAINT `Pregunta_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `Publicacion` (`idPublicacion`),
  CONSTRAINT `Pregunta_ibfk_2` FOREIGN KEY (`DNIUsuario`) REFERENCES `Usuario` (`DNI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pregunta`
--

LOCK TABLES `Pregunta` WRITE;
/*!40000 ALTER TABLE `Pregunta` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pregunta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Producto`
--

DROP TABLE IF EXISTS `Producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Producto` (
  `idProducto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `descripcion` text,
  PRIMARY KEY (`idProducto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Producto`
--

LOCK TABLES `Producto` WRITE;
/*!40000 ALTER TABLE `Producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `Producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Publicacion`
--

DROP TABLE IF EXISTS `Publicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publicacion` (
  `idPublicacion` int NOT NULL AUTO_INCREMENT,
  `precio` float DEFAULT NULL,
  `nivelPublicacion` varchar(50) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `fechaHora` datetime DEFAULT CURRENT_TIMESTAMP,
  `idCategoria` int NOT NULL,
  `idProducto` int NOT NULL,
  `DNIUsuario` int NOT NULL,
  PRIMARY KEY (`idPublicacion`),
  KEY `idCategoria` (`idCategoria`),
  KEY `idProducto` (`idProducto`),
  KEY `DNIUsuario` (`DNIUsuario`),
  CONSTRAINT `Publicacion_ibfk_1` FOREIGN KEY (`idCategoria`) REFERENCES `Categoria` (`idCategoria`),
  CONSTRAINT `Publicacion_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `Producto` (`idProducto`),
  CONSTRAINT `Publicacion_ibfk_3` FOREIGN KEY (`DNIUsuario`) REFERENCES `Usuario` (`DNI`),
  CONSTRAINT `Publicacion_chk_1` CHECK ((`nivelPublicacion` in (_utf8mb4'Bronce',_utf8mb4'Plata',_utf8mb4'Oro',_utf8mb4'Platino'))),
  CONSTRAINT `Publicacion_chk_2` CHECK ((`estado` in (_utf8mb4'En Progreso',_utf8mb4'Finalizada',_utf8mb4'Pausada',_utf8mb4'Observada')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Publicacion`
--

LOCK TABLES `Publicacion` WRITE;
/*!40000 ALTER TABLE `Publicacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `Publicacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Subasta`
--

DROP TABLE IF EXISTS `Subasta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subasta` (
  `idSubasta` int NOT NULL AUTO_INCREMENT,
  `fechaHoraInicio` datetime DEFAULT NULL,
  `fechaHoraFin` datetime DEFAULT NULL,
  `idPublicacion` int NOT NULL,
  PRIMARY KEY (`idSubasta`),
  KEY `idPublicacion` (`idPublicacion`),
  CONSTRAINT `Subasta_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `Publicacion` (`idPublicacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Subasta`
--

LOCK TABLES `Subasta` WRITE;
/*!40000 ALTER TABLE `Subasta` DISABLE KEYS */;
/*!40000 ALTER TABLE `Subasta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuario`
--

DROP TABLE IF EXISTS `Usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuario` (
  `DNI` int NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `reputacion` int DEFAULT NULL,
  PRIMARY KEY (`DNI`),
  CONSTRAINT `Usuario_chk_1` CHECK ((`categoria` in (NULL,_utf8mb4'Normal',_utf8mb4'Platinium',_utf8mb4'Gold'))),
  CONSTRAINT `Usuario_chk_2` CHECK ((`reputacion` between 0 and 100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuario`
--

LOCK TABLES `Usuario` WRITE;
/*!40000 ALTER TABLE `Usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `Usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Venta`
--

DROP TABLE IF EXISTS `Venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Venta` (
  `idVenta` int NOT NULL AUTO_INCREMENT,
  `fechaHora` datetime DEFAULT NULL,
  `idPublicacion` int NOT NULL,
  `DNIUsuario` int NOT NULL,
  `idEnvio` int NOT NULL,
  `idPago` int NOT NULL,
  PRIMARY KEY (`idVenta`),
  KEY `idPublicacion` (`idPublicacion`),
  KEY `DNIUsuario` (`DNIUsuario`),
  KEY `idEnvio` (`idEnvio`),
  KEY `idPago` (`idPago`),
  CONSTRAINT `Venta_ibfk_1` FOREIGN KEY (`idPublicacion`) REFERENCES `Publicacion` (`idPublicacion`),
  CONSTRAINT `Venta_ibfk_2` FOREIGN KEY (`DNIUsuario`) REFERENCES `Usuario` (`DNI`),
  CONSTRAINT `Venta_ibfk_3` FOREIGN KEY (`idEnvio`) REFERENCES `Envio` (`idEnvio`),
  CONSTRAINT `Venta_ibfk_4` FOREIGN KEY (`idPago`) REFERENCES `Pago` (`idPago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Venta`
--

LOCK TABLES `Venta` WRITE;
/*!40000 ALTER TABLE `Venta` DISABLE KEYS */;
/*!40000 ALTER TABLE `Venta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VentaDirecta`
--

DROP TABLE IF EXISTS `VentaDirecta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VentaDirecta` (
  `idVentaDirecta` int NOT NULL AUTO_INCREMENT,
  `idPago` int DEFAULT NULL,
  `idEnvio` int NOT NULL,
  `idPublicacion` int NOT NULL,
  PRIMARY KEY (`idVentaDirecta`),
  KEY `idPago` (`idPago`),
  KEY `idEnvio` (`idEnvio`),
  KEY `idPublicacion` (`idPublicacion`),
  CONSTRAINT `VentaDirecta_ibfk_1` FOREIGN KEY (`idPago`) REFERENCES `Pago` (`idPago`),
  CONSTRAINT `VentaDirecta_ibfk_2` FOREIGN KEY (`idEnvio`) REFERENCES `Envio` (`idEnvio`),
  CONSTRAINT `VentaDirecta_ibfk_3` FOREIGN KEY (`idPublicacion`) REFERENCES `Publicacion` (`idPublicacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VentaDirecta`
--

LOCK TABLES `VentaDirecta` WRITE;
/*!40000 ALTER TABLE `VentaDirecta` DISABLE KEYS */;
/*!40000 ALTER TABLE `VentaDirecta` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-26  8:01:36
