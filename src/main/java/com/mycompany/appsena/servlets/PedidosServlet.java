package com.mycompany.appsena.servlets;

import com.mycompany.appsena.models.Pedido;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, "root", "");
            Statement stmt = conn.createStatement();
            
            // --- Logica de Acciones POST (idéntica a ProductosServlet) ---
            if (accion != null) {
                switch (accion) {
                    case "agregar": {
                        // OJO: Los nombres de los parámetros vienen del formulario del modal
                        String referencia = request.getParameter("pedido-referencia");
                        String cliente = request.getParameter("pedido-nombre-cliente");
                        double total = Double.parseDouble(request.getParameter("pedido-total"));
                        
                        stmt.executeUpdate("INSERT INTO pedidos (referencia, nombre_cliente, fecha_pedido, total, estado) VALUES ('" + referencia + "', '" + cliente + "', NOW(), " + total + ", 'Pendiente')");
                        break;
                    }
                    case "editar": {
                        // OJO: Los nombres de los parámetros vienen del formulario del modal
                        int id = Integer.parseInt(request.getParameter("pedido-id"));
                        String referencia = request.getParameter("pedido-referencia");
                        String cliente = request.getParameter("pedido-nombre-cliente");
                        double total = Double.parseDouble(request.getParameter("pedido-total"));
                        
                        stmt.executeUpdate("UPDATE pedidos SET referencia = '" + referencia + "', nombre_cliente = '" + cliente + "', total = " + total + " WHERE id = " + id);
                        break;
                    }
                    case "eliminar": {
                        int id = Integer.parseInt(request.getParameter("id"));
                        // Por si hay detalles, los borramos primero para evitar errores
                        stmt.executeUpdate("DELETE FROM pedido_detalles WHERE pedido_id = " + id);
                        stmt.executeUpdate("DELETE FROM pedidos WHERE id = " + id);
                        break;
                    }
                }
            }

            // --- Cargar la lista de pedidos (con búsqueda) ---
            ArrayList<Pedido> listaPedidos = new ArrayList<>();
            String buscar = request.getParameter("buscar");
            String sqlQuery = "SELECT * FROM pedidos";
            if (buscar != null && !buscar.trim().isEmpty()) {
                sqlQuery += " WHERE referencia LIKE '%" + buscar + "%' OR nombre_cliente LIKE '%" + buscar + "%'";
            }
             sqlQuery += " ORDER BY id DESC";
            
            ResultSet rs = stmt.executeQuery(sqlQuery);
            while (rs.next()) {
                listaPedidos.add(new Pedido(rs.getInt("id"), rs.getString("referencia"), rs.getString("nombre_cliente"), rs.getTimestamp("fecha_pedido"), rs.getDouble("total"), rs.getString("estado")));
            }
            request.setAttribute("listaPedidos", listaPedidos);
            
            rs.close();
            stmt.close();
            conn.close();
            
            // Reenviar al JSP
            RequestDispatcher rd = request.getRequestDispatcher("pedidos.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { processRequest(request, response); }
}