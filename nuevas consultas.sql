

USE discoteca;


-- =========================================================================
-- 4.1 Configuración: Roles y Permisos
-- =========================================================================

-- RF-ROL-01 — Crear un rol con nombre único: consultar los roles creados
SELECT id_rol, nombre_rol, descripcion, estado, fecha_creacion
FROM roles
ORDER BY id_rol;

-- RF-ROL-01 — Crear un rol con nombre único: validar que no haya nombres repetidos (0 filas)
SELECT nombre_rol, COUNT(*) AS repeticiones
FROM roles
GROUP BY nombre_rol
HAVING COUNT(*) > 1;  

-- RF-ROL-01 — Asignarle permisos específicos al rol: permisos asignados a cada rol
SELECT roles.nombre_rol, permisos.nombre_permiso, permisos.descripcion
FROM rol_permiso
JOIN roles ON rol_permiso.roles_id_rol = roles.id_rol
JOIN permisos ON rol_permiso.permisos_id_permisos = permisos.id_permiso
ORDER BY roles.nombre_rol, permisos.nombre_permiso;

-- RF-ROL-01 — Asignarle permisos específicos al rol: cantidad de permisos por rol
SELECT roles.id_rol, roles.nombre_rol, COUNT(rol_permiso.permisos_id_permisos) AS total_permisos
FROM roles
LEFT JOIN rol_permiso ON roles.id_rol = rol_permiso.roles_id_rol
GROUP BY roles.id_rol, roles.nombre_rol
ORDER BY total_permisos DESC;

-- RF-ROL-02 — Listar los permisos de un rol
SELECT roles.nombre_rol, permisos.nombre_permiso, permisos.descripcion, permisos.estado
FROM rol_permiso
JOIN roles ON rol_permiso.roles_id_rol = roles.id_rol
JOIN permisos ON rol_permiso.permisos_id_permisos = permisos.id_permiso
WHERE roles.id_rol = 1;

-- RF-ROL-02 — Buscar permisos de un rol por nombre
SELECT roles.nombre_rol, permisos.nombre_permiso, permisos.descripcion
FROM rol_permiso
JOIN roles ON rol_permiso.roles_id_rol = roles.id_rol
JOIN permisos ON rol_permiso.permisos_id_permisos = permisos.id_permiso
WHERE roles.nombre_rol = 'Gerente'
  AND permisos.nombre_permiso LIKE CONCAT('%', 'ver', '%');

-- RF-ROL-02 — Buscar qué roles tienen un permiso determinado
SELECT permisos.nombre_permiso, roles.nombre_rol
FROM permisos
JOIN rol_permiso ON permisos.id_permiso = rol_permiso.permisos_id_permisos
JOIN roles ON rol_permiso.roles_id_rol = roles.id_rol
WHERE permisos.nombre_permiso = 'ver_reportes';

-- RF-ROL-02 — Editar un permiso de un rol
UPDATE permisos
SET descripcion = 'Permite modificar la información de los usuarios del sistema'
WHERE id_permiso = 2;

-- RF-ROL-02 — Cambiar el estado de un permiso de un rol (inactivar)
UPDATE permisos
SET estado = 'inactivo'
WHERE id_permiso = 19;

-- RF-ROL-02 — Cambiar el estado de un permiso de un rol (reactivar)
UPDATE permisos
SET estado = 'activo'
WHERE id_permiso = 19;

-- RF-ROL-02 — Eliminar un permiso de un rol
DELETE FROM rol_permiso
WHERE roles_id_rol = 5
  AND permisos_id_permisos = 14;


-- =========================================================================
-- 4.2 Usuarios y Acceso
-- =========================================================================

-- RF-USR-01 — Crear un usuario: consultar los usuarios creados con su rol
SELECT usuarios.id_usuario, usuarios.primer_nombre, usuarios.primer_apellido, usuarios.email,
       roles.nombre_rol, usuarios.estado, usuarios.fecha_creacion
FROM usuarios
JOIN roles ON usuarios.id_rol = roles.id_rol
ORDER BY usuarios.id_usuario;

-- RF-USR-01 — Listar los usuarios por estado
SELECT estado, COUNT(*) AS total_usuarios
FROM usuarios
GROUP BY estado;

-- RF-USR-01 — Buscar un usuario por nombre o correo
SELECT id_usuario, primer_nombre, primer_apellido, email, telefono, estado
FROM usuarios
WHERE primer_nombre LIKE CONCAT('%', 'Ana', '%')
   OR email = 'carlos.gomez@discoteca.com';

-- RF-USR-01 — Editar un usuario
UPDATE usuarios
SET telefono = '3009876500'
WHERE id_usuario = 3;

-- RF-USR-01 — Cambiar el estado de un usuario (inactivar)
UPDATE usuarios
SET estado = 'inactivo'
WHERE id_usuario = 13;

-- RF-USR-01 — Cambiar el estado de un usuario (activar)
UPDATE usuarios
SET estado = 'activo'
WHERE id_usuario = 13;

