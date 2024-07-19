### README.md

# Base de Datos del Bar "El Churrete"

## Estructura de la Base de Datos

### Tablas Principales

#### Establecimientos
- Almacena la información de los diferentes establecimientos del bar. Abre la puerta a tener más establecimientos en el futuro.
- **Relaciones**: 
  - Relacionada con `Empleados` y `Reservas` para vincular empleados y reservas a un establecimiento específico.

#### Empleados
- Almacena la información de los empleados del bar.
- **Relaciones**:
  - Relacionada con `Establecimientos` para asignar empleados a un establecimiento.
  - Relacionada con `Empleados_Turnos` para gestionar los turnos de los empleados.

#### Turnos
- Almacena la información de los turnos disponibles.
- **Relaciones**:
  - Relacionada con `Empleados_Turnos` para asignar turnos a los empleados.

#### Empleados_Turnos
- Almacena la asignación de turnos a los empleados en fechas específicas.
- **Relaciones**:
  - Relacionada con `Empleados` y `Turnos` para vincular empleados y turnos.

#### Productos
- Almacena la información de todos los productos ofrecidos en el bar, sin diferenciar categoría.
- **Relaciones**:
  - Relacionada con `Desayunos`, `Comidas_Cenas`, `Churros` para clasificar los productos en diferentes categorías.
  - Relacionada con `Detalle_Pedidos` para gestionar los detalles de los pedidos.
  - Relacionada con `Movimientos_Inventario` para asociar movimientos de inventario a productos específicos.
  - Relacionada con `Promociones_Productos` para asociar productos a promociones.

### Tablas de Categorías de Productos

#### Desayunos, Comidas_Cenas y Churros
- Con estas tablas se puede diferenciar a que categoría pertenece cada producto, pudiendo algunos productos estar a la vez en varias cartas.

### Tablas de Pedidos

#### Pedidos
- Almacena los pedidos realizados en el bar. Se apoya en Detalle_pedidos.
- **Relaciones**:
  - Relacionada con `Establecimientos` y `Empleados` para asociar pedidos con establecimientos y empleados.
  - Relacionada con `Detalle_Pedidos` para gestionar los detalles de los pedidos.
  - Relacionada con `Opiniones` para permitir opiniones sobre los pedidos.

#### Detalle_Pedidos
- Almacena los detalles de los productos incluidos en cada pedido. Puede generarse un ticket a partir de aquí.
- **Relaciones**:
  - Relacionada con `Pedidos` y `Productos` para detallar los productos en cada pedido.

### Tablas de Inventario

#### Inventario
- Almacena la información de los ingredientes disponibles en el inventario.

#### Movimientos_Inventario
- Almacena los movimientos de entrada y salida de ingredientes en el inventario.
- **Relaciones**:
  - Relacionada con `Inventario` y `Productos` para gestionar movimientos de inventario.

### Tablas de Clientes

#### Clientes
- Almacena la información de los clientes del bar.

#### Opiniones
- Almacena las opiniones y valoraciones de los clientes sobre los pedidos y el servicio.
- **Relaciones**:
  - Relacionada con `Clientes` y `Pedidos` para asociar opiniones con clientes y pedidos.

### Tabla de Reservas

#### Reservas
- Almacena la información de las reservas realizadas por los clientes. Gracias a las funciones implementadas con el script, se genera un número de reserva único y aleatorio para que el cliente lo pueda aportar como prueba de reserva. Aquí también se guarda el momento en el que se introduce la reserva con un NOW().
- **Relaciones**:
  - Relacionada con `Clientes` y `Establecimientos` para gestionar las reservas.

### Tablas de Proveedores

#### Proveedores
- Almacena la información de los proveedores de ingredientes.

#### Proveedores_Ingredientes
- Relaciona a los proveedores con los ingredientes que suministran.
- **Relaciones**:
  - Relacionada con `Proveedores` e `Inventario` para gestionar los ingredientes suministrados por los proveedores.

### Tablas de Promociones

#### Promociones
- Almacena la información de las promociones especiales.

#### Promociones_Productos
- Relaciona promociones con productos específicos.
- **Relaciones**:
  - Relacionada con `Promociones` y `Productos` para gestionar promociones de productos.

### Tabla de Historial de Cambios en el Menú

#### Historial_Cambios_Menu
- Almacena el historial de cambios realizados en el menú. Funciona gracias a las funciones de añadir y modificar productos.
- **Relaciones**:
  - Relacionada con `Productos` para registrar los cambios en los productos del menú.
