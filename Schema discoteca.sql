-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema discoteca
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `discoteca` DEFAULT CHARACTER SET utf8 ;
USE `discoteca` ;

-- -----------------------------------------------------
-- Table `discoteca`.`evento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`evento` (
  `id_evento` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL,
  `tematica` VARCHAR(150) NULL,
  `fecha` DATE NOT NULL,
  `hora_inicio` TIME NULL,
  `hora_fin` TIME NULL,
  `estado` ENUM('programado', 'en_curso', 'finalizado', 'cancelado') NOT NULL,
  PRIMARY KEY (`id_evento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`ficha_tecnica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`ficha_tecnica` (
  `id_ficha_tecnica` INT(11) NOT NULL AUTO_INCREMENT,
  `id_evento` INT(11) NOT NULL,
  `tematica` VARCHAR(150) NULL,
  `franja_horaria` VARCHAR(60) NULL,
  `cantidad_invitados` INT(11) NOT NULL,
  `observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`id_ficha_tecnica`),
  CONSTRAINT `fk_ficha_tecnica_evento`
    FOREIGN KEY (`id_evento`)
    REFERENCES `discoteca`.`evento` (`id_evento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `id_evento_UNIQUE` ON `discoteca`.`ficha_tecnica` (`id_evento` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`servicios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`servicios` (
  `id_servicio` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(120) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `precio` DECIMAL(10,2) NOT NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  PRIMARY KEY (`id_servicio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`ficha_servicio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`ficha_servicio` (
  `id_ficha_tecnica` INT(11) NOT NULL,
  `id_servicio` INT(11) NOT NULL,
  `cantidad_requerida` INT(11) NOT NULL,
  PRIMARY KEY (`id_ficha_tecnica`, `id_servicio`),
  CONSTRAINT `fk_ficha_servicio_ficha_tecnica1`
    FOREIGN KEY (`id_ficha_tecnica`)
    REFERENCES `discoteca`.`ficha_tecnica` (`id_ficha_tecnica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ficha_servicio_servicios1`
    FOREIGN KEY (`id_servicio`)
    REFERENCES `discoteca`.`servicios` (`id_servicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`agenda_eventos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`agenda_eventos` (
  `id_agenda_evento` INT(11) NOT NULL AUTO_INCREMENT,
  `id_evento` INT(11) NOT NULL,
  `fecha` DATE NOT NULL,
  `hora` TIME NOT NULL,
  `descripcion` VARCHAR(250) NULL,
  `estado` ENUM('programada', 'completada', 'cancelada') NOT NULL,
  PRIMARY KEY (`id_agenda_evento`),
  CONSTRAINT `fk_agenda_eventos_evento1`
    FOREIGN KEY (`id_evento`)
    REFERENCES `discoteca`.`evento` (`id_evento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`categoria_empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`categoria_empleado` (
  `id_categoria_empleado` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` ENUM('DJ', 'mesero', 'ingreso', 'administrativo') NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  PRIMARY KEY (`id_categoria_empleado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`empleados` (
  `id_empleado` INT NOT NULL AUTO_INCREMENT,
  `id_categoria_empleado` INT(11) NOT NULL,
  `primer_nombre` VARCHAR(45) NOT NULL,
  `segundo_nombre` VARCHAR(45) NULL,
  `primer_apellido` VARCHAR(45) NOT NULL,
  `segundo_apellido` VARCHAR(45) NULL,
  `documento` VARCHAR(30) NOT NULL,
  `telefono` VARCHAR(20) NULL,
  `email` VARCHAR(120) NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  PRIMARY KEY (`id_empleado`),
  CONSTRAINT `fk_empleados_categoria_empleado1`
    FOREIGN KEY (`id_categoria_empleado`)
    REFERENCES `discoteca`.`categoria_empleado` (`id_categoria_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `documento_UNIQUE` ON `discoteca`.`empleados` (`documento` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`agenda_empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`agenda_empleado` (
  `id_agenda_empleado` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empleados` INT(11) NOT NULL,
  `id_servicios` INT(11) NULL,
  `id_evento` INT(11) NULL,
  `fecha` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `hora_fin` TIME NULL,
  `estado` ENUM('programada', 'completada', 'cancelada') NOT NULL,
  PRIMARY KEY (`id_agenda_empleado`),
  CONSTRAINT `fk_agenda_empleado_empleados1`
    FOREIGN KEY (`id_empleados`)
    REFERENCES `discoteca`.`empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_agenda_empleado_servicios1`
    FOREIGN KEY (`id_servicios`)
    REFERENCES `discoteca`.`servicios` (`id_servicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_agenda_empleado_evento1`
    FOREIGN KEY (`id_evento`)
    REFERENCES `discoteca`.`evento` (`id_evento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`categoria_cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`categoria_cliente` (
  `id_categoria_cliente` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(60) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  PRIMARY KEY (`id_categoria_cliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`clientes` (
  `id_cliente` INT(11) NOT NULL AUTO_INCREMENT,
  `id_categoria_cliente` INT(11) NOT NULL,
  `primer_nombre` VARCHAR(45) NOT NULL,
  `segundo_nombre` VARCHAR(45) NULL,
  `primer_apellido` VARCHAR(45) NOT NULL,
  `segundo_apellido` VARCHAR(45) NULL,
  `documento` VARCHAR(30) NOT NULL,
  `telefono` VARCHAR(20) NULL,
  `email` VARCHAR(120) NULL,
  `fecha_nacimiento` DATE NULL,
  `es_vip` TINYINT(1) NOT NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  `puntos_acumulados` INT(11) NULL,
  PRIMARY KEY (`id_cliente`),
  CONSTRAINT `fk_clientes_categoria_cliente1`
    FOREIGN KEY (`id_categoria_cliente`)
    REFERENCES `discoteca`.`categoria_cliente` (`id_categoria_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `documento_UNIQUE` ON `discoteca`.`clientes` (`documento` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`reservas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`reservas` (
  `id_reserva` INT(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` INT(11) NOT NULL,
  `tipo_espacio` ENUM('vip', 'mesa') NOT NULL,
  `fecha` DATE NOT NULL,
  `hora` TIME NOT NULL,
  `descuento` DECIMAL(12,2) NOT NULL,
  `estado` ENUM('pendiente', 'confirmada', 'cancelada') NOT NULL,
  `codigo_qr` VARCHAR(45) NULL,
  PRIMARY KEY (`id_reserva`),
  CONSTRAINT `fk_reservas_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `discoteca`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`detalle_reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`detalle_reserva` (
  `id_detalle_reserva` INT(11) NOT NULL AUTO_INCREMENT,
  `id_reserva` INT(11) NOT NULL,
  `id_servicio` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(12,2) GENERATED ALWAYS AS (cantidad * precio_unitario) VIRTUAL,
  PRIMARY KEY (`id_detalle_reserva`),
  CONSTRAINT `fk_detalle_reserva_servicios1`
    FOREIGN KEY (`id_servicio`)
    REFERENCES `discoteca`.`servicios` (`id_servicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_reserva_reservas1`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `discoteca`.`reservas` (`id_reserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`roles` (
  `id_rol` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  `fecha_creacion` DATETIME NOT NULL,
  PRIMARY KEY (`id_rol`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_rol_UNIQUE` ON `discoteca`.`roles` (`nombre_rol` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`usuarios` (
  `id_usuario` INT(11) NOT NULL AUTO_INCREMENT,
  `id_rol` INT(11) NOT NULL,
  `primer_nombre` VARCHAR(45) NOT NULL,
  `segundo_nombre` VARCHAR(45) NULL,
  `primer_apellido` VARCHAR(45) NOT NULL,
  `segundo_apellido` VARCHAR(45) NULL,
  `email` VARCHAR(120) NOT NULL,
  `contrasena_hash` VARCHAR(255) NOT NULL,
  `telefono` VARCHAR(20) NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  `fecha_creacion` DATETIME NOT NULL,
  PRIMARY KEY (`id_usuario`),
  CONSTRAINT `fk_usuarios_roles1`
    FOREIGN KEY (`id_rol`)
    REFERENCES `discoteca`.`roles` (`id_rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `discoteca`.`usuarios` (`email` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`ingresos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`ingresos` (
  `id_ingreso` INT(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` INT(11) NOT NULL,
  `id_reserva` INT(11) NULL,
  `fecha` DATE NOT NULL,
  `hora` TIME NOT NULL,
  `puerta_acceso` VARCHAR(30) NOT NULL,
  `tipo_dispositivo` VARCHAR(50) NULL,
  `validado_por` INT(11) NULL,
  `estado` ENUM('valido', 'rechazado') NOT NULL,
  PRIMARY KEY (`id_ingreso`),
  CONSTRAINT `fk_ingresos_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `discoteca`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ingresos_reservas1`
    FOREIGN KEY (`id_reserva`)
    REFERENCES `discoteca`.`reservas` (`id_reserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ingresos_usuarios1`
    FOREIGN KEY (`validado_por`)
    REFERENCES `discoteca`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`ventas` (
  `id_venta` INT(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` INT(11) NOT NULL,
  `fecha_venta` DATETIME NOT NULL,
  `total` DECIMAL(12,2) NOT NULL,
  `metodo_pago` ENUM('efectivo', 'tarjeta', 'transferencia') NOT NULL,
  `comprobante_no` VARCHAR(30) NULL,
  `estado` ENUM('pendiente', 'pagada', 'anulada') NOT NULL,
  `puntos` INT(11) NULL,
  PRIMARY KEY (`id_venta`),
  CONSTRAINT `fk_ventas_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `discoteca`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `comprobante_no_UNIQUE` ON `discoteca`.`ventas` (`comprobante_no` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`productos` (
  `id_producto` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(120) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `precio_venta` DECIMAL(10,2) NOT NULL,
  `stock_actual` INT(11) NOT NULL,
  `stock_minimo` INT(11) NOT NULL,
  `stock_maximo` INT(11) NOT NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  PRIMARY KEY (`id_producto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`detalle_ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`detalle_ventas` (
  `id_detalle_venta` INT(11) NOT NULL AUTO_INCREMENT,
  `id_venta` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(12,2) GENERATED ALWAYS AS (cantidad * precio_unitario) VIRTUAL,
  PRIMARY KEY (`id_detalle_venta`),
  CONSTRAINT `fk_detalle_ventas_ventas1`
    FOREIGN KEY (`id_venta`)
    REFERENCES `discoteca`.`ventas` (`id_venta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_ventas_productos1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `discoteca`.`productos` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`proveedores` (
  `id_proveedor` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(120) NOT NULL,
  `nit` VARCHAR(30) NULL,
  `telefono` VARCHAR(20) NULL,
  `email` VARCHAR(120) NULL,
  `direccion` VARCHAR(200) NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nit_UNIQUE` ON `discoteca`.`proveedores` (`nit` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`compras` (
  `id_compra` INT(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT(11) NOT NULL,
  `fecha_compra` DATETIME NOT NULL,
  `total` DECIMAL(12,2) NOT NULL,
  `estado` ENUM('pendiente', 'confirmada', 'anulada') NOT NULL,
  PRIMARY KEY (`id_compra`),
  CONSTRAINT `fk_compras_proveedores1`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `discoteca`.`proveedores` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`detalle_compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`detalle_compras` (
  `id_detalle_compra` INT(11) NOT NULL AUTO_INCREMENT,
  `id_compra` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(12,2) GENERATED ALWAYS AS (cantidad * precio_unitario) VIRTUAL,
  PRIMARY KEY (`id_detalle_compra`),
  CONSTRAINT `fk_detalle_compras_compras1`
    FOREIGN KEY (`id_compra`)
    REFERENCES `discoteca`.`compras` (`id_compra`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_compras_productos1`
    FOREIGN KEY (`id_producto`)
    REFERENCES `discoteca`.`productos` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`permisos` (
  `id_permiso` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_permiso` VARCHAR(80) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `estado` ENUM('activo', 'inactivo') NOT NULL,
  PRIMARY KEY (`id_permiso`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_permiso_UNIQUE` ON `discoteca`.`permisos` (`nombre_permiso` ASC);


-- -----------------------------------------------------
-- Table `discoteca`.`rol_permiso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`rol_permiso` (
  `permisos_id_permisos` INT(11) NOT NULL,
  `roles_id_rol` INT(11) NOT NULL,
  PRIMARY KEY (`roles_id_rol`, `permisos_id_permisos`),
  CONSTRAINT `fk_permisos_has_roles_permisos1`
    FOREIGN KEY (`permisos_id_permisos`)
    REFERENCES `discoteca`.`permisos` (`id_permiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permisos_has_roles_roles1`
    FOREIGN KEY (`roles_id_rol`)
    REFERENCES `discoteca`.`roles` (`id_rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discoteca`.`accesos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discoteca`.`accesos` (
  `id_acceso` INT(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` INT(11) NOT NULL,
  `tipo_accion` ENUM('login', 'logout', 'registro', 'edicion_perfil', 'recuperar_password', 'restablecer_password') NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `ip_origen` VARCHAR(45) NULL,
  `resultado` ENUM('exitoso', 'fallido') NOT NULL,
  PRIMARY KEY (`id_acceso`),
  CONSTRAINT `fk_accesos_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `discoteca`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
