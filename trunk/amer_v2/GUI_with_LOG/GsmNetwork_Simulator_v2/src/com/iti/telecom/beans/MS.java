/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iti.telecom.beans;


import java.io.Serializable;
import java.util.Locale;
import java.util.ResourceBundle;
import ms_app.ms_form;

/**
 *
 * @author ahmed_amer
 */
public class MS implements Serializable {
    
    private String msNumber = "MS";
    private String action = null;
    private String msIMSI = "";
    private boolean switchedOn= false ;
    private boolean switchedOff= false ;
    private boolean call = false;
    public  ms_form  formObject ;
    /**
     * @Marwa @somaya this  Your Fields in [ ms_form ]
     */
    private String simsi1;
    private String simsi2;
    private String simsi3;
    private String smsisdn1;
    private String smsisdn2;
    private String smsisdn3;
    private String slai1;
    private String slai2;
    private String slai3;
    
    boolean aftersubmit =true;
    boolean norluenable =false; 

    
    private Object msMakeCall;
    private Object msLocationUpdate;

    public void setCall(boolean call) {
        this.call = call;
    }

    public boolean isCall() {
        return call;
    }

    
    public void setSwitchedOff(boolean switchedOff) {
        this.switchedOff = switchedOff;
    }

    public boolean isSwitchedOff() {
        return switchedOff;
    }

    public ms_form getFormObject() {
        return formObject;
    }

    public void setFormObject(ms_form formObject) {
        this.formObject = formObject;
    }

    
    
    public boolean isAftersubmit() {
        return aftersubmit;
    }

    public void setAftersubmit(boolean aftersubmit) {
        this.aftersubmit = aftersubmit;
    }

    public boolean isNorluenable() {
        return norluenable;
    }

    public void setNorluenable(boolean norluenable) {
        this.norluenable = norluenable;
    }

    public boolean isSwitchedOn() {
        return switchedOn;
    }

    public void setSwitchedOn(boolean switchedOn) {
        this.switchedOn = switchedOn;
    }

    
    @Override
    public String toString() {
        return this.getMsNumber();
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getMsIMSI() {
        return msIMSI;
    }

    public void setMsIMSI(String msIMSI) {
        this.msIMSI = msIMSI;
    }

    public Object getMsLocationUpdate() {
        return msLocationUpdate;
    }

    public void setMsLocationUpdate(Object msLocationUpdate) {
        this.msLocationUpdate = msLocationUpdate;
    }

    public Object getMsMakeCall() {
        return msMakeCall;
    }

    public void setMsMakeCall(Object msMakeCall) {
        this.msMakeCall = msMakeCall;
    }

    public String getMsNumber() {
        return msNumber;
    }

    public void setMsNumber(String msNumber) {
        this.msNumber = msNumber;
    }

    public String getSimsi1() {
        return simsi1;
    }

    public void setSimsi1(String simsi1) {
        this.simsi1 = simsi1;
    }

    public String getSimsi2() {
        return simsi2;
    }

    public void setSimsi2(String simsi2) {
        this.simsi2 = simsi2;
    }

    public String getSimsi3() {
        return simsi3;
    }

    public void setSimsi3(String simsi3) {
        this.simsi3 = simsi3;
    }

    public String getSlai1() {
        return slai1;
    }

    public void setSlai1(String slai1) {
        this.slai1 = slai1;
    }

    public String getSlai2() {
        return slai2;
    }

    public void setSlai2(String slai2) {
        this.slai2 = slai2;
    }

    public String getSlai3() {
        return slai3;
    }

    public void setSlai3(String slai3) {
        this.slai3 = slai3;
    }

    public String getSmsisdn1() {
        return smsisdn1;
    }

    public void setSmsisdn1(String smsisdn1) {
        this.smsisdn1 = smsisdn1;
    }

    public String getSmsisdn2() {
        return smsisdn2;
    }

    public void setSmsisdn2(String smsisdn2) {
        this.smsisdn2 = smsisdn2;
    }

    public String getSmsisdn3() {
        return smsisdn3;
    }

    public void setSmsisdn3(String smsisdn3) {
        this.smsisdn3 = smsisdn3;
    }
    
    public void setaftersubmit(boolean b) {
        this.aftersubmit = b;
    }
    public boolean getaftersubmit() {
        return this.aftersubmit;
    }
    
    
    public void setnormallu(boolean b) {
        this.norluenable = b;
    }
    public boolean getnormallu() {
        return this.norluenable;
    }
    

    @Override
    protected Object clone() throws CloneNotSupportedException {
        MS mobileStation = new MS();
        mobileStation.setAction(getAction());
        mobileStation.setMsIMSI(getMsIMSI());
        mobileStation.setMsNumber(getMsNumber());
        mobileStation.setMsLocationUpdate(null);
        mobileStation.setMsMakeCall(null);
        return mobileStation;
    }
}