-- RF-ACC-01 — Iniciar sesión
SELECT id_acceso, id_usuario, tipo_accion, fecha_hora, ip_origen, resultado
FROM accesos
WHERE tipo_accion = 'login'
  AND resultado = 'exitoso';

-- RF-ACC-01 — Iniciar sesión: intentos fallidos por usuario
SELECT id_usuario, COUNT(*) AS intentos_fallidos
FROM accesos
WHERE tipo_accion = 'login'
  AND resultado = 'fallido'
GROUP BY id_usuario;

-- RF-ACC-01 — Cerrar sesión
SELECT id_acceso, id_usuario, tipo_accion, fecha_hora, ip_origen, resultado
FROM accesos
WHERE tipo_accion = 'logout';

-- RF-ACC-01 — Registrarse
SELECT id_acceso, id_usuario, tipo_accion, fecha_hora, resultado
FROM accesos
WHERE tipo_accion = 'registro';

-- RF-ACC-01 — Editar mi perfil: acciones registradas
SELECT id_acceso, id_usuario, tipo_accion, fecha_hora, resultado
FROM accesos
WHERE tipo_accion = 'edicion_perfil';

-- RF-ACC-01 — Editar mi perfil: actualizar los datos del propio usuario
UPDATE usuarios
SET telefono = '3009871111'
WHERE id_usuario = 2;

-- RF-ACC-01 — Recuperar contraseña
SELECT id_acceso, id_usuario, tipo_accion, fecha_hora, resultado
FROM accesos
WHERE tipo_accion = 'recuperar_password';

-- RF-ACC-01 — Restablecer contraseña: acciones registradas
SELECT id_acceso, id_usuario, tipo_accion, fecha_hora, resultado
FROM accesos
WHERE tipo_accion = 'restablecer_password';

-- RF-ACC-01 — Restablecer contraseña: actualizar la contraseña del usuario
UPDATE usuarios
SET contrasena_hash = '$2b$12$Nw5rT2qP8xL3vK7cB1mE4uY6aH9jD0fG2bU5iO8pA3zX7nM1q'
WHERE id_usuario = 2;


-- =========================================================================
-- 4.3 Compras, Proveedores y Existencias
-- =========================================================================

-- RF-COM-01 — Crear una compra a un proveedor: consultar las compras con su proveedor
SELECT compras.id_compra, proveedores.nombre AS proveedor, compras.fecha_compra, compras.total, compras.estado
FROM compras
JOIN proveedores ON compras.id_proveedor = proveedores.id_proveedor
ORDER BY compras.fecha_compra DESC;

-- RF-COM-01 — Agregar productos con cantidad y precio a una compra
SELECT compras.id_compra, compras.id_proveedor, detalle_compras.id_producto, productos.nombre AS producto,
       detalle_compras.cantidad, detalle_compras.precio_unitario, detalle_compras.subtotal
FROM compras
JOIN detalle_compras ON compras.id_compra = detalle_compras.id_compra
JOIN productos ON detalle_compras.id_producto = productos.id_producto
WHERE compras.id_compra = 24;

-- RF-COM-01 — Editarla: cambiar proveedor y fecha de una compra
UPDATE compras
SET id_proveedor = 9,
    fecha_compra = '2026-09-18 16:30:00'
WHERE id_compra = 24;

-- RF-COM-01 — Editarla: quitar un producto de una compra anulada
DELETE FROM detalle_compras
WHERE id_compra = 7
  AND id_producto = 14;

-- RF-COM-01 — Anularla
UPDATE compras
SET estado = 'anulada'
WHERE id_compra = 24;

-- RF-COM-01 — Anularla: listar las compras anuladas
SELECT compras.id_compra, proveedores.nombre AS proveedor, compras.fecha_compra, compras.total
FROM compras
JOIN proveedores ON compras.id_proveedor = proveedores.id_proveedor
WHERE compras.estado = 'anulada';

-- RF-COM-02 — Registrar un proveedor: consultar los proveedores registrados
SELECT id_proveedor, nombre, nit, telefono, email, direccion, estado
FROM proveedores;

-- RF-COM-02 — Listar los proveedores con su estado
SELECT id_proveedor, nombre, nit, telefono, email, estado
FROM proveedores
ORDER BY estado, nombre;

-- RF-COM-02 — Buscar un proveedor por nombre o NIT
SELECT id_proveedor, nombre, nit, telefono, email, direccion, estado
FROM proveedores
WHERE nombre LIKE CONCAT('%', 'Dislicores', '%')
   OR nit = '890924912-8';

-- RF-COM-02 — Editar un proveedor
UPDATE proveedores
SET telefono = '6044482299',
    direccion = 'Carrera 48 # 26-90, Medellín'
WHERE id_proveedor = 6;

-- RF-COM-02 — Cambiar el estado de un proveedor (inactivar)
UPDATE proveedores
SET estado = 'inactivo'
WHERE id_proveedor = 11;

