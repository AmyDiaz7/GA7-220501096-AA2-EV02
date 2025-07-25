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
      <div class="modal-dialog modal-dialog-centered">
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
              <div class="mb-3">
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
              </div>
              <div class="mb-3">
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
              </div>
              <div class="row">
                <div class="col-md-6 mb-3">
                  <label for="pedido-fecha" class="form-label">Fecha:</label>
                  <input
                    type="datetime-local"
                    class="form-control"
                    id="pedido-fecha"
                    name="pedido-fecha"
                    required
                  />
                </div>
                <div class="col-md-6 mb-3">
                  <label for="pedido-total" class="form-label">Total:</label>
                  <input
                    type="number"
                    class="form-control"
                    min="0"
                    step="0.01"
                    id="pedido-total"
                    name="pedido-total"
                    placeholder="Ej: 50000"
                    required
                  />
                </div>
              </div>
              <div class="mb-3">
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
              </div>
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
            <button type="submit" class="btn btn-primary" form="formPedido">
              Guardar Pedido
            </button>
          </div>
        </div>
      </div>
    </div>

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

    <script>
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
    <!--
    <script>
      function validarInputsFormulario(event) {
      const target = event.target;

      switch (target.name) {
        case "producto-stock":
        const entero = parseInt(target.value);
        if (!isNaN(entero)) {
          target.value = entero;
        } else {
          target.value = "0";
        }
        break;

        case "producto-valor":
        const decimal = parseFloat(target.value);
        if (!isNaN(decimal)) {
          target.value = decimal.toFixed(2);
        } else {
          target.value = "0";
        }
        break;
      }
      }
    </script>
    -->
    <script>
      const modalPedido = document.getElementById("formPedidoModal");

      modalPedido.addEventListener("show.bs.modal", function (event) {
        const boton = event.relatedTarget; // el botón que abrió el modal

        const id = boton.getAttribute("data-pedido-id");
        const referencia = boton.getAttribute("data-pedido-referencia");
        const nombreCliente = boton.getAttribute("data-pedido-nombre-cliente");
        const fecha = boton.getAttribute("data-pedido-fecha");
        const total = boton.getAttribute("data-pedido-total");
        const estado = boton.getAttribute("data-pedido-estado");

        console.log(event);
        console.log(id, referencia, nombreCliente, fecha, total, estado);

        const form = document.getElementById("formPedido");

        document.getElementById("modalPedidoLabel").textContent = id
          ? "Editar Pedido"
          : "Registrar Pedido";
        document.querySelector(
          ".modal-body:has(#formPedido) + .modal-footer > .btn-primary"
        ).textContent = id ? "Guardar Cambios" : "Guardar Pedido";
        console.log(
          "xd",
          document.querySelector(
            ".modal-body:has(#formPedido) + .modal-footer > .btn-primary"
          )
        );

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
        } else {
          form.reset();
          form.querySelector('[name="accion"]').value = "agregar";
          const idInput = form.querySelector('[name="id"]');
          if (idInput) idInput.remove();
        }
      });
    </script>

    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q"
      crossorigin="anonymous"
    ></script>
  </body>
</html>
