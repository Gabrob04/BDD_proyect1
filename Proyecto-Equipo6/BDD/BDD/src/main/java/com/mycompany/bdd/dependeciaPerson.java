/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.bdd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.swing.JOptionPane;

/**
 *
 * @author Usuario
 */
class dependeciaPerson {
    Connection conexion1 = null;
    
        String conexion = "jdbc:sqlserver://127.0.0.1:1433;" 
                          + "databaseName=AdventureWorks2019;"
                          + "user=sa;"
                          + "password=123;"
                          + "loginTimeout=30";
     
    public Connection establecerConexion1(){
        try {
            conexion1 = DriverManager.getConnection(conexion);
            JOptionPane.showMessageDialog(null, "Conexion establecida");
            return conexion1;
        } 
        catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.toString());
            System.out.println(ex.toString());
            return null;
        }
    }   
}
