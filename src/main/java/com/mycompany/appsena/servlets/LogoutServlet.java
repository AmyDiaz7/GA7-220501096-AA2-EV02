package com.mycompany.appsena.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// La URL a la que apuntaremos desde el botón
@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet"})
public class LogoutServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener la sesión actual
        HttpSession session = request.getSession(false); // 'false' para no crear una nueva si no existe
        
        System.out.println("Cerrando sesion...");

        // 2. Verificar si la sesión existe antes de invalidarla
        if (session != null) {
            session.invalidate(); // Esto destruye la sesión y borra todos los atributos
            System.out.println("Sesion invalidada correctamente.");
        }

        // 3. Redirigir al usuario a la página de login (index.html)
        // Usamos request.getContextPath() para que la URL sea correcta sin importar el nombre del proyecto
        response.sendRedirect(request.getContextPath() + "/index.html");
        System.out.println("Redirigiendo a index.html");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}