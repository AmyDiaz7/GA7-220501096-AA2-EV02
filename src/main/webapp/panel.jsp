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

      .is-valid {
        border-color: #28a745 !important;
        box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25) !important;
      }

      .is-invalid {
        border-color: #dc3545 !important;
        box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
      }

      .valid-feedback {
        color: #28a745;
        font-size: 0.875rem;
        margin-top: 0.25rem;
      }

      .invalid-feedback {
        color: #dc3545;
        font-size: 0.875rem;
        margin-top: 0.25rem;
      }
    </style>
  </head>
  <body class="vh-100">
    <% if (session.getAttribute("usuario") == null) {
    response.sendRedirect("index.html"); return; } %>

    <div class="d-flex vh-100">
      <div
        class="modal fade"
        id="exampleModal"
        tabindex="-1"
        aria-labelledby="exampleModalLabel"
        aria-hidden="true"
      >
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h1 class="modal-title fs-5" id="exampleModalLabel">
                New message
              </h1>
              <button
                type="button"
                class="btn-close"
                data-bs-dismiss="modal"
                aria-label="Close"
              ></button>
            </div>
            <div class="modal-body">
              <form>
                <div class="mb-3">
                  <label for="recipient-name" class="col-form-label"
                    >Recipient:</label
                  >
                  <input type="text" class="form-control" id="recipient-name" />
                </div>
                <div class="mb-3">
                  <label for="message-text" class="col-form-label"
                    >Message:</label
                  >
                  <textarea class="form-control" id="message-text"></textarea>
                </div>
              </form>
            </div>
            <div class="modal-footer">
              <button
                type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal"
              >
                Close
              </button>
              <button type="button" class="btn btn-primary">
                Send message
              </button>
            </div>
          </div>
        </div>
      </div>

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
            <a href="productos" class="nav-link active" aria-current="page">
              <i class="bi bi-box-seam me-2"></i>
              Gestión de Inventario
            </a>
          </li>
          <li class="nav-item">
            <a href="pedidos" class="nav-link text-white">
              <i class="bi bi-receipt-cutoff me-2"></i>
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
          <h1 class="h2">Gestión de Inventario</h1>
          <button
            class="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#formProductoModal"
          >
            <i class="bi bi-plus-circle-fill me-2"></i>
            Registrar Producto
          </button>
        </header>

        <div class="card shadow-sm">
          <div class="card-header">
            <h2 class="h5 mb-0">Listado de Productos</h2>
          </div>
          <div class="card-body">
            <form method="get" action="productos" class="mb-3">
              <input
                type="text"
                name="buscar"
                value="${param.buscar}"
                placeholder="Buscar por SKU o Nombre... 🔍"
                class="form-control"
              />
            </form>
            <div class="table-responsive">
              <table class="table table-striped table-hover align-middle">
                <thead class="table-light">
                  <tr>
                    <th>SKU</th>
                    <th>Nombre</th>
                    <th>Stock</th>
                    <th>Valor</th>
                    <th>Estado</th>
                    <th class="text-end">Acciones</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="prod" items="${listaProductos}">
                    <tr>
                      <td>${prod.sku}</td>
                      <td>${prod.nombre}</td>
                      <td>${prod.stock}</td>
                      <td>${prod.precio}</td>
                      <td>
                        <span
                          class="${prod.stock > 0 ? 'badge bg-success' : 'badge bg-danger'}"
                          >${prod.stock > 0 ? 'Disponible' : 'Agotado'}</span
                        >
                      </td>
                      <td class="text-end">
                        <button
                          class="btn btn-sm btn-outline-warning"
                          title="Editar"
                          data-bs-toggle="modal"
                          data-bs-target="#formProductoModal"
                          data-prod-id="${prod.id}"
                          data-prod-sku="${prod.sku}"
                          data-prod-nombre="${prod.nombre}"
                          data-prod-stock="${prod.stock}"
                          data-prod-precio="${prod.precio}"
                        >
                          <i class="bi bi-pencil-square"></i>
                        </button>
                        <button
                          class="btn btn-sm btn-outline-danger"
                          title="Eliminar"
                          data-bs-toggle="modal"
                          data-bs-target="#modalEliminar"
                          data-prod-id="${prod.id}"
                          data-prod-nombre="${prod.nombre}"
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
      id="formProductoModal"
      tabindex="-1"
      aria-labelledby="modalProductoLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalProductoLabel"></h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form
              method="post"
              action="productos"
              id="formProducto"
              onfocusout="validarInputsFormulario(event)"
            >
              <input type="hidden" name="accion" value="agregar" />
              <div class="mb-3">
                <label for="producto-sku" class="form-label">SKU:</label>
                <input
                  type="text"
                  class="form-control"
                  id="producto-sku"
                  name="producto-sku"
                  placeholder="Ej: TM001"
                  required
                />
              </div>
              <div class="mb-3">
                <label for="producto-nombre" class="form-label"
                  >Nombre Producto:</label
                >
                <input
                  type="text"
                  class="form-control"
                  id="producto-nombre"
                  name="producto-nombre"
                  placeholder="Ej: Tornillo mediano"
                  required
                />
              </div>
              <div class="row">
                <div class="col-md-6 mb-3">
                  <label for="producto-stock" class="form-label">Stock:</label>
                  <input
                    type="number"
                    class="form-control"
                    step="1"
                    id="producto-stock"
                    name="producto-stock"
                    placeholder="Ej: 30"
                    required
                  />
                </div>
                <div class="col-md-6 mb-3">
                  <label for="producto-valor" class="form-label">Valor:</label>
                  <input
                    type="number"
                    class="form-control"
                    min="0"
                    step="0.01"
                    id="producto-valor"
                    name="producto-valor"
                    placeholder="Ej: 5000"
                    required
                  />
                </div>
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
            <button type="submit" class="btn btn-primary" form="formProducto">
              Guardar Producto
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
            <h5 class="modal-title" id="modalEliminarLabel">
              Eliminar producto
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form method="post" action="productos" id="formEliminar">
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
      const exampleModal = document.getElementById("modalEliminar");
      if (exampleModal) {
        exampleModal.addEventListener("show.bs.modal", (event) => {
          const button = event.relatedTarget;
          document.getElementById("modalEliminarId").value =
            button.getAttribute("data-prod-id");
          document.getElementById("modalEliminarNombre").textContent =
            button.getAttribute("data-prod-nombre");
        });
      }
    </script>
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
    <script>
      const modalProducto = document.getElementById("formProductoModal");

      modalProducto.addEventListener("show.bs.modal", function (event) {
        const boton = event.relatedTarget;

        const id = boton.getAttribute("data-prod-id");
        const sku = boton.getAttribute("data-prod-sku");
        const nombre = boton.getAttribute("data-prod-nombre");
        const stock = boton.getAttribute("data-prod-stock");
        const precio = boton.getAttribute("data-prod-precio");

        const form = document.getElementById("formProducto");

        document.getElementById("modalProductoLabel").textContent = id
          ? "Editar Producto"
          : "Registrar Producto";
        document.querySelector(
          ".modal-body:has(#formProducto) + .modal-footer > .btn-primary"
        ).textContent = id ? "Guardar Cambios" : "Guardar Producto";
        console.log(
          "xd",
          document.querySelector(
            ".modal-body:has(#formProducto) + .modal-footer > .btn-primary"
          )
        );

        if (id) {
          form.querySelector('[name="accion"]').value = "editar";

          let campoId = form.querySelector('[name="producto-id"]');
          if (!campoId) {
            campoId = document.createElement("input");
            campoId.type = "hidden";
            campoId.name = "producto-id";
            form.appendChild(campoId);
          }

          campoId.value = id;
          form.querySelector('[name="producto-sku"]').value = sku;
          form.querySelector('[name="producto-nombre"]').value = nombre;
          form.querySelector('[name="producto-stock"]').value = stock;
          form.querySelector('[name="producto-valor"]').value =
            parseFloat(precio).toFixed(2);
        } else {
          form.reset();
          form.querySelector('[name="accion"]').value = "agregar";
          const idInput = form.querySelector('[name="producto-id"]');
          if (idInput) idInput.remove();

          const inputs = form.querySelectorAll(".form-control");
          inputs.forEach((input) => {
            input.classList.remove("is-valid", "is-invalid");
          });

          const feedbacks = form.querySelectorAll(
            ".valid-feedback, .invalid-feedback"
          );
          feedbacks.forEach((feedback) => feedback.remove());
        }
      });
      document
        .querySelector("form")
        .addEventListener("submit", function (event) {
          event.preventDefault();

          setTimeout(() => {
            this.submit();
          }, 20000);
        });
    </script>

    <div
      class="toast-container position-fixed bottom-0 end-0 p-3"
      style="z-index: 1055"
    >
      <div
        id="toastExito"
        class="toast align-items-center text-bg-success border-0"
        role="alert"
        aria-live="assertive"
        aria-atomic="true"
      >
        <div class="d-flex">
          <div class="toast-body" id="toastExitoMensaje"></div>
          <button
            type="button"
            class="btn-close btn-close-white me-2 m-auto"
            data-bs-dismiss="toast"
            aria-label="Close"
          ></button>
        </div>
      </div>

      <div
        id="toastError"
        class="toast align-items-center text-bg-danger border-0"
        role="alert"
        aria-live="assertive"
        aria-atomic="true"
      >
        <div class="d-flex">
          <div class="toast-body" id="toastErrorMensaje"></div>
          <button
            type="button"
            class="btn-close btn-close-white me-2 m-auto"
            data-bs-dismiss="toast"
            aria-label="Close"
          ></button>
        </div>
      </div>
    </div>

    <script>
      function mostrarExito(mensaje) {
        const toastElement = document.getElementById("toastExito");
        const toastMensaje = document.getElementById("toastExitoMensaje");
        toastMensaje.textContent = mensaje;
        const toast = new bootstrap.Toast(toastElement);
        toast.show();
      }

      function mostrarError(mensaje) {
        const toastElement = document.getElementById("toastError");
        const toastMensaje = document.getElementById("toastErrorMensaje");
        toastMensaje.textContent = mensaje;
        const toast = new bootstrap.Toast(toastElement);
        toast.show();
      }

      document.addEventListener("DOMContentLoaded", function () {
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get("error");
        const success = urlParams.get("success");
        const sku = urlParams.get("sku");

        if (error === "sku_duplicado") {
          mostrarError(
            `El SKU '\${sku}' ya existe. Por favor, usa un SKU diferente.`
          );

          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        } else if (error === "id_invalido") {
          mostrarError(
            "Error: ID de producto inválido. No se pudo eliminar el producto."
          );

          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        } else if (success === "eliminado") {
          mostrarExito("Producto eliminado correctamente.");
          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        } else if (success === "creado") {
          mostrarExito("Producto creado correctamente.");
          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        } else if (success === "editado") {
          mostrarExito("Producto editado correctamente.");
          window.history.replaceState(
            {},
            document.title,
            window.location.pathname
          );
        }
      });

      function agregarValidacionTiempoReal() {
        const inputs = [
          {
            selector: "#producto-sku",
            validacion: validarSKU,
            mensaje: "El SKU debe tener entre 3 y 20 caracteres alfanuméricos.",
          },
          {
            selector: "#producto-nombre",
            validacion: validarNombre,
            mensaje: "El nombre debe tener entre 2 y 100 caracteres.",
          },
          {
            selector: "#producto-stock",
            validacion: validarStock,
            mensaje: "El stock debe ser un número entero mayor o igual a 0.",
          },
          {
            selector: "#producto-valor",
            validacion: validarPrecio,
            mensaje: "El precio debe ser un número mayor a 0.",
          },
        ];

        inputs.forEach(({ selector, validacion, mensaje }) => {
          const elemento = document.querySelector(selector);
          if (elemento) {
            elemento.addEventListener("blur", function () {
              const esValido = validacion(this.value);
              mostrarValidacion(this, esValido, mensaje);
            });

            elemento.addEventListener("input", function () {
              this.classList.remove("is-invalid");
              const feedbackElement = this.nextElementSibling;
              if (
                feedbackElement &&
                feedbackElement.classList.contains("invalid-feedback")
              ) {
                feedbackElement.remove();
              }
            });
          }
        });
      }

      function validarSKU(sku) {
        return (
          sku &&
          sku.length >= 3 &&
          sku.length <= 20 &&
          /^[a-zA-Z0-9]+$/.test(sku)
        );
      }

      function validarNombre(nombre) {
        return nombre && nombre.trim().length >= 2 && nombre.length <= 100;
      }

      function validarStock(stock) {
        const num = parseInt(stock);
        return !isNaN(num) && num >= 0;
      }

      function validarPrecio(precio) {
        const num = parseFloat(precio);
        return !isNaN(num) && num > 0;
      }

      function mostrarValidacion(elemento, esValido, mensajeError) {
        elemento.classList.remove("is-valid", "is-invalid");
        const feedbackAnterior = elemento.nextElementSibling;
        if (
          feedbackAnterior &&
          (feedbackAnterior.classList.contains("valid-feedback") ||
            feedbackAnterior.classList.contains("invalid-feedback"))
        ) {
          feedbackAnterior.remove();
        }

        if (esValido) {
          elemento.classList.add("is-valid");
          const feedback = document.createElement("div");
          feedback.className = "valid-feedback";
          feedback.textContent = "✓ Campo válido";
          elemento.parentNode.insertBefore(feedback, elemento.nextSibling);
        } else {
          elemento.classList.add("is-invalid");
          const feedback = document.createElement("div");
          feedback.className = "invalid-feedback";
          feedback.textContent = mensajeError;
          elemento.parentNode.insertBefore(feedback, elemento.nextSibling);
        }
      }

      function validarFormularioProducto() {
        const sku = document.querySelector("#producto-sku").value;
        const nombre = document.querySelector("#producto-nombre").value;
        const stock = document.querySelector("#producto-stock").value;
        const precio = document.querySelector("#producto-valor").value;

        const skuValido = validarSKU(sku);
        const nombreValido = validarNombre(nombre);
        const stockValido = validarStock(stock);
        const precioValido = validarPrecio(precio);

        mostrarValidacion(
          document.querySelector("#producto-sku"),
          skuValido,
          "El SKU debe tener entre 3 y 20 caracteres alfanuméricos."
        );
        mostrarValidacion(
          document.querySelector("#producto-nombre"),
          nombreValido,
          "El nombre debe tener entre 2 y 100 caracteres."
        );
        mostrarValidacion(
          document.querySelector("#producto-stock"),
          stockValido,
          "El stock debe ser un número entero mayor o igual a 0."
        );
        mostrarValidacion(
          document.querySelector("#producto-valor"),
          precioValido,
          "El precio debe ser un número mayor a 0."
        );

        return skuValido && nombreValido && stockValido && precioValido;
      }

      document.addEventListener("DOMContentLoaded", function () {
        agregarValidacionTiempoReal();

        const formulario = document.querySelector("#formProducto");
        if (formulario) {
          formulario.addEventListener("submit", function (e) {
            if (!validarFormularioProducto()) {
              e.preventDefault();
              mostrarError(
                "Por favor, corrige los errores en el formulario antes de continuar."
              );
            }
          });
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
