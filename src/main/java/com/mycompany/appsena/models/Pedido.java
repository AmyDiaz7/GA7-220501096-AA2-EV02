package com.mycompany.appsena.models;

import java.sql.Timestamp; // <-- Importamos Timestamp
import java.text.SimpleDateFormat;

public class Pedido {
    private int id;
    private String referencia;
    private String nombreCliente;
    private Timestamp fechaPedido; // <-- CAMBIO AQUÍ: de LocalDateTime a Timestamp
    private double total;
    private String estado;

    // Constructor
    public Pedido(int id, String referencia, String nombreCliente, Timestamp fechaPedido, double total, String estado) {
        this.id = id;
        this.referencia = referencia;
        this.nombreCliente = nombreCliente;
        this.fechaPedido = fechaPedido; // <-- Acepta Timestamp directamente
        this.total = total;
        this.estado = estado;
    }
    
    // Este método es clave, nos permite formatear la fecha en el JSP sin problemas.
    public String getFechaFormateada() {
        if (this.fechaPedido == null) return "";
        // Formato: 09/07/2025 16:17
        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(this.fechaPedido);
    }

    // Getters
    public int getId() { return id; }
    public String getReferencia() { return referencia; }
    public String getNombreCliente() { return nombreCliente; }
    public Timestamp getFechaPedido() { return fechaPedido; } // <-- Devuelve Timestamp
    public double getTotal() { return total; }
    public String getEstado() { return estado; }
}