-- RF-COM-02 — Cambiar el estado de un proveedor (activar)
UPDATE proveedores
SET estado = 'activo'
WHERE id_proveedor = 11;

-- RF-COM-03 — Crear un producto con stock, stock mínimo y stock máximo: consultar los productos creados
SELECT id_producto, nombre, precio_venta, stock_actual, stock_minimo, stock_maximo, estado
FROM productos
ORDER BY id_producto;

-- RF-COM-03 — Listar las existencias
SELECT id_producto, nombre, stock_actual, stock_minimo, stock_maximo, estado
FROM productos
ORDER BY nombre;

-- RF-COM-03 — Buscar las existencias de un producto por nombre
SELECT id_producto, nombre, stock_actual, stock_minimo, stock_maximo, estado
FROM productos
WHERE nombre LIKE CONCAT('%', 'Ron Medellin', '%');

-- RF-COM-03 — Editar las existencias de un producto
UPDATE productos
SET stock_actual = 20
WHERE id_producto = 30;

-- RF-COM-03 — Editar el stock mínimo y máximo de un producto
UPDATE productos
SET stock_minimo = 5,
    stock_maximo = 40
WHERE id_producto = 30;

-- RF-COM-04 — Compra confirmada: cantidad comprada por producto
SELECT detalle_compras.id_producto, productos.nombre, SUM(detalle_compras.cantidad) AS cantidad_comprada
FROM compras
JOIN detalle_compras ON compras.id_compra = detalle_compras.id_compra
JOIN productos ON detalle_compras.id_producto = productos.id_producto
WHERE compras.estado = 'confirmada'
GROUP BY detalle_compras.id_producto, productos.nombre
ORDER BY cantidad_comprada DESC;

-- RF-COM-04 — Incrementar el stock de cada producto según la cantidad comprada
UPDATE productos
JOIN detalle_compras ON detalle_compras.id_producto = productos.id_producto
SET productos.stock_actual = productos.stock_actual + detalle_compras.cantidad
WHERE detalle_compras.id_compra = 25;

-- RF-COM-05 — Alerta de stock: productos que llegaron al stock mínimo
SELECT id_producto, nombre, stock_actual, stock_minimo
FROM productos
WHERE stock_actual <= stock_minimo
  AND estado = 'activo';

-- RF-COM-05 — Alerta de stock: cantidad faltante para el stock mínimo
SELECT id_producto, nombre, stock_actual, stock_minimo, stock_minimo - stock_actual AS faltante
FROM productos
WHERE stock_actual <= stock_minimo
  AND estado = 'activo'
ORDER BY faltante DESC;


-- =========================================================================
-- 4.4 Ingreso y Clientes VIP
-- =========================================================================

-- RF-ING-01 — Generar el código QR de las reservas confirmadas
UPDATE reservas
SET codigo_qr = CONCAT('QR', LPAD(id_reserva, 4, '0'))
WHERE estado = 'confirmada'
  AND codigo_qr IS NULL;

-- RF-ING-01 — Código QR de cada cliente con reserva confirmada
SELECT reservas.id_reserva, clientes.primer_nombre, clientes.primer_apellido,
       reservas.fecha, reservas.hora, reservas.codigo_qr
FROM reservas
JOIN clientes ON reservas.id_cliente = clientes.id_cliente
WHERE reservas.estado = 'confirmada'
ORDER BY reservas.fecha;

-- RF-ING-01 — Validar un código QR en la puerta de acceso
SELECT reservas.id_reserva, clientes.primer_nombre, clientes.primer_apellido,
       reservas.tipo_espacio, reservas.fecha, reservas.hora
FROM reservas
JOIN clientes ON reservas.id_cliente = clientes.id_cliente
WHERE reservas.codigo_qr = 'QR0003'
  AND reservas.estado = 'confirmada';

-- RF-ING-01 — Ingresos validados por cada operador
SELECT usuarios.primer_nombre, usuarios.primer_apellido, COUNT(*) AS ingresos_validados
FROM ingresos
JOIN usuarios ON ingresos.validado_por = usuarios.id_usuario
WHERE ingresos.estado = 'valido'
GROUP BY usuarios.id_usuario, usuarios.primer_nombre, usuarios.primer_apellido
ORDER BY ingresos_validados DESC;

-- RF-ING-02 — Registrar cada ingreso con fecha, hora, puerta de acceso y tipo de dispositivo
SELECT id_ingreso, id_cliente, id_reserva, fecha, hora, puerta_acceso, tipo_dispositivo, estado
FROM ingresos
ORDER BY fecha DESC, hora DESC;

-- RF-ING-02 — Ingresos por puerta de acceso
SELECT puerta_acceso, COUNT(*) AS total_ingresos
FROM ingresos
GROUP BY puerta_acceso
ORDER BY total_ingresos DESC;

