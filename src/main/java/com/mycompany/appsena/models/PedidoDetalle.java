// src/main/java/com/mycompany/appsena/models/PedidoDetalle.java
package com.mycompany.appsena.models;

public class PedidoDetalle {
    private int id;
    private int pedidoId;       // <-- MUY IMPORTANTE para el JSP
    private int productoId;
    private String productoNombre; 
    private int cantidad;
    private double precio;

    public PedidoDetalle(int id, int pedidoId, int productoId, String productoNombre, int cantidad, double precio) {
        this.id = id;
        this.pedidoId = pedidoId;
        this.productoId = productoId;
        this.productoNombre = productoNombre;
        this.cantidad = cantidad;
        this.precio = precio;
    }

    // Getters
    public int getId() { return id; }
    public int getPedidoId() { return pedidoId; }
    public int getProductoId() { return productoId; }
    public String getProductoNombre() { return productoNombre; }
    public int getCantidad() { return cantidad; }
    public double getPrecio() { return precio; }
}