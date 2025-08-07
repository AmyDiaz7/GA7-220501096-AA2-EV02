package com.mycompany.appsena.servlets;

import com.mycompany.appsena.models.Pedido;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

@WebServlet(name = "PedidosServlet", urlPatterns = {"/pedidos"})
public class PedidosServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.html");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/gt_app";
        String accion = request.getParameter("accion");
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, "root", "");
            stmt = conn.createStatement();
            
            if (accion != null) {
                switch (accion) {
                    case "obtenerDetalles": {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        
                        String pedidoId = request.getParameter("pedidoId");
                        String sqlDetalles = "SELECT pd.id, pd.producto_id as productoId, p.nombre as productoNombre, " +
                                            "pd.cantidad, pd.precio " +
                                            "FROM pedido_detalles pd " +
                                            "JOIN productos p ON pd.producto_id = p.id " +
                                            "WHERE pd.pedido_id = " + pedidoId;
                        
                        rs = stmt.executeQuery(sqlDetalles);
                        
                        Gson gson = new Gson();
                        JsonArray detallesArray = new JsonArray();
                        
                        while (rs.next()) {
                            JsonObject detalle = new JsonObject();
                            detalle.addProperty("id", rs.getInt("id"));
                            detalle.addProperty("productoId", rs.getInt("productoId"));
                            detalle.addProperty("productoNombre", rs.getString("productoNombre"));
                            detalle.addProperty("cantidad", rs.getInt("cantidad"));
                            detalle.addProperty("precio", rs.getDouble("precio"));
                            detallesArray.add(detalle);
                        }
                        
                        String jsonResponse = gson.toJson(detallesArray);
                        
                        try (PrintWriter out = response.getWriter()) {
                            out.print(jsonResponse);
                            out.flush();
                        }
                        return;
                    }
                    case "agregar": {
                        String referencia = request.getParameter("pedido-referencia");
                        String nombreCliente = request.getParameter("pedido-nombre-cliente");
                        String fecha = request.getParameter("pedido-fecha");
                        String estado = request.getParameter("pedido-estado");
                        double total = Double.parseDouble(request.getParameter("pedido-total"));

                        String sqlFecha = (fecha != null && !fecha.isEmpty()) ? "'" + fecha.replace("T", " ") + ":00'" : "NOW()";
                        String sqlEstado = (estado != null && !estado.isEmpty()) ? "'" + estado + "'" : "'Pendiente'";

                        try {
                            String sqlInsert = "INSERT INTO pedidos (referencia, nombre_cliente, fecha_pedido, total, estado) VALUES ('" + referencia + "', '" + nombreCliente + "', " + sqlFecha + ", " + total + ", " + sqlEstado + ")";
                            stmt.executeUpdate(sqlInsert, Statement.RETURN_GENERATED_KEYS);
                            
                            ResultSet generatedKeys = stmt.getGeneratedKeys();
                            int pedidoId = 0;
                            if (generatedKeys.next()) {
                                pedidoId = generatedKeys.getInt(1);
                            }
                            generatedKeys.close();
                            
                            procesarDetalles(request, stmt, pedidoId);
                        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
                            if (e.getMessage().contains("referencia")) {
                                response.sendRedirect("pedidos?error=referencia_duplicada&referencia=" + referencia);
                                return;
                            } else {
                                throw e;
                            }
                        }
                        break;
                    }
                    case "editar": {
                        int id = Integer.parseInt(request.getParameter("pedido-id"));
                        String referencia = request.getParameter("pedido-referencia");
                        String nombreCliente = request.getParameter("pedido-nombre-cliente");
                        String fecha = request.getParameter("pedido-fecha");
                        String estado = request.getParameter("pedido-estado");
                        double total = Double.parseDouble(request.getParameter("pedido-total"));

                        String sqlFecha = (fecha != null && !fecha.isEmpty()) ? "'" + fecha.replace("T", " ") + ":00'" : "NOW()";
                        String sqlEstado = (estado != null && !estado.isEmpty()) ? "'" + estado + "'" : "'Pendiente'";

                        stmt.executeUpdate("UPDATE pedidos SET referencia = '" + referencia + "', nombre_cliente = '" + nombreCliente + "', fecha_pedido = " + sqlFecha + ", total = " + total + ", estado = " + sqlEstado + " WHERE id = " + id);
                        
                        procesarDetalles(request, stmt, id);
                        break;
                    }
                    case "eliminar": {
                        String id = request.getParameter("id");
                        
                        if (id == null || id.trim().isEmpty()) {
                            response.sendRedirect("pedidos?error=id_invalido");
                            return;
                        }
                        
                        stmt.executeUpdate("DELETE FROM pedido_detalles WHERE pedido_id = " + id);
                        stmt.executeUpdate("DELETE FROM pedidos WHERE id = " + id);
                        
                        response.sendRedirect("pedidos?success=eliminado");
                        return;
                    }
                }
            }

            ArrayList<Pedido> listaPedidos = new ArrayList<>();
            String buscar = request.getParameter("buscar");
            String sqlQuery = "SELECT * FROM pedidos";
            if (buscar != null && !buscar.trim().isEmpty()) {
                sqlQuery += " WHERE referencia LIKE '%" + buscar + "%' OR nombre_cliente LIKE '%" + buscar + "%'";
            }
             sqlQuery += " ORDER BY id DESC";
            
            rs = stmt.executeQuery(sqlQuery);
            while (rs.next()) {
                listaPedidos.add(new Pedido(rs.getInt("id"), rs.getString("referencia"), rs.getString("nombre_cliente"), rs.getTimestamp("fecha_pedido"), rs.getDouble("total"), rs.getString("estado")));
            }
            request.setAttribute("listaPedidos", listaPedidos);
            
            RequestDispatcher rd = request.getRequestDispatcher("pedidos.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    
    private void procesarDetalles(HttpServletRequest request, Statement stmt, int pedidoId) throws Exception {
        String detallesEliminadosJson = request.getParameter("detallesEliminados");
        String detallesAgregadosJson = request.getParameter("detallesAgregados");
        String detallesEditadosJson = request.getParameter("detallesEditados");
        
        Gson gson = new Gson();
        
        if (detallesEliminadosJson != null && !detallesEliminadosJson.equals("[]")) {
            JsonArray eliminados = gson.fromJson(detallesEliminadosJson, JsonArray.class);
            for (JsonElement elemento : eliminados) {
                int detalleId = elemento.getAsInt();
                String sqlEliminar = "DELETE FROM pedido_detalles WHERE id = " + detalleId;
                stmt.executeUpdate(sqlEliminar);
            }
        }
        
        if (detallesAgregadosJson != null && !detallesAgregadosJson.equals("[]")) {
            JsonArray agregados = gson.fromJson(detallesAgregadosJson, JsonArray.class);
            for (JsonElement elemento : agregados) {
                JsonObject detalle = elemento.getAsJsonObject();
                
                int productoId = detalle.get("productoId").getAsInt();
                int cantidad = detalle.get("cantidad").getAsInt();
                double precio = detalle.get("precio").getAsDouble();
                
                String sqlAgregar = "INSERT INTO pedido_detalles (pedido_id, producto_id, cantidad, precio) " +
                                  "VALUES (" + pedidoId + ", " + productoId + ", " + cantidad + ", " + precio + ")";
                stmt.executeUpdate(sqlAgregar);
            }
        }
        
        if (detallesEditadosJson != null && !detallesEditadosJson.equals("[]")) {
            JsonArray editados = gson.fromJson(detallesEditadosJson, JsonArray.class);
            for (JsonElement elemento : editados) {
                JsonObject detalle = elemento.getAsJsonObject();
                
                int id = detalle.get("id").getAsInt();
                int productoId = detalle.get("productoId").getAsInt();
                int cantidad = detalle.get("cantidad").getAsInt();
                double precio = detalle.get("precio").getAsDouble();
                
                String sqlEditar = "UPDATE pedido_detalles SET " +
                                 "producto_id = " + productoId + ", " +
                                 "cantidad = " + cantidad + ", " +
                                 "precio = " + precio + " " +
                                 "WHERE id = " + id;
                stmt.executeUpdate(sqlEditar);
            }
        }
    }
}