-- RF-ING-02 — Ingresos por tipo de dispositivo
SELECT tipo_dispositivo, COUNT(*) AS total_ingresos
FROM ingresos
GROUP BY tipo_dispositivo
ORDER BY total_ingresos DESC;

-- RF-ING-03 — Registrar un cliente VIP: consultar los clientes VIP
SELECT id_cliente, primer_nombre, primer_apellido, documento, es_vip, estado
FROM clientes
WHERE es_vip = 1;

-- RF-ING-03 — Consultar el estado, acceso prioritario y beneficios de un cliente VIP
SELECT clientes.id_cliente, CONCAT(clientes.primer_nombre, ' ', clientes.primer_apellido) AS cliente,
       categoria_cliente.nombre AS categoria, clientes.puntos_acumulados, clientes.estado
FROM clientes
JOIN categoria_cliente ON clientes.id_categoria_cliente = categoria_cliente.id_categoria_cliente
WHERE clientes.es_vip = 1
ORDER BY clientes.puntos_acumulados DESC;

-- RF-ING-03 — Actualizar un cliente VIP
UPDATE clientes
SET telefono = '3204560000'
WHERE id_cliente = 4
  AND es_vip = 1;

-- RF-ING-03 — Cambiar el estado de un cliente VIP (inactivar)
UPDATE clientes
SET estado = 'inactivo'
WHERE id_cliente = 4
  AND es_vip = 1;

-- RF-ING-03 — Cambiar el estado de un cliente VIP (activar)
UPDATE clientes
SET estado = 'activo'
WHERE id_cliente = 4
  AND es_vip = 1;


-- =========================================================================
-- 4.5 Servicios, Empleados y Reservas
-- =========================================================================

-- RF-SER-01 — Registrar los servicios que ofrece la discoteca: consultar los servicios
SELECT id_servicio, nombre, descripcion, precio, estado
FROM servicios
ORDER BY nombre;

-- RF-SER-01 — Consultar un servicio
SELECT id_servicio, nombre, descripcion, precio, estado
FROM servicios
WHERE id_servicio = 5;

-- RF-SER-01 — Actualizar un servicio
UPDATE servicios
SET descripcion = 'Ingreso por una fila especial sin espera'
WHERE id_servicio = 5;

-- RF-SER-01 — Cambiar el estado de un servicio (inactivar)
UPDATE servicios
SET estado = 'inactivo'
WHERE id_servicio = 4;

-- RF-SER-01 — Cambiar el estado de un servicio (activar)
UPDATE servicios
SET estado = 'activo'
WHERE id_servicio = 4;

-- RF-SER-02 — Registrar categorías de empleados (DJ, mesero, ingreso, administrativo)
SELECT id_categoria_empleado, nombre, descripcion, estado
FROM categoria_empleado;

-- RF-SER-02 — Asociar empleados a cada categoría
SELECT categoria_empleado.nombre AS categoria, empleados.id_empleado,
       empleados.primer_nombre, empleados.primer_apellido, empleados.estado
FROM categoria_empleado
JOIN empleados ON categoria_empleado.id_categoria_empleado = empleados.id_categoria_empleado
ORDER BY categoria_empleado.nombre, empleados.primer_apellido;

-- RF-SER-02 — Empleados asociados a una categoría
SELECT empleados.id_empleado, empleados.primer_nombre, empleados.primer_apellido,
       categoria_empleado.nombre AS categoria
FROM empleados
JOIN categoria_empleado ON empleados.id_categoria_empleado = categoria_empleado.id_categoria_empleado
WHERE categoria_empleado.nombre = 'DJ';

-- RF-SER-02 — Cantidad de empleados por categoría
SELECT categoria_empleado.nombre AS categoria, COUNT(empleados.id_empleado) AS total_empleados
FROM categoria_empleado
LEFT JOIN empleados ON categoria_empleado.id_categoria_empleado = empleados.id_categoria_empleado
GROUP BY categoria_empleado.id_categoria_empleado, categoria_empleado.nombre;

-- RF-SER-02 — Editar la descripción de una categoría de empleados
UPDATE categoria_empleado
SET descripcion = 'Encargado de organizar y gestionar las actividades administrativas de la discoteca'
WHERE id_categoria_empleado = 4;

-- RF-SER-03 — Configurar la agenda de un empleado asociada a un servicio o evento
SELECT agenda_empleado.id_agenda_empleado, empleados.primer_nombre, empleados.primer_apellido,
       servicios.nombre AS servicio, evento.nombre AS evento,
       agenda_empleado.fecha, agenda_empleado.hora_inicio, agenda_empleado.hora_fin, agenda_empleado.estado
FROM agenda_empleado
JOIN empleados ON agenda_empleado.id_empleados = empleados.id_empleado
LEFT JOIN servicios ON agenda_empleado.id_servicios = servicios.id_servicio
LEFT JOIN evento ON agenda_empleado.id_evento = evento.id_evento
ORDER BY agenda_empleado.fecha, agenda_empleado.hora_inicio;

