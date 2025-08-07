<%-- Document : panel Created on : 9 jul 2025, 16:17:09 Author : sanaa --%>
<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@page
import="java.util.List" %> <%@page
import="com.mycompany.appsena.models.Producto" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>JSP Page</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr"
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css"
    />
    <style>
      body {
        background-color: #f8f9fa;
      }
      .sidebar {
        width: 280px;
        min-height: 100vh;
      }
      .main-content {
        flex-grow: 1;
      }

      .is-invalid {
        border-color: #dc3545 !important;
        padding-right: calc(1.5em + 0.75rem);
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath d='m5.8 3.6.4.4.4-.4'/%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right calc(0.375em + 0.1875rem) center;
        background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
      }

      .invalid-feedback {
        width: 100%;
        margin-top: 0.25rem;
        font-size: 0.875em;
        color: #dc3545;
        display: none;
      }

      .is-invalid ~ .invalid-feedback {
        display: block;
      }

      .toast-container {
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 1055;
      }

      .modal {
        z-index: 1050;
      }

      .modal-backdrop {
        z-index: 1040;
      }

      .modal-dialog {
        margin: 1.75rem auto;
        max-width: 500px;
      }

      .modal-content {
        background-color: #fff;
        border: 1px solid rgba(0, 0, 0, 0.2);
        border-radius: 0.375rem;
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
      }

      .loading-products {
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%236c757d' d='M12,1A11,11,0,1,0,23,12,11,11,0,0,0,12,1Zm0,19a8,8,0,1,1,8-8A8,8,0,0,1,12,20Z' opacity='.25'/%3E%3Cpath fill='%23007bff' d='M12,4a8,8,0,0,1,7.89,6.7A1.53,1.53,0,0,0,21.38,12h0a1.5,1.5,0,0,0,1.48-1.75,11,11,0,0,0-21.72,0A1.5,1.5,0,0,0,2.62,12h0a1.53,1.53,0,0,0,1.49-1.3A8,8,0,0,1,12,4Z'%3E%3CanimateTransform attributeName='transform' dur='0.75s' repeatCount='indefinite' type='rotate' values='0 12 12;360 12 12'/%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 8px center;
        background-size: 20px;
      }
    </style>
  </head>
  <body class="vh-100">
    <% if (session.getAttribute("usuario") == null) {
    response.sendRedirect("index.html"); return; } %>

    <div class="d-flex vh-100">
      <aside
        class="sidebar d-flex flex-column p-3 text-white bg-dark min-vh-100"
      >
        <a
          href="/"
          class="d-flex flex-column align-items-center mb-3 mb-md-0 text-white text-decoration-none"
        >
          <img src="imagenes/logo-gt.png" alt="Logo" width="160" class="mb-2" />
          <span class="fs-4">FerreStock</span>
        </a>
        <hr />
        <ul class="nav nav-pills flex-column mb-auto">
          <li class="nav-item">
            <a href="productos" class="nav-link text-white">
              <i class="bi bi-receipt-cutoff me-2"></i>
              Gestión de Inventario
            </a>
          </li>
          <li class="nav-item">
            <a href="pedidos" class="nav-link active" aria-current="page">
              <i class="bi bi-box-seam me-2"></i>
              Gestión de Pedidos
            </a>
          </li>
        </ul>
        <hr />
        <div class="usuario-info text-center">
          <p class="mb-1">Usuario: <b>Administrador</b></p>
          <button
            class="btn btn-sm btn-danger w-100"
            onclick="window.location.href = 'LogoutServlet'"
          >
            <i class="bi bi-box-arrow-right me-2"></i>
            Cerrar Sesión
          </button>
        </div>
      </aside>

      <main class="main-content flex-grow-1 overflow-auto p-4 bg-light">
        <header
          class="d-flex justify-content-between align-items-center pb-3 mb-4 border-bottom"
        >
          <h1 class="h2">Gestión de Pedidos</h1>

          <button
            class="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#formPedidoModal"
          >
            <i class="bi bi-plus-circle-fill me-2"></i>
            Registrar Pedido
          </button>
        </header>

        <div class="card shadow-sm">
          <div class="card-header">
            <h2 class="h5 mb-0">Listado de Pedidos</h2>
          </div>
          <div class="card-body">
            <form method="get" action="pedidos" class="mb-3">
              <input
                type="text"
                name="buscar"
                value="${param.buscar}"
                placeholder="Buscar por pedidos... 🔍"
                class="form-control"
              />
            </form>
            <div class="table-responsive">
              <table class="table table-striped table-hover align-middle">
                <thead class="table-light">
                  <tr>
                    <th>Referencia</th>
                    <th>Nombre cliente</th>
                    <th>Fecha pedido</th>
                    <th>Total</th>
                    <th>Estado</th>
                    <th class="text-end">Acciones</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="p" items="${listaPedidos}">
                    <tr>
                      <td>${p.referencia}</td>
                      <td>${p.nombreCliente}</td>
                      <td>${p.fechaFormateada}</td>
                      <td>${p.total}</td>
                      <td>
                        <span
                          class="${p.estado == 'Entregado' ? 'badge bg-success' : 'badge bg-warning'}"
                          >${p.estado}</span
                        >
                      </td>
                      <td class="text-end">
                        <button
                          class="btn btn-sm btn-outline-warning"
                          title="Editar"
                          data-bs-toggle="modal"
                          data-bs-target="#formPedidoModal"
                          data-pedido-id="${p.id}"
                          data-pedido-referencia="${p.referencia}"
                          data-pedido-nombre-cliente="${p.nombreCliente}"
                          data-pedido-fecha="${p.fechaDatetimeLocal}"
                          data-pedido-total="${p.total}"
                          data-pedido-estado="${p.estado}"
                        >
                          <i class="bi bi-pencil-square"></i>
                        </button>
                        <button
                          class="btn btn-sm btn-outline-danger"
                          title="Eliminar"
                          data-bs-toggle="modal"
                          data-bs-target="#modalEliminar"
                          data-pedido-id="${p.id}"
                          data-pedido-referencia="${p.referencia}"
                        >
                          <i class="bi bi-trash3-fill"></i>
                        </button>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </main>
    </div>

    <div
      class="modal fade"
      id="formPedidoModal"
      tabindex="-1"
      aria-labelledby="modalPedidoLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalPedidoLabel"></h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form method="post" action="pedidos" id="formPedido">
              <input type="hidden" name="accion" value="agregar" />

              <div class="row">
                <div class="col-md-6 mb-3">
                  <label for="pedido-referencia" class="form-label"
                    >Referencia:</label
                  >
                  <input
                    type="text"
                    class="form-control"
                    id="pedido-referencia"
                    name="pedido-referencia"
                    placeholder="Ej: PED-2025-001"
                    required
                  />
                  <div class="invalid-feedback">
                    Por favor ingrese una referencia válida.
                  </div>
                </div>
                <div class="col-md-6 mb-3">
                  <label for="pedido-nombre-cliente" class="form-label"
                    >Nombre Cliente:</label
                  >
                  <input
                    type="text"
                    class="form-control"
                    id="pedido-nombre-cliente"
                    name="pedido-nombre-cliente"
                    placeholder="Ej: Juan Perez"
                    required
                  />
                  <div class="invalid-feedback">
                    Por favor ingrese el nombre del cliente.
                  </div>
                </div>
              </div>

              <div class="row">
                <div class="col-md-4 mb-3">
                  <label for="pedido-fecha" class="form-label">Fecha:</label>
                  <input
                    type="datetime-local"
                    class="form-control"
                    id="pedido-fecha"
                    name="pedido-fecha"
                    required
                  />
                  <div class="invalid-feedback">
                    Por favor seleccione una fecha válida.
                  </div>
                </div>
                <div class="col-md-4 mb-3">
                  <label for="pedido-total" class="form-label">Total:</label>
                  <input
                    type="number"
                    class="form-control"
                    min="0"
                    step="0.01"
                    id="pedido-total"
                    name="pedido-total"
                    placeholder="Se calcula automáticamente"
                    readonly
                  />
                </div>
                <div class="col-md-4 mb-3">
                  <label for="pedido-estado" class="form-label">Estado:</label>
                  <select
                    class="form-select"
                    id="pedido-estado"
                    name="pedido-estado"
                    required
                  >
                    <option value="">Seleccionar estado</option>
                    <option value="Pendiente" selected>Pendiente</option>
                    <option value="Pagado">Pagado</option>
                    <option value="Bodega">Bodega</option>
                    <option value="Transportando">Transportando</option>
                    <option value="Entregado">Entregado</option>
                  </select>
                  <div class="invalid-feedback">
                    Por favor seleccione un estado.
                  </div>
                </div>
              </div>

              <!-- Sección de productos -->
              <hr class="my-4" />
              <div class="row mb-3">
                <div class="col-md-12">
                  <h6 class="mb-3">Productos del Pedido</h6>

                  <!-- Formulario para agregar productos -->
                  <div class="card border-light bg-light mb-3">
                    <div class="card-body">
                      <div class="row g-2">
                        <div class="col-md-5">
                          <label class="form-label">Producto:</label>
                          <select class="form-select" id="select-producto">
                            <option value="">Cargando productos...</option>
                          </select>
                          <div class="invalid-feedback">
                            Por favor seleccione un producto.
                          </div>
                        </div>
                        <div class="col-md-2">
                          <label class="form-label">Cantidad:</label>
                          <input
                            type="number"
                            class="form-control"
                            id="detalle-cantidad"
                            min="1"
                            value="1"
                            required
                          />
                          <div class="invalid-feedback">
                            Cantidad debe ser mayor a 0.
                          </div>
                        </div>
                        <div class="col-md-2">
                          <label class="form-label">Precio:</label>
                          <input
                            type="number"
                            class="form-control"
                            id="detalle-precio"
                            step="0.01"
                            readonly
                          />
                        </div>
                        <div class="col-md-2">
                          <label class="form-label">Subtotal:</label>
                          <input
                            type="number"
                            class="form-control"
                            id="detalle-subtotal"
                            readonly
                          />
                        </div>
                        <div class="col-md-1 d-flex align-items-end">
                          <button
                            type="button"
                            class="btn btn-success w-100"
                            id="btnAgregarDetalle"
                          >
                            <i class="bi bi-plus"></i>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Tabla de productos agregados -->
                  <div class="table-responsive">
                    <table class="table table-sm table-bordered">
                      <thead class="table-light">
                        <tr>
                          <th>Producto</th>
                          <th>Cantidad</th>
                          <th>Precio Unit.</th>
                          <th>Subtotal</th>
                          <th width="80">Acciones</th>
                        </tr>
                      </thead>
                      <tbody id="detallesBody">
                        <tr id="sinProductos">
                          <td colspan="5" class="text-center text-muted">
                            No hay productos agregados
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

              <!-- Campos hidden para enviar arrays al servlet -->
              <input
                type="hidden"
                name="detallesEliminados"
                id="detallesEliminados"
                value="[]"
              />
              <input
                type="hidden"
                name="detallesAgregados"
                id="detallesAgregados"
                value="[]"
              />
              <input
                type="hidden"
                name="detallesEditados"
                id="detallesEditados"
                value="[]"
              />
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancelar
            </button>
            <button
              type="submit"
              class="btn btn-primary"
              form="formPedido"
              onclick="return validarYEnviarPedido()"
            >
              Guardar Pedido
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Eliminar Pedido -->
    <div
      class="modal fade"
      id="modalEliminar"
      tabindex="-1"
      aria-labelledby="modalEliminarLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalEliminarLabel">Eliminar pedido</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form method="post" action="pedidos" id="formEliminar">
              <input type="hidden" name="accion" value="eliminar" />
              <input type="hidden" name="id" id="modalEliminarId" />
            </form>
            <p>
              ¿Estás seguro de que deseas eliminar
              <strong id="modalEliminarNombre"></strong>?
            </p>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancelar
            </button>
            <button type="submit" class="btn btn-danger" form="formEliminar">
              Eliminar
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast container para notificaciones -->
    <div
      class="toast-container position-fixed top-0 end-0 p-3"
      id="toastContainer"
    ></div>

    <script>
      // Variables globales para manejar los detalles
      let detallesOriginales = []; // Detalles que venían de la BD
      let detallesActuales = []; // Detalles actuales en pantalla
      let detallesEliminados = []; // IDs de detalles eliminados
      let detallesAgregados = []; // Nuevos detalles agregados
      let detallesEditados = []; // Detalles existentes que se editaron

      let productosDisponibles = [];
      let editandoIndex = -1;
      let contadorTemporal = -1; // Para asignar IDs temporales a detalles nuevos

      // Cargar productos disponibles al inicializar
      document.addEventListener("DOMContentLoaded", function () {
        // Verificar errores y éxitos en URL
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get("error");
        const success = urlParams.get("success");
        const referencia = urlParams.get("referencia");

        if (error === "referencia_duplicada") {
          mostrarError(
            `La referencia '\${referencia}' ya existe. Por favor, usa una referencia diferente.`
          );
          // Limpiar la URL
          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        } else if (error === "id_invalido") {
          mostrarError(
            "Error: ID de pedido inválido. No se pudo eliminar el pedido."
          );
          // Limpiar la URL
          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        } else if (success === "eliminado") {
          mostrarExito("Pedido eliminado correctamente.");
          // Limpiar la URL
          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        }

        cargarProductos();
        agregarValidacionTiempoReal();
      });

      // Cargar productos desde el servlet API
      async function cargarProductos() {
        const select = document.getElementById("select-producto");
        select.innerHTML = '<option value="">Cargando productos...</option>';
        select.classList.add("loading-products");

        try {
          const response = await fetch("productos?accion=listar");
          if (response.ok) {
            const data = await response.json();
            productosDisponibles = data;
            actualizarSelectProductos();
            console.log("✅ Productos cargados correctamente:", data.length);
          } else {
            throw new Error("Error del servidor");
          }
        } catch (error) {
          console.error("Error al cargar productos:", error);
          mostrarError(
            "Error al cargar los productos. Se usarán productos de ejemplo."
          );
          // Fallback con productos de ejemplo
          productosDisponibles = [
            { id: 1, nombre: "Martillo", valor: 25000, stock: 10 },
            { id: 2, nombre: "Destornillador", valor: 15000, stock: 20 },
            { id: 3, nombre: "Taladro", valor: 120000, stock: 5 },
            { id: 4, nombre: "Tornillos", valor: 500, stock: 100 },
            { id: 5, nombre: "Clavos", valor: 300, stock: 200 },
          ];
          actualizarSelectProductos();
        } finally {
          select.classList.remove("loading-products");
        }
      }

      // Actualizar el select de productos
      function actualizarSelectProductos() {
        const select = document.getElementById("select-producto");
        select.innerHTML = '<option value="">Seleccionar producto...</option>';

        productosDisponibles.forEach((producto) => {
          const option = document.createElement("option");
          option.value = producto.id;
          option.textContent = `\${producto.nombre} - $\${producto.valor.toLocaleString()}`;
          option.dataset.precio = producto.valor;
          option.dataset.nombre = producto.nombre;
          select.appendChild(option);
        });
      }

      // Manejar selección de producto
      document
        .getElementById("select-producto")
        .addEventListener("change", function () {
          const selectedOption = this.selectedOptions[0];
          if (selectedOption && selectedOption.value) {
            document.getElementById("detalle-precio").value =
              selectedOption.dataset.precio;
            calcularSubtotal();
            limpiarValidacionCampo(this);
          } else {
            document.getElementById("detalle-precio").value = "";
            document.getElementById("detalle-subtotal").value = "";
          }
        });

      // Calcular subtotal automáticamente
      document
        .getElementById("detalle-cantidad")
        .addEventListener("input", function () {
          calcularSubtotal();
          if (this.value && this.value > 0) {
            limpiarValidacionCampo(this);
          }
        });

      function calcularSubtotal() {
        const cantidad =
          parseInt(document.getElementById("detalle-cantidad").value) || 0;
        const precio =
          parseFloat(document.getElementById("detalle-precio").value) || 0;
        const subtotal = cantidad * precio;
        document.getElementById("detalle-subtotal").value = subtotal.toFixed(2);
      }

      // Agregar producto a la tabla
      document
        .getElementById("btnAgregarDetalle")
        .addEventListener("click", function () {
          if (!validarFormularioDetalle()) return;

          const selectProducto = document.getElementById("select-producto");
          const productoId = parseInt(selectProducto.value);
          const productoNombre =
            selectProducto.selectedOptions[0].dataset.nombre;
          const cantidad = parseInt(
            document.getElementById("detalle-cantidad").value
          );
          const precio = parseFloat(
            document.getElementById("detalle-precio").value
          );

          // Validaciones adicionales
          if (!validarProductoDuplicado(productoId)) return;
          if (!validarStock(productoId, cantidad)) return;

          const detalle = {
            productoId: productoId,
            productoNombre: productoNombre,
            cantidad: cantidad,
            precio: precio,
            subtotal: cantidad * precio,
          };

          if (editandoIndex >= 0) {
            // Editando producto existente
            const detalleAnterior = detallesActuales[editandoIndex];
            detalle.id = detalleAnterior.id;
            detalle.esNuevo = detalleAnterior.esNuevo;

            detallesActuales[editandoIndex] = detalle;

            // Si no es nuevo, agregar a la lista de editados
            if (!detalle.esNuevo) {
              const indexEditado = detallesEditados.findIndex(
                (e) => e.id === detalle.id
              );
              const detalleEditado = {
                id: detalle.id,
                productoId: detalle.productoId,
                cantidad: detalle.cantidad,
                precio: detalle.precio,
              };

              if (indexEditado >= 0) {
                detallesEditados[indexEditado] = detalleEditado;
              } else {
                detallesEditados.push(detalleEditado);
              }
            } else {
              // Si es nuevo, actualizar en la lista de agregados
              const indexAgregado = detallesAgregados.findIndex(
                (a) => a.tempId === detalle.id
              );
              if (indexAgregado >= 0) {
                detallesAgregados[indexAgregado] = {
                  tempId: detalle.id,
                  productoId: detalle.productoId,
                  cantidad: detalle.cantidad,
                  precio: detalle.precio,
                };
              }
            }

            editandoIndex = -1;
            document.getElementById("btnAgregarDetalle").innerHTML =
              '<i class="bi bi-plus"></i>';
            document.getElementById("btnAgregarDetalle").className =
              "btn btn-success w-100";
            mostrarExito(
              `Producto \${productoNombre} actualizado correctamente.`
            );
          } else {
            // Nuevo producto
            detalle.id = contadorTemporal--;
            detalle.esNuevo = true;

            detallesActuales.push(detalle);
            detallesAgregados.push({
              tempId: detalle.id,
              productoId: detalle.productoId,
              cantidad: detalle.cantidad,
              precio: detalle.precio,
            });

            mostrarExito(`Producto \${productoNombre} agregado correctamente.`);
          }

          actualizarTablaDetalles();
          calcularTotalPedido();
          limpiarFormularioDetalle();
        });

      // Validar formulario de detalle
      function validarFormularioDetalle() {
        let esValido = true;

        const selectProducto = document.getElementById("select-producto");
        const inputCantidad = document.getElementById("detalle-cantidad");

        if (!selectProducto.value) {
          mostrarValidacionCampo(
            selectProducto,
            "Por favor seleccione un producto."
          );
          esValido = false;
        }

        if (!inputCantidad.value || inputCantidad.value <= 0) {
          mostrarValidacionCampo(
            inputCantidad,
            "La cantidad debe ser mayor a 0."
          );
          esValido = false;
        }

        return esValido;
      }

      // Actualizar tabla de detalles
      function actualizarTablaDetalles() {
        const tbody = document.getElementById("detallesBody");

        if (detallesActuales.length === 0) {
          tbody.innerHTML =
            '<tr id="sinProductos"><td colspan="5" class="text-center text-muted">No hay productos agregados</td></tr>';
          return;
        }

        tbody.innerHTML = "";

        detallesActuales.forEach((detalle, index) => {
          const row = document.createElement("tr");
          const badgeNuevo = detalle.esNuevo
            ? ' <span class="badge bg-success">Nuevo</span>'
            : "";
          const badgeEditado =
            !detalle.esNuevo &&
            detallesEditados.find((e) => e.id === detalle.id)
              ? ' <span class="badge bg-warning">Editado</span>'
              : "";

          row.innerHTML = `
            <td>\${detalle.productoNombre}\${badgeNuevo}\${badgeEditado}</td>
            <td>\${detalle.cantidad}</td>
            <td>$\${parseFloat(detalle.precio).toLocaleString()}</td>
            <td>$\${parseFloat(detalle.subtotal).toLocaleString()}</td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-warning me-1" onclick="editarDetalle(\${index})" title="Editar">
                <i class="bi bi-pencil"></i>
              </button>
              <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarDetalle(\${index})" title="Eliminar">
                <i class="bi bi-trash"></i>
              </button>
            </td>
          `;
          tbody.appendChild(row);
        });
      }

      // Editar detalle
      function editarDetalle(index) {
        const detalle = detallesActuales[index];

        document.getElementById("select-producto").value = detalle.productoId;
        document.getElementById("detalle-cantidad").value = detalle.cantidad;
        document.getElementById("detalle-precio").value = detalle.precio;
        document.getElementById("detalle-subtotal").value = detalle.subtotal;

        editandoIndex = index;
        document.getElementById("btnAgregarDetalle").innerHTML =
          '<i class="bi bi-check"></i>';
        document.getElementById("btnAgregarDetalle").className =
          "btn btn-warning w-100";
      }

      // Eliminar detalle
      function eliminarDetalle(index) {
        if (!confirm("¿Está seguro de eliminar este producto del pedido?"))
          return;

        const detalle = detallesActuales[index];

        // Si el detalle no es nuevo (existe en BD), agregarlo a eliminados
        if (!detalle.esNuevo && detalle.id > 0) {
          detallesEliminados.push(detalle.id);

          // Remover de editados si estaba ahí
          const indexEditado = detallesEditados.findIndex(
            (e) => e.id === detalle.id
          );
          if (indexEditado >= 0) {
            detallesEditados.splice(indexEditado, 1);
          }
        } else {
          // Si es nuevo, removerlo de agregados
          const indexAgregado = detallesAgregados.findIndex(
            (a) => a.tempId === detalle.id
          );
          if (indexAgregado >= 0) {
            detallesAgregados.splice(indexAgregado, 1);
          }
        }

        // Remover de la lista actual
        detallesActuales.splice(index, 1);

        actualizarTablaDetalles();
        calcularTotalPedido();

        // Si estaba editando este item, cancelar edición
        if (editandoIndex === index) {
          cancelarEdicion();
        }

        mostrarExito("Producto eliminado correctamente.");
      }

      // Cancelar edición
      function cancelarEdicion() {
        editandoIndex = -1;
        document.getElementById("btnAgregarDetalle").innerHTML =
          '<i class="bi bi-plus"></i>';
        document.getElementById("btnAgregarDetalle").className =
          "btn btn-success w-100";
        limpiarFormularioDetalle();
      }

      // Limpiar formulario de detalle
      function limpiarFormularioDetalle() {
        document.getElementById("select-producto").value = "";
        document.getElementById("detalle-cantidad").value = "1";
        document.getElementById("detalle-precio").value = "";
        document.getElementById("detalle-subtotal").value = "";

        // Limpiar validaciones
        limpiarValidacionCampo(document.getElementById("select-producto"));
        limpiarValidacionCampo(document.getElementById("detalle-cantidad"));
      }

      // Calcular total del pedido
      function calcularTotalPedido() {
        const total = detallesActuales.reduce(
          (sum, detalle) => sum + parseFloat(detalle.subtotal),
          0
        );
        document.getElementById("pedido-total").value = total.toFixed(2);
      }

      // Validar y enviar pedido
      function validarYEnviarPedido() {
        if (!validarFormularioPedido()) {
          mostrarError(
            "Por favor corrija los errores en el formulario antes de continuar."
          );
          return false;
        }

        if (detallesActuales.length === 0) {
          mostrarError("Debe agregar al menos un producto al pedido.");
          return false;
        }

        // Validar que el total sea mayor a 0
        const total = parseFloat(document.getElementById("pedido-total").value);
        if (total <= 0) {
          mostrarError("El total del pedido debe ser mayor a 0.");
          return false;
        }

        // Confirmar antes de enviar
        const accion = document.querySelector('[name="accion"]').value;
        const mensaje =
          accion === "editar"
            ? "¿Está seguro de que desea guardar los cambios en este pedido?"
            : "¿Está seguro de que desea crear este pedido?";

        if (!confirm(mensaje)) {
          return false;
        }

        prepararEnvioDetalles();
        mostrarExito("Enviando pedido...");
        return true;
      }

      // Validar formulario principal del pedido
      function validarFormularioPedido() {
        let esValido = true;
        const form = document.getElementById("formPedido");

        // Limpiar validaciones anteriores
        form.querySelectorAll(".is-invalid").forEach((campo) => {
          limpiarValidacionCampo(campo);
        });

        // Validar referencia
        const referencia = form.querySelector('[name="pedido-referencia"]');
        if (!referencia.value.trim()) {
          mostrarValidacionCampo(referencia, "La referencia es obligatoria.");
          esValido = false;
        } else if (referencia.value.trim().length < 3) {
          mostrarValidacionCampo(
            referencia,
            "La referencia debe tener al menos 3 caracteres."
          );
          esValido = false;
        }

        // Validar nombre cliente
        const nombreCliente = form.querySelector(
          '[name="pedido-nombre-cliente"]'
        );
        if (!nombreCliente.value.trim()) {
          mostrarValidacionCampo(
            nombreCliente,
            "El nombre del cliente es obligatorio."
          );
          esValido = false;
        } else if (nombreCliente.value.trim().length < 2) {
          mostrarValidacionCampo(
            nombreCliente,
            "El nombre debe tener al menos 2 caracteres."
          );
          esValido = false;
        }

        // Validar fecha
        const fecha = form.querySelector('[name="pedido-fecha"]');
        if (!fecha.value) {
          mostrarValidacionCampo(fecha, "La fecha es obligatoria.");
          esValido = false;
        } else {
          const fechaSeleccionada = new Date(fecha.value);
          const ahora = new Date();
          if (fechaSeleccionada > ahora) {
            mostrarValidacionCampo(fecha, "La fecha no puede ser futura.");
            esValido = false;
          }
        }

        // Validar estado
        const estado = form.querySelector('[name="pedido-estado"]');
        if (!estado.value) {
          mostrarValidacionCampo(estado, "Debe seleccionar un estado.");
          esValido = false;
        }

        return esValido;
      }

      // Preparar datos para envío al servlet
      function prepararEnvioDetalles() {
        document.getElementById("detallesEliminados").value =
          JSON.stringify(detallesEliminados);
        document.getElementById("detallesAgregados").value =
          JSON.stringify(detallesAgregados);
        document.getElementById("detallesEditados").value =
          JSON.stringify(detallesEditados);

        console.log("Enviando al servlet:");
        console.log("Eliminados:", detallesEliminados);
        console.log("Agregados:", detallesAgregados);
        console.log("Editados:", detallesEditados);
      }

      // Limpiar arrays de cambios
      function limpiarArraysCambios() {
        detallesEliminados = [];
        detallesAgregados = [];
        detallesEditados = [];
        detallesOriginales = [];
        detallesActuales = [];
        contadorTemporal = -1;
      }

      // Cargar detalles del pedido desde el servlet
      async function cargarDetallesPedido(pedidoId) {
        try {
          const response = await fetch(
            `pedidos?accion=obtenerDetalles&pedidoId=\${pedidoId}`
          );
          if (response.ok) {
            const detalles = await response.json();
            detallesOriginales = JSON.parse(JSON.stringify(detalles));
            detallesActuales = detalles.map((d) => ({
              ...d,
              esNuevo: false,
              subtotal: d.cantidad * d.precio,
            }));

            // Limpiar arrays de cambios
            detallesEliminados = [];
            detallesAgregados = [];
            detallesEditados = [];

            actualizarTablaDetalles();
            calcularTotalPedido();
          } else {
            console.error("Error al cargar detalles del pedido");
          }
        } catch (error) {
          console.error("Error al cargar detalles:", error);
        }
      }

      // Funciones de utilidad para validaciones
      function mostrarValidacionCampo(campo, mensaje) {
        campo.classList.add("is-invalid");
        let feedback = campo.nextElementSibling;
        if (feedback && feedback.classList.contains("invalid-feedback")) {
          feedback.textContent = mensaje;
        }

        // Scroll al primer campo con error
        if (document.querySelector(".is-invalid") === campo) {
          campo.scrollIntoView({ behavior: "smooth", block: "center" });
        }
      }

      function limpiarValidacionCampo(campo) {
        campo.classList.remove("is-invalid");
      }

      function mostrarError(mensaje) {
        mostrarToast(mensaje, "error");
      }

      function mostrarExito(mensaje) {
        mostrarToast(mensaje, "success");
      }

      function mostrarAdvertencia(mensaje) {
        mostrarToast(mensaje, "warning");
      }

      // Sistema de toasts para notificaciones
      function mostrarToast(mensaje, tipo = "info", duracion = 5000) {
        // Esperar un pequeño delay para asegurar que el DOM esté listo
        setTimeout(() => {
          const toastContainer = document.getElementById("toastContainer");
          if (!toastContainer) {
            console.error("No se encontró el contenedor de toasts");
            return;
          }

          const toastId =
            "toast-" +
            Date.now() +
            "-" +
            Math.random().toString(36).substr(2, 9);

          let bgClass = "bg-primary";
          let iconClass = "bi-info-circle";

          switch (tipo) {
            case "success":
              bgClass = "bg-success";
              iconClass = "bi-check-circle";
              break;
            case "error":
              bgClass = "bg-danger";
              iconClass = "bi-exclamation-triangle";
              duracion = 8000;
              break;
            case "warning":
              bgClass = "bg-warning";
              iconClass = "bi-exclamation-triangle";
              break;
          }

          const toastHTML = `
            <div class="toast \${bgClass} text-white" id="\${toastId}" role="alert" aria-live="assertive" aria-atomic="true">
              <div class="toast-header \${bgClass} text-white border-0">
                <i class="bi \${iconClass} me-2"></i>
                <strong class="me-auto">FerreStock</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
              </div>
              <div class="toast-body">
                \${mensaje}
              </div>
            </div>
          `;

          toastContainer.insertAdjacentHTML("beforeend", toastHTML);

          const toastElement = document.getElementById(toastId);
          if (!toastElement) {
            console.error("No se pudo crear el elemento toast");
            return;
          }

          // Verificar que Bootstrap esté disponible
          if (typeof bootstrap === "undefined") {
            console.error("Bootstrap no está disponible");
            return;
          }

          const toast = new bootstrap.Toast(toastElement, { delay: duracion });
          toast.show();

          // Remover el toast del DOM después de ocultarse
          toastElement.addEventListener("hidden.bs.toast", function () {
            toastElement.remove();
          });
        }, 100);
      }

      // Validaciones en tiempo real
      function agregarValidacionTiempoReal() {
        // Validación de referencia
        document
          .getElementById("pedido-referencia")
          .addEventListener("input", function () {
            const valor = this.value.trim();
            if (valor.length < 3) {
              mostrarValidacionCampo(
                this,
                "La referencia debe tener al menos 3 caracteres."
              );
            } else if (!/^[A-Z0-9\-]+$/i.test(valor)) {
              mostrarValidacionCampo(
                this,
                "Solo se permiten letras, números y guiones."
              );
            } else {
              limpiarValidacionCampo(this);
            }
          });

        // Validación de nombre cliente
        document
          .getElementById("pedido-nombre-cliente")
          .addEventListener("input", function () {
            const valor = this.value.trim();
            if (valor.length < 2) {
              mostrarValidacionCampo(
                this,
                "El nombre debe tener al menos 2 caracteres."
              );
            } else if (!/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/.test(valor)) {
              mostrarValidacionCampo(
                this,
                "Solo se permiten letras y espacios."
              );
            } else {
              limpiarValidacionCampo(this);
            }
          });

        // Validación de fecha
        document
          .getElementById("pedido-fecha")
          .addEventListener("change", function () {
            const fechaSeleccionada = new Date(this.value);
            const ahora = new Date();
            const hace1Ano = new Date();
            hace1Ano.setFullYear(ahora.getFullYear() - 1);

            if (fechaSeleccionada > ahora) {
              mostrarValidacionCampo(this, "La fecha no puede ser futura.");
            } else if (fechaSeleccionada < hace1Ano) {
              mostrarValidacionCampo(
                this,
                "La fecha no puede ser mayor a 1 año atrás."
              );
            } else {
              limpiarValidacionCampo(this);
            }
          });

        // Validación de cantidad
        document
          .getElementById("detalle-cantidad")
          .addEventListener("input", function () {
            const valor = parseInt(this.value);
            if (isNaN(valor) || valor <= 0) {
              mostrarValidacionCampo(
                this,
                "La cantidad debe ser un número mayor a 0."
              );
            } else if (valor > 1000) {
              mostrarValidacionCampo(
                this,
                "La cantidad no puede ser mayor a 1000."
              );
            } else {
              limpiarValidacionCampo(this);
            }
          });
      }

      
      function validarProductoDuplicado(productoId) {
        const productoExistente = detallesActuales.find(
          (d) => d.productoId === parseInt(productoId)
        );
        if (productoExistente && editandoIndex === -1) {
          const nombreProducto =
            document.getElementById("select-producto").selectedOptions[0]
              ?.dataset.nombre || "este producto";
          mostrarError(
            `\${nombreProducto} ya está en el pedido con cantidad \${productoExistente.cantidad}. Puede editarlo desde la tabla.`
          );
          return false;
        }
        return true;
      }

      function validarStock(productoId, cantidadSolicitada) {
        const producto = productosDisponibles.find(
          (p) => p.id === parseInt(productoId)
        );
        if (producto && producto.stock < cantidadSolicitada) {
          mostrarError(
            `Stock insuficiente. Solo hay \${producto.stock} unidades disponibles de \${producto.nombre}.`
          );
          return false;
        }
        return true;
      }

      const modalPedido = document.getElementById("formPedidoModal");

      modalPedido.addEventListener("show.bs.modal", function (event) {
        const boton = event.relatedTarget;
        const id = boton.getAttribute("data-pedido-id");
        const referencia = boton.getAttribute("data-pedido-referencia");
        const nombreCliente = boton.getAttribute("data-pedido-nombre-cliente");
        const fecha = boton.getAttribute("data-pedido-fecha");
        const total = boton.getAttribute("data-pedido-total");
        const estado = boton.getAttribute("data-pedido-estado");

        const form = document.getElementById("formPedido");

        document.getElementById("modalPedidoLabel").textContent = id
          ? "Editar Pedido"
          : "Registrar Pedido";
        document.querySelector(
          ".modal-body:has(#formPedido) + .modal-footer > .btn-primary"
        ).textContent = id ? "Guardar Cambios" : "Guardar Pedido";

        if (id) {
          form.querySelector('[name="accion"]').value = "editar";

          let campoId = form.querySelector('[name="pedido-id"]');
          if (!campoId) {
            campoId = document.createElement("input");
            campoId.type = "hidden";
            campoId.name = "pedido-id";
            form.appendChild(campoId);
          }

          campoId.value = id;
          form.querySelector('[name="pedido-referencia"]').value = referencia;
          form.querySelector('[name="pedido-nombre-cliente"]').value =
            nombreCliente;
          form.querySelector('[name="pedido-fecha"]').value = fecha;
          form.querySelector('[name="pedido-total"]').value = total;
          form.querySelector('[name="pedido-estado"]').value = estado;

          cargarDetallesPedido(id);
        } else {
          form.reset();
          form.querySelector('[name="accion"]').value = "agregar";
          const idInput = form.querySelector('[name="pedido-id"]');
          if (idInput) idInput.remove();

          limpiarArraysCambios();
          actualizarTablaDetalles();
          cancelarEdicion();
        }

        form.querySelectorAll(".is-invalid").forEach((campo) => {
          limpiarValidacionCampo(campo);
        });
      });

      document
        .getElementById("formPedidoModal")
        .addEventListener("hidden.bs.modal", function () {
          limpiarFormularioDetalle();
          cancelarEdicion();
        });

      const modalEliminar = document.getElementById("modalEliminar");
      if (modalEliminar) {
        modalEliminar.addEventListener("show.bs.modal", (event) => {
          const button = event.relatedTarget;
          document.getElementById("modalEliminarId").value =
            button.getAttribute("data-pedido-id");
          document.getElementById("modalEliminarNombre").textContent =
            button.getAttribute("data-pedido-referencia");
        });
      }
    </script>

    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q"
      crossorigin="anonymous"
    ></script>
  </body>
</html>
