 package com.iti.telecom.beans;
 
 import java.io.Serializable;
 import java.util.Locale;
 import java.util.ResourceBundle;
 
 public class StartCell
   implements Serializable
 {
   private static final long serialVersionUID = 1615881166300251233L;
   private String name = "Start Cell ";
 
   private String action = null;
 
   public String toString()
   {
     return getName();
   }
 
   public String getName()
   {
     return this.name;
   }
 
   public void setName(String name)
   {
     this.name = name;
   }
 
   public String getAction()
   {
     return this.action;
   }
 
   public void setAction(String action)
   {
     this.action = action;
   }
 }