-- RF-SER-03 — Agenda de un empleado en una fecha y hora determinada
SELECT id_agenda_empleado, fecha, hora_inicio, hora_fin, estado
FROM agenda_empleado
WHERE id_empleados = 19
  AND fecha = '2027-01-01';

-- RF-SER-03 — Reprogramar la hora de una agenda
UPDATE agenda_empleado
SET hora_inicio = '21:30:00'
WHERE id_agenda_empleado = 144;

-- RF-SER-03 — Cambiar el estado de una agenda
UPDATE agenda_empleado
SET estado = 'cancelada'
WHERE id_agenda_empleado = 143;

-- RF-SER-03 — Eliminar una agenda cancelada
DELETE FROM agenda_empleado
WHERE id_agenda_empleado = 102
  AND estado = 'cancelada';

-- RF-SER-04 — Crear una reserva de espacio VIP o mesa: consultar las reservas
SELECT reservas.id_reserva, clientes.primer_nombre, clientes.primer_apellido,
       reservas.tipo_espacio, reservas.fecha, reservas.hora, reservas.descuento, reservas.estado
FROM reservas
JOIN clientes ON reservas.id_cliente = clientes.id_cliente
ORDER BY reservas.fecha DESC;

-- RF-SER-04 — Subtotal aplicable a cada reserva
SELECT id_reserva, SUM(subtotal) AS subtotal
FROM detalle_reserva
GROUP BY id_reserva;

-- RF-SER-04 — Valor a pagar de una reserva (subtotal menos descuento)
SELECT reservas.id_reserva, SUM(detalle_reserva.subtotal) AS subtotal, reservas.descuento,
       SUM(detalle_reserva.subtotal) - reservas.descuento AS total_a_pagar
FROM reservas
JOIN detalle_reserva ON reservas.id_reserva = detalle_reserva.id_reserva
WHERE reservas.id_reserva = 3
GROUP BY reservas.id_reserva, reservas.descuento;

-- RF-SER-04 — Actualizar el descuento de una reserva
UPDATE reservas
SET descuento = 20000.00
WHERE id_reserva = 3;

-- RF-SER-04 — Cambiar el estado de una reserva (confirmar)
UPDATE reservas
SET estado = 'confirmada'
WHERE id_reserva = 27;

-- RF-SER-04 — Cambiar el estado de una reserva (cancelar)
UPDATE reservas
SET estado = 'cancelada'
WHERE id_reserva = 28;

-- RF-SER-04 — Reservas por estado
SELECT estado, COUNT(*) AS total_reservas
FROM reservas
GROUP BY estado;

-- RF-SER-05 — Conflicto: reserva de espacio ya reservada en el mismo horario
SELECT id_reserva, id_cliente, tipo_espacio, fecha, hora, estado
FROM reservas
WHERE tipo_espacio = 'vip'
  AND fecha = '2026-09-25'
  AND hora = '21:00:00'
  AND estado IN ('pendiente', 'confirmada');

-- RF-SER-05 — Horarios con más de una reserva activa del mismo espacio (0 filas)
SELECT tipo_espacio, fecha, hora, COUNT(*) AS reservas_en_conflicto
FROM reservas
WHERE estado IN ('pendiente', 'confirmada')
GROUP BY tipo_espacio, fecha, hora
HAVING COUNT(*) > 1;


-- =========================================================================
-- 4.6 Eventos
-- =========================================================================

-- RF-EVE-01 — Registrar eventos temáticos: consultar los eventos
SELECT id_evento, nombre, tematica, fecha, hora_inicio, hora_fin, estado
FROM evento
ORDER BY fecha;

-- RF-EVE-01 — Consultar un evento
SELECT id_evento, nombre, tematica, fecha, estado
FROM evento
WHERE id_evento = 16;

-- RF-EVE-01 — Actualizar un evento
UPDATE evento
SET hora_fin = '04:00:00'
WHERE id_evento = 16;

-- RF-EVE-01 — Cambiar el estado de un evento
UPDATE evento
SET estado = 'en_curso'
WHERE id_evento = 16;

-- RF-EVE-01 — Eventos por estado
SELECT estado, COUNT(*) AS total_eventos
FROM evento
GROUP BY estado;

-- RF-EVE-02 — Ficha técnica por evento: temática, franja horaria y cantidad de invitados
SELECT ficha_tecnica.id_ficha_tecnica, evento.nombre, ficha_tecnica.tematica,
       ficha_tecnica.franja_horaria, ficha_tecnica.cantidad_invitados, ficha_tecnica.observaciones
FROM ficha_tecnica
JOIN evento ON ficha_tecnica.id_evento = evento.id_evento;

