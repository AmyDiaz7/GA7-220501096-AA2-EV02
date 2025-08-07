package com.mycompany.appsena.servlets;

import com.mycompany.appsena.models.Producto;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 *
 * @author sanaa
 */
@WebServlet(name = "ProductosServlet", urlPatterns = {"/productos"})
public class ProductosServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
                    case "listar": {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        
                        String sqlQuery = "SELECT * FROM productos WHERE stock > 0 ORDER BY nombre";
                        rs = stmt.executeQuery(sqlQuery);
                        
                        Gson gson = new Gson();
                        JsonArray productosArray = new JsonArray();
                        
                        while (rs.next()) {
                            JsonObject producto = new JsonObject();
                            producto.addProperty("id", rs.getInt("id"));
                            producto.addProperty("sku", rs.getString("sku"));
                            producto.addProperty("nombre", rs.getString("nombre"));
                            producto.addProperty("stock", rs.getInt("stock"));
                            producto.addProperty("valor", rs.getDouble("precio"));
                            productosArray.add(producto);
                        }
                        
                        String jsonResponse = gson.toJson(productosArray);
                        
                        try (PrintWriter out = response.getWriter()) {
                            out.print(jsonResponse);
                            out.flush();
                        }
                        return;
                    }
                    case "eliminar": {
                        String id = request.getParameter("id");
                        
                        if (id == null || id.trim().isEmpty()) {
                            response.sendRedirect("productos?error=id_invalido");
                            return;
                        }
                        
                        stmt.executeUpdate("DELETE FROM `productos` WHERE `id` = " + id);
                        
                        response.sendRedirect("productos?success=eliminado");
                        return;
                    }
                    case "agregar": {
                        String sku = request.getParameter("producto-sku");
                        String nombre = request.getParameter("producto-nombre");
                        int stock = Integer.parseInt(request.getParameter("producto-stock"));
                        double precio = Double.parseDouble(request.getParameter("producto-valor"));

                        try {
                            stmt.executeUpdate("INSERT INTO `productos` (`sku`, `nombre`, `stock`, `precio`) VALUES ('" + sku + "','" + nombre + "', '" + stock + "', '" + precio + "')");
                            response.sendRedirect("productos?success=creado");
                            return;
                        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
                            if (e.getMessage().contains("sku")) {
                                response.sendRedirect("productos?error=sku_duplicado&sku=" + sku);
                                return;
                            } else {
                                throw e;
                            }
                        }
                    }
                    case "editar": {
                        int id = Integer.parseInt(request.getParameter("producto-id"));
                        String sku = request.getParameter("producto-sku");
                        String nombre = request.getParameter("producto-nombre");
                        int stock = Integer.parseInt(request.getParameter("producto-stock"));
                        double precio = Double.parseDouble(request.getParameter("producto-valor"));

                        try {
                            stmt.executeUpdate("UPDATE `productos` SET `sku`='" + sku + "', `nombre`='" + nombre + "', `stock`='" + stock + "', `precio`='" + precio + "' WHERE `id`='" + id + "'");
                            response.sendRedirect("productos?success=editado");
                            return;
                        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
                            if (e.getMessage().contains("sku")) {
                                response.sendRedirect("productos?error=sku_duplicado&sku=" + sku);
                                return;
                            } else {
                                throw e;
                            }
                        }
                    }
                }
            }

            ArrayList<Producto> productos = new ArrayList<>();
            String buscar = request.getParameter("buscar");
            String sqlQuery = "SELECT * FROM productos";
            if (buscar != null) {
                sqlQuery += " WHERE CONCAT(id, sku, nombre, stock, precio) LIKE '%" + buscar + "%'";
            }
            rs = stmt.executeQuery(sqlQuery);

            while (rs.next()) {
                Producto prod = new Producto(rs.getInt("id"), rs.getString("sku"), rs.getString("nombre"), rs.getInt("stock"), rs.getDouble("precio"));
                productos.add(prod);
            }

            request.setAttribute("listaProductos", productos);
            RequestDispatcher rd = request.getRequestDispatcher("panel.jsp");
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
