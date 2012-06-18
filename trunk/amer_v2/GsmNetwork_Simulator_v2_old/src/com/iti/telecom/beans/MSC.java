/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iti.telecom.beans;

import java.io.Serializable;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 *
 * @author ahmed_amering
 */
public class MSC implements Serializable {

    private String mscName = "MSC";
    private String ni;
    String spc;
    String gt1,gt2,gt3;
    String vlrAdd1,vlrAdd2,vlrAdd3;
    String la1,la2,la3;
    private String action = null;
    private Object hlrEdge;
    private Object msEdge;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Object getHlrEdge() {
        return hlrEdge;
    }

    public void setHlrEdge(Object hlrEdge) {
        this.hlrEdge = hlrEdge;
    }

    public Object getMsEdge() {
        return msEdge;
    }

    public void setMsEdge(Object msEdge) {
        this.msEdge = msEdge;
    }

    public String getMscName() {
        return mscName;
    }

    public void setMscName(String mscName) {
        this.mscName = mscName;
    }

    @Override
    public String toString() {
        return getMscName();
    }



    public void setGt1(String gt1) {
        this.gt1 = gt1;
    }

    public void setGt2(String gt2) {
        this.gt2 = gt2;
    }

    public void setGt3(String gt3) {
        this.gt3 = gt3;
    }

    public void setLa3(String la3) {
        this.la3 = la3;
    }

    public void setLa1(String la1) {
        this.la1 = la1;
    }

    public void setLa2(String la2) {
        this.la2 = la2;
    }

    public void setNi(String ni) {
        this.ni = ni;
    }

    public void setSpc(String spc) {
        this.spc = spc;
    }

    public void setVlrAdd1(String vlrAdd1) {
        this.vlrAdd1 = vlrAdd1;
    }

    public void setVlrAdd2(String vlrAdd2) {
        this.vlrAdd2 = vlrAdd2;
    }

    public void setVlrAdd3(String vlrAdd3) {
        this.vlrAdd3 = vlrAdd3;
    }

    public String getGt1() {
        return gt1;
    }

    public String getGt2() {
        return gt2;
    }

    public String getGt3() {
        return gt3;
    }

    public String getLa3() {
        return la3;
    }

    public String getLa1() {
        return la1;
    }

    public String getLa2() {
        return la2;
    }

    public String getNi() {
        return ni;
    }

    public String getSpc() {
        return spc;
    }

    public String getVlrAdd1() {
        return vlrAdd1;
    }

    public String getVlrAdd2() {
        return vlrAdd2;
    }

    public String getVlrAdd3() {
        return vlrAdd3;
    }

}