-- RF-EVE-02 — Servicios requeridos por evento
SELECT evento.id_evento, evento.nombre, servicios.nombre AS servicio, ficha_servicio.cantidad_requerida
FROM ficha_tecnica
JOIN evento ON ficha_tecnica.id_evento = evento.id_evento
JOIN ficha_servicio ON ficha_tecnica.id_ficha_tecnica = ficha_servicio.id_ficha_tecnica
JOIN servicios ON ficha_servicio.id_servicio = servicios.id_servicio;

-- RF-EVE-02 — Actualizar la cantidad de invitados de la ficha técnica
UPDATE ficha_tecnica
SET cantidad_invitados = 200
WHERE id_evento = 16;

-- RF-EVE-03 — Gestionar la agenda de un evento
SELECT agenda_eventos.id_agenda_evento, evento.nombre, agenda_eventos.fecha,
       agenda_eventos.hora, agenda_eventos.descripcion, agenda_eventos.estado
FROM agenda_eventos
JOIN evento ON agenda_eventos.id_evento = evento.id_evento
ORDER BY agenda_eventos.fecha;

-- RF-EVE-03 — Asociar empleados a un evento
SELECT evento.id_evento, evento.nombre, empleados.id_empleado, empleados.primer_nombre, empleados.primer_apellido
FROM agenda_empleado
JOIN evento ON agenda_empleado.id_evento = evento.id_evento
JOIN empleados ON agenda_empleado.id_empleados = empleados.id_empleado
WHERE evento.id_evento = 24;

-- RF-EVE-03 — Asociar servicios a un evento
SELECT DISTINCT evento.id_evento, evento.nombre, servicios.nombre AS servicio
FROM agenda_empleado
JOIN evento ON agenda_empleado.id_evento = evento.id_evento
JOIN servicios ON agenda_empleado.id_servicios = servicios.id_servicio
WHERE evento.id_evento = 24;

-- RF-EVE-03 — Notificaciones a empleados sobre fechas clave: contactos de empleados de eventos programados
SELECT DISTINCT empleados.primer_nombre, empleados.primer_apellido, empleados.email, empleados.telefono,
       evento.nombre AS evento, evento.fecha
FROM agenda_empleado
JOIN empleados ON agenda_empleado.id_empleados = empleados.id_empleado
JOIN evento ON agenda_empleado.id_evento = evento.id_evento
WHERE evento.estado = 'programado'
ORDER BY evento.fecha;

-- RF-EVE-03 — Notificaciones a clientes sobre fechas clave: contactos de clientes con reserva confirmada
SELECT clientes.primer_nombre, clientes.primer_apellido, clientes.email, clientes.telefono,
       reservas.fecha, reservas.hora
FROM reservas
JOIN clientes ON reservas.id_cliente = clientes.id_cliente
WHERE reservas.estado = 'confirmada'
ORDER BY reservas.fecha;

-- RF-EVE-03 — Actualizar el estado de una actividad de la agenda del evento
UPDATE agenda_eventos
SET estado = 'completada'
WHERE id_agenda_evento = 23;

-- RF-EVE-03 — Eliminar una actividad cancelada de la agenda del evento
DELETE FROM agenda_eventos
WHERE id_agenda_evento = 17
  AND estado = 'cancelada';


-- =========================================================================
-- 4.7 Ventas, Clientes y Fidelización
-- =========================================================================

-- RF-VEN-01 — Registrar una venta asociada a un cliente y a los productos consumidos
SELECT ventas.id_venta, clientes.primer_nombre, clientes.primer_apellido, productos.nombre AS producto,
       detalle_ventas.cantidad, detalle_ventas.precio_unitario, detalle_ventas.subtotal
FROM ventas
JOIN clientes ON ventas.id_cliente = clientes.id_cliente
JOIN detalle_ventas ON ventas.id_venta = detalle_ventas.id_venta
JOIN productos ON detalle_ventas.id_producto = productos.id_producto
ORDER BY ventas.id_venta;

-- RF-VEN-01 — Generar el comprobante de pago de una venta
SELECT id_venta, comprobante_no, fecha_venta, total, metodo_pago, estado
FROM ventas
WHERE comprobante_no IS NOT NULL;

-- RF-VEN-01 — Ventas por método de pago
SELECT metodo_pago, COUNT(*) AS total_ventas, SUM(total) AS valor_total
FROM ventas
WHERE estado = 'pagada'
GROUP BY metodo_pago;

-- RF-VEN-02 — Registrar categorías de cliente: consultar las categorías con su estado
SELECT id_categoria_cliente, nombre, descripcion, estado
FROM categoria_cliente
ORDER BY estado, nombre;

-- RF-VEN-02 — Consultar una categoría de cliente
SELECT id_categoria_cliente, nombre, estado
FROM categoria_cliente
WHERE id_categoria_cliente = 1;

-- RF-VEN-02 — Consultar las categorías de cliente activas
SELECT id_categoria_cliente, nombre, descripcion, estado
FROM categoria_cliente
WHERE estado = 'activo';

