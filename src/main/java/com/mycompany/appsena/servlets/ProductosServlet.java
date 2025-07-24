/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
        ArrayList<Producto> productos = new ArrayList<>();
        String accion = request.getParameter("accion");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection conn = DriverManager.getConnection(url, "root", "");
            Statement stmt = conn.createStatement();

            System.out.println("xdial");
            
            System.out.println("producto-id");

            System.out.println(request.getParameter("accion"));
            if (accion != null) {
                switch (accion) {
                    case "eliminar": {
                        String id = request.getParameter("id");
                        stmt.executeUpdate("DELETE FROM `productos` WHERE `id` = " + id);
                        break;
                    }
                    case "agregar": {
                        String sku = request.getParameter("producto-sku");
                        String nombre = request.getParameter("producto-nombre");
                        int stock = Integer.parseInt(request.getParameter("producto-stock"));
                        double precio = Double.parseDouble(request.getParameter("producto-valor"));

                        stmt.executeUpdate("INSERT INTO `productos` (`sku`, `nombre`, `stock`, `precio`) VALUES ('" + sku + "','" + nombre + "', '" + stock + "', '" + precio + "')");
                        break;
                    }
                    case "editar": {
                        int id = Integer.parseInt(request.getParameter("producto-id"));
                        String sku = request.getParameter("producto-sku");
                        String nombre = request.getParameter("producto-nombre");
                        int stock = Integer.parseInt(request.getParameter("producto-stock"));
                        double precio = Double.parseDouble(request.getParameter("producto-valor"));

                        stmt.executeUpdate("UPDATE `productos` SET `sku`='" + sku + "', `nombre`='" + nombre + "', `stock`='" + stock + "', `precio`='" + precio + "' WHERE `id`='" + id + "'");
                        break;
                    }
                }
            }

            String buscar = request.getParameter("buscar");
            String sqlQuery = "SELECT * FROM productos";
            if (buscar != null) {
                sqlQuery += " WHERE CONCAT(id, sku, nombre, stock, precio) LIKE '%" + buscar + "%'";
            }
            ResultSet rs = stmt.executeQuery(sqlQuery);

            while (rs.next()) {
                Producto prod = new Producto(rs.getInt("id"), rs.getString("sku"), rs.getString("nombre"), rs.getInt("stock"), rs.getDouble("precio"));
                productos.add(prod);
            }

            conn.close();
            stmt.close();
            rs.close();

            request.setAttribute("listaProductos", productos);
            RequestDispatcher rd = request.getRequestDispatcher("panel.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
