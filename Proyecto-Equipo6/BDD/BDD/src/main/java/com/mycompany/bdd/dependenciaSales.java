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
public class dependenciaSales {
    Connection conexion1 = null;
    
        String conexion = "jdbc:sqlserver://aworksbdd.database.windows.net:1434;" 
                          + "databaseName=AW_Sales;"
                          + "user=awroksbdd;"
                          + "password=Gearsofwar&3;"
                          + "loginTimeout=30";
     
    public Connection establecerConexion3(){
        try {
            conexion1 = DriverManager.getConnection(conexion);
            //JOptionPane.showMessageDialog(null, "Conexion establecida con AW_Sales");
            return conexion1;
        } 
        catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.toString());
            System.out.println(ex.toString());
            return null;
        }
    }   
}