-- RF-VEN-02 — Actualizar una categoría de cliente
UPDATE categoria_cliente
SET descripcion = 'Clientes con compras periódicas en la discoteca'
WHERE id_categoria_cliente = 2;

-- RF-VEN-02 — Cambiar el estado de una categoría de cliente (inactivar)
UPDATE categoria_cliente
SET estado = 'inactivo'
WHERE id_categoria_cliente = 3;

-- RF-VEN-02 — Cambiar el estado de una categoría de cliente (activar)
UPDATE categoria_cliente
SET estado = 'activo'
WHERE id_categoria_cliente = 3;

-- RF-VEN-03 — Registrar clientes clasificados por categoría
SELECT clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido, clientes.estado,
       categoria_cliente.nombre AS categoria
FROM clientes
JOIN categoria_cliente ON clientes.id_categoria_cliente = categoria_cliente.id_categoria_cliente
ORDER BY categoria_cliente.nombre, clientes.primer_apellido;

-- RF-VEN-03 — Consultar un cliente por nombre o documento
SELECT id_cliente, primer_nombre, primer_apellido, documento, telefono, email, estado
FROM clientes
WHERE primer_nombre LIKE CONCAT('%', 'Daniel', '%')
   OR documento = '1017123053';

-- RF-VEN-03 — Clientes por categoría y estado
SELECT categoria_cliente.nombre AS categoria, clientes.estado, COUNT(*) AS total_clientes
FROM clientes
JOIN categoria_cliente ON clientes.id_categoria_cliente = categoria_cliente.id_categoria_cliente
GROUP BY categoria_cliente.nombre, clientes.estado
ORDER BY categoria_cliente.nombre;

-- RF-VEN-03 — Actualizar un cliente
UPDATE clientes
SET telefono = '3171110000'
WHERE id_cliente = 2;

-- RF-VEN-03 — Cambiar el estado de un cliente (inactivar)
UPDATE clientes
SET estado = 'inactivo'
WHERE id_cliente = 2;

-- RF-VEN-03 — Cambiar el estado de un cliente (activar)
UPDATE clientes
SET estado = 'activo'
WHERE id_cliente = 2;

-- RF-VEN-04 — Crear un pedido y asociar el cliente (el pedido se maneja como una venta)
SELECT ventas.id_venta, clientes.primer_nombre, clientes.primer_apellido, ventas.fecha_venta, ventas.total, ventas.estado
FROM ventas
JOIN clientes ON ventas.id_cliente = clientes.id_cliente
ORDER BY ventas.fecha_venta DESC;

-- RF-VEN-04 — Actualizar el estado de un pedido (anular)
UPDATE ventas
SET estado = 'anulada'
WHERE id_venta = 26;

-- RF-VEN-04 — Actualizar el estado de un pedido (pagar)
UPDATE ventas
SET estado = 'pagada'
WHERE id_venta = 26;

-- RF-VEN-04 — Generar reportes: pedidos por estado
SELECT estado, COUNT(*) AS total_pedidos, SUM(total) AS valor_total
FROM ventas
GROUP BY estado;

-- RF-VEN-04 — Generar reportes: pedidos por cliente
SELECT clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido,
       COUNT(ventas.id_venta) AS total_pedidos, SUM(ventas.total) AS valor_total
FROM clientes
JOIN ventas ON clientes.id_cliente = ventas.id_cliente
GROUP BY clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido
ORDER BY valor_total DESC;

-- RF-VEN-05 — Notificaciones sobre promociones: clientes activos con correo
SELECT id_cliente, primer_nombre, primer_apellido, email, telefono
FROM clientes
WHERE estado = 'activo'
  AND email IS NOT NULL;

-- RF-VEN-05 — Notificaciones sobre eventos especiales: eventos programados
SELECT id_evento, nombre, tematica, fecha, hora_inicio
FROM evento
WHERE estado = 'programado'
ORDER BY fecha;

-- RF-VEN-05 — Notificaciones sobre cumpleaños: clientes que cumplen años este mes
SELECT id_cliente, primer_nombre, primer_apellido, fecha_nacimiento, email, telefono
FROM clientes
WHERE MONTH(fecha_nacimiento) = MONTH(CURDATE())
  AND estado = 'activo'
ORDER BY DAY(fecha_nacimiento);

-- RF-VEN-06 — Acumular puntos por cada compra: puntos por cliente según sus ventas pagadas
SELECT clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido,
       SUM(ventas.puntos) AS puntos_por_compras, clientes.puntos_acumulados
FROM clientes
JOIN ventas ON clientes.id_cliente = ventas.id_cliente
WHERE ventas.estado = 'pagada'
GROUP BY clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido, clientes.puntos_acumulados
ORDER BY puntos_por_compras DESC;

-- RF-VEN-06 — Canje: clientes con puntos suficientes (mínimo 1000)
SELECT id_cliente, primer_nombre, primer_apellido, puntos_acumulados
FROM clientes
WHERE puntos_acumulados >= 1000
  AND estado = 'activo'
