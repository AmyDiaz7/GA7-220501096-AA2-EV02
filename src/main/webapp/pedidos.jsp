<%-- 
    Document   : pedidos
    Author     : sanaa (Estilo Productos)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, com.mycompany.appsena.models.Pedido" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Gestión de Pedidos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { width: 280px; min-height: 100vh; }
        .main-content { flex-grow: 1; }
    </style>
</head>
<body class="vh-100">
    <% if (session.getAttribute("usuario") == null) { response.sendRedirect("index.html"); return; } %>
    <div class="d-flex vh-100">
        <!-- ===== Sidebar ===== -->
        <aside class="sidebar d-flex flex-column p-3 text-white bg-dark">
            <a href="/" class="d-flex flex-column align-items-center mb-3 text-white text-decoration-none">
                <img src="imagenes/logo-gt.png" alt="Logo" width="160" class="mb-2">
                <span class="fs-4">FerreStock</span>
            </a><hr>
            <ul class="nav nav-pills flex-column mb-auto">
                <li><a href="productos" class="nav-link text-white"><i class="bi bi-box-seam me-2"></i>Gestión de Inventario</a></li>
                <li class="nav-item"><a href="pedidos" class="nav-link active" aria-current="page"><i class="bi bi-receipt-cutoff me-2"></i>Gestión de Pedidos</a></li>
            </ul><hr>
            <div class="usuario-info text-center">
                <p class="mb-1">Usuario: <b>Administrador</b></p>
                <button class="btn btn-sm btn-danger w-100" onclick="window.location.href = 'LogoutServlet'"><i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión</button>
            </div>
        </aside>

        <!-- ===== Contenido Principal ===== -->
        <main class="main-content flex-grow-1 overflow-auto p-4 bg-light">
            <header class="d-flex justify-content-between align-items-center pb-3 mb-4 border-bottom">
                <h1 class="h2">Gestión de Pedidos</h1>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#formPedidoModal">
                    <i class="bi bi-plus-circle-fill me-2"></i>Registrar Pedido
                </button>
            </header>

            <!-- ===== Tabla de Datos ===== -->
            <div class="card shadow-sm">
                <div class="card-header"><h2 class="h5 mb-0">Listado de Pedidos</h2></div>
                <div class="card-body">
                    <form method="get" action="pedidos" class="mb-3">
                        <input type="text" name="buscar" value="${param.buscar}" placeholder="Buscar por Referencia o Cliente... 🔍" class="form-control" />
                    </form>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover align-middle">
                            <thead class="table-light">
                                <tr><th>Referencia</th><th>Cliente</th><th>Fecha</th><th>Total</th><th>Estado</th><th class="text-end">Acciones</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="ped" items="${listaPedidos}">
                                    <tr>
                                        <td>${ped.referencia}</td>
                                        <td>${ped.nombreCliente}</td>
                                        <td>${ped.getFechaFormateada()}</td>
                                        <td><fmt:formatNumber value="${ped.total}" type="currency" currencySymbol="$ "/></td>
                                        <td><span class="badge ${ped.estado.equals("Entregado") ? 'bg-success' : 'bg-warning'}">${ped.estado}</span></td>
                                        <td class="text-end">
                                            <button class="btn btn-sm btn-outline-warning" title="Editar" data-bs-toggle="modal" data-bs-target="#formPedidoModal"
                                                    data-ped-id="${ped.id}"
                                                    data-ped-ref="${ped.referencia}"
                                                    data-ped-cliente="${ped.nombreCliente}"
                                                    data-ped-total="${ped.total}">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" title="Eliminar" data-bs-toggle="modal" data-bs-target="#modalEliminar"
                                                    data-ped-id="${ped.id}"
                                                    data-ped-ref="${ped.referencia}">
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

    <!-- ===== Modal para Formulario (Agregar/Editar) ===== -->
    <div class="modal fade" id="formPedidoModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalPedidoLabel"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form method="post" action="pedidos" id="formPedido">
                        <input type="hidden" name="accion" value="agregar">
                        <input type="hidden" name="pedido-id" id="pedido-id">

                        <div class="mb-3">
                            <label for="pedido-referencia" class="form-label">Referencia:</label>
                            <input type="text" class="form-control" id="pedido-referencia" name="pedido-referencia" required>
                        </div>
                        <div class="mb-3">
                            <label for="pedido-nombre-cliente" class="form-label">Nombre Cliente:</label>
                            <input type="text" class="form-control" id="pedido-nombre-cliente" name="pedido-nombre-cliente" required>
                        </div>
                        <div class="mb-3">
                            <label for="pedido-total" class="form-label">Total:</label>
                            <input type="number" class="form-control" step="0.01" id="pedido-total" name="pedido-total" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary" form="formPedido">Guardar</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- ===== Modal para Eliminar ===== -->
    <div class="modal fade" id="modalEliminar" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Eliminar Pedido</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="pedidos" id="formEliminar">
                    <div class="modal-body">
                        <p>¿Estás seguro de que deseas eliminar el pedido <strong id="modalEliminarRef"></strong>?</p>
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="id" id="modalEliminarId">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-danger" form="formEliminar">Eliminar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Lógica para el modal de Agregar/Editar
        const modalPedido = document.getElementById('formPedidoModal');
        modalPedido.addEventListener('show.bs.modal', function (event) {
            const boton = event.relatedTarget;
            const form = document.getElementById('formPedido');
            form.reset();

            // Usamos los mismos nombres de data- que usaste en productos: "data-prod-id" -> "data-ped-id"
            const id = boton.getAttribute('data-ped-id');
            const referencia = boton.getAttribute('data-ped-ref');
            const cliente = boton.getAttribute('data-ped-cliente');
            const total = boton.getAttribute('data-ped-total');

            if (id) { // Modo Editar
                document.getElementById('modalPedidoLabel').textContent = 'Editar Pedido';
                form.querySelector('[name="accion"]').value = 'editar';
                form.querySelector('[name="pedido-id"]').value = id;
                form.querySelector('[name="pedido-referencia"]').value = referencia;
                form.querySelector('[name="pedido-nombre-cliente"]').value = cliente;
                form.querySelector('[name="pedido-total"]').value = total;
            } else { // Modo Agregar
                document.getElementById('modalPedidoLabel').textContent = 'Registrar Pedido';
                form.querySelector('[name="accion"]').value = 'agregar';
                form.querySelector('[name="pedido-id"]').value = '';
            }
        });

        // Lógica para el modal de Eliminar
        const modalEliminar = document.getElementById('modalEliminar');
        modalEliminar.addEventListener('show.bs.modal', function (event) {
            const boton = event.relatedTarget;
            // Usamos el mismo nombre de data que en el otro modal: "data-ped-id"
            document.getElementById('modalEliminarId').value = boton.getAttribute('data-ped-id');
            document.getElementById('modalEliminarRef').textContent = boton.getAttribute('data-ped-ref');
        });
    </script>
</body>
</html>