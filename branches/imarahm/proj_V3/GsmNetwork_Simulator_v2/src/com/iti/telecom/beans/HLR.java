/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iti.telecom.beans;

import java.io.Serializable;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.print.DocFlavor.STRING;

/**
 *
 * @author ahmed_amer
 */
public class HLR implements Serializable {

    private static final long serialVersionUID = 1111111111747448484L;
    private String hlrName ="HLR1";
    private String niSpc;
    private String Gt;
    private long startRange=0;
    private long endRange=0;
    private String Action = null;
    private String propertyOne;
    private Object mscEdge;
    private Object vlrEdge;
    private Object gatewayEdge;

    public String getAction() {
        return Action;
    }

    public void setAction(String Action) {
        this.Action = Action;
    }

    public Object getGatewayEdge() {
        return gatewayEdge;
    }

    public void setGatewayEdge(Object gatewayEdge) {
        this.gatewayEdge = gatewayEdge;
    }

    public String getHlrName() {
        return hlrName;
    }

    public void setHlrName(String hlrName) {
        this.hlrName = hlrName;
    }

    public void setNiSpc(String n)
    {
        this.niSpc=n;
    }

    public String getNiSpc()
    {
        return  this.niSpc;
    }

    public void setGt(String g)
    {
        this.Gt=g;
    }

    public String getGt()
    {
        return  this.Gt;
    }

    public void setStartRange(long s)
    {
        this.startRange=s;
    }

    public long getStartRange()
    {
        return  this.startRange;
    }

    public void setendRange(long e)
    {
        this.endRange=e;
    }

    public long getendRange()
    {
        return  this.endRange;
    }

    public Object getMscEdge() {
        return mscEdge;
    }

    public void setMscEdge(Object mscEdge) {
        this.mscEdge = mscEdge;
    }

    public String getPropertyOne() {
        return propertyOne;
    }

    public void setPropertyOne(String propertyOne) {
        this.propertyOne = propertyOne;
    }

    public Object getVlrEdge() {
        return vlrEdge;
    }

    public void setVlrEdge(Object vlrEdge) {
        this.vlrEdge = vlrEdge;
    }

    @Override
    public String toString() {
        return getHlrName();
    }
}
