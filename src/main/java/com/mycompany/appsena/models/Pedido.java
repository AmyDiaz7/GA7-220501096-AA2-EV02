package com.mycompany.appsena.models;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Pedido {
    private int id;
    private String referencia;
    private String nombreCliente;
    private Timestamp fecha;
    private double total;
    private String estado;

    public Pedido(int id, String referencia, String nombreCliente, Timestamp fecha, double total, String estado) {
        this.id = id;
        this.referencia = referencia;
        this.nombreCliente = nombreCliente;
        this.fecha = fecha;
        this.total = total;
        this.estado = estado;
    }
    
    public String getFechaDatetimeLocal() {
        if (this.fecha == null) return "";
        return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(this.fecha);
    }
    
    public String getFechaFormateada() {
        if (this.fecha == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy HH:mm").format(this.fecha);
    }

    public int getId() { return id; }
    public String getReferencia() { return referencia; }
    public String getNombreCliente() { return nombreCliente; }
    public Timestamp getFecha() { return fecha; } // <-- Devuelve Timestamp
    public double getTotal() { return total; }
    public String getEstado() { return estado; }
}