ORDER BY puntos_acumulados DESC;

-- RF-VEN-06 — Canjear puntos (solo si el cliente tiene saldo suficiente)
UPDATE clientes
SET puntos_acumulados = puntos_acumulados - 500
WHERE id_cliente = 2
  AND puntos_acumulados >= 500;


-- =========================================================================
-- 4.8 Medición de Desempeño
-- =========================================================================

-- RF-DES-01 — Top 10 de clientes VIP
SELECT clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido,
       SUM(ventas.total) AS total_compras
FROM clientes
JOIN ventas ON clientes.id_cliente = ventas.id_cliente
WHERE clientes.es_vip = 1
  AND ventas.estado = 'pagada'
GROUP BY clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido
ORDER BY total_compras DESC
LIMIT 10;

-- RF-DES-01 — Top 10 de clientes generales
SELECT clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido,
       SUM(ventas.total) AS total_compras
FROM clientes
JOIN ventas ON clientes.id_cliente = ventas.id_cliente
WHERE clientes.es_vip = 0
  AND ventas.estado = 'pagada'
GROUP BY clientes.id_cliente, clientes.primer_nombre, clientes.primer_apellido
ORDER BY total_compras DESC
LIMIT 10;

-- RF-DES-02 — Servicios más solicitados
SELECT servicios.id_servicio, servicios.nombre, SUM(detalle_reserva.cantidad) AS cantidad_solicitada
FROM servicios
JOIN detalle_reserva ON servicios.id_servicio = detalle_reserva.id_servicio
GROUP BY servicios.id_servicio, servicios.nombre
ORDER BY cantidad_solicitada DESC;

-- RF-DES-02 — Servicios menos solicitados
SELECT servicios.id_servicio, servicios.nombre, COALESCE(SUM(detalle_reserva.cantidad), 0) AS cantidad_solicitada
FROM servicios
LEFT JOIN detalle_reserva ON servicios.id_servicio = detalle_reserva.id_servicio
GROUP BY servicios.id_servicio, servicios.nombre
ORDER BY cantidad_solicitada ASC;

-- RF-DES-02 — Top 3 de productos menos vendidos en un periodo
SELECT productos.id_producto, productos.nombre, SUM(detalle_ventas.cantidad) AS cantidad_vendida
FROM productos
JOIN detalle_ventas ON productos.id_producto = detalle_ventas.id_producto
JOIN ventas ON detalle_ventas.id_venta = ventas.id_venta
WHERE ventas.estado = 'pagada'
  AND ventas.fecha_venta BETWEEN '2026-01-01 00:00:00' AND '2026-12-31 23:59:59'
GROUP BY productos.id_producto, productos.nombre
ORDER BY cantidad_vendida ASC
LIMIT 3;

-- RF-DES-03 — Reporte de ventas mes a mes
SELECT YEAR(fecha_venta) AS anio, MONTH(fecha_venta) AS mes, SUM(total) AS total_ventas
FROM ventas
WHERE estado = 'pagada'
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;

-- RF-DES-03 — Mes de mayor venta
SELECT YEAR(fecha_venta) AS anio, MONTH(fecha_venta) AS mes, SUM(total) AS total_ventas
FROM ventas
WHERE estado = 'pagada'
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY total_ventas DESC
LIMIT 1;

-- RF-DES-03 — Mes de menor venta
SELECT YEAR(fecha_venta) AS anio, MONTH(fecha_venta) AS mes, SUM(total) AS total_ventas
FROM ventas
WHERE estado = 'pagada'
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY total_ventas ASC
LIMIT 1;

-- RF-DES-03 — Subtotales de ventas mensuales
SELECT YEAR(ventas.fecha_venta) AS anio, MONTH(ventas.fecha_venta) AS mes,
       SUM(detalle_ventas.subtotal) AS subtotal_mensual
FROM ventas
JOIN detalle_ventas ON ventas.id_venta = detalle_ventas.id_venta
WHERE ventas.estado = 'pagada'
GROUP BY YEAR(ventas.fecha_venta), MONTH(ventas.fecha_venta)
ORDER BY anio, mes;

-- RF-DES-03 — Comparativo: eventos temáticos
SELECT 'Eventos tematicos' AS tipo, COUNT(evento.id_evento) AS total,
       SUM(ficha_tecnica.cantidad_invitados) AS invitados
FROM evento
JOIN ficha_tecnica ON evento.id_evento = ficha_tecnica.id_evento
WHERE evento.estado <> 'cancelado';

-- RF-DES-03 — Comparativo: fiestas privadas (reservas de cumpleaños o evento privado)
SELECT 'Fiestas privadas' AS tipo, COUNT(DISTINCT detalle_reserva.id_reserva) AS total,
       SUM(detalle_reserva.subtotal) AS valor_reservas
FROM detalle_reserva
WHERE detalle_reserva.id_servicio IN (3, 6);