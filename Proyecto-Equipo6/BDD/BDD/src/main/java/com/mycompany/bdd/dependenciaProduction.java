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
public class dependenciaProduction {
    Connection conexion1 = null;
    
        String conexion = "jdbc:sqlserver://ls-1.database.windows.net:1433;" 
                          + "databaseName=AW_Production;"
                          + "user=itzeeel_cava;"
                          + "password=itzelCV2020.;"
                          + "loginTimeout=30";
     
    public Connection establecerConexion2(){
        try {
            conexion1 = DriverManager.getConnection(conexion);
            //JOptionPane.showMessageDialog(null, "Conexion establecida con AW_Production");
            return conexion1;
        } 
        catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.toString());
            System.out.println(ex.toString());
            return null;
        }
    }
}
