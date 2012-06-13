/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package msc;

import java.util.Properties;
import javax.swing.UIManager;

/**
 *
 * @author Vendetta
 */
public class Main {

    
    public static void main(String[] args) {

        try {

             Properties props = new Properties();
            props.put("logoString", "my company");
//            props.put("logoString", "\u00A0");
            props.put("backgroundPattern", "off");

            props.put("windowTitleForegroundColor", "228 228 255");
            props.put("windowTitleBackgroundColor", "0 0 96");
            props.put("windowTitleColorLight", "0 0 96");
            props.put("windowTitleColorDark", "0 0 64");
            props.put("windowBorderColor", "96 96 64");

            props.put("windowInactiveTitleForegroundColor", "228 228 255");
            props.put("windowInactiveTitleBackgroundColor", "0 0 96");
            props.put("windowInactiveTitleColorLight", "0 0 96");
            props.put("windowInactiveTitleColorDark", "0 0 64");
            props.put("windowInactiveBorderColor", "32 32 128");

            props.put("menuForegroundColor", "228 228 255");
            props.put("menuBackgroundColor", "0 0 64");
            props.put("menuSelectionForegroundColor", "0 0 0");
            props.put("menuSelectionBackgroundColor", "255 192 48");
            props.put("menuColorLight", "32 32 128");
            props.put("menuColorDark", "16 16 96");

            props.put("toolbarColorLight", "32 32 128");
            props.put("toolbarColorDark", "16 16 96");

            props.put("controlForegroundColor", "228 228 255");
            props.put("controlBackgroundColor", "16 16 96");
            props.put("controlColorLight", "16 16 96");
            props.put("controlColorDark", "8 8 64");
            props.put("controlHighlightColor", "32 32 128");
            props.put("controlShadowColor", "16 16 64");
            props.put("controlDarkShadowColor", "8 8 32");

            props.put("buttonForegroundColor", "0 0 32");
            props.put("buttonBackgroundColor", "196 196 196");
            props.put("buttonColorLight", "196 196 240");
            props.put("buttonColorDark", "164 164 228");

            props.put("foregroundColor", "228 228 255");
            props.put("backgroundColor", "0 0 64");
            props.put("backgroundColorLight", "16 16 96");
            props.put("backgroundColorDark", "8 8 64");
            props.put("alterBackgroundColor", "255 0 0");
            props.put("frameColor", "96 96 64");
            props.put("gridColor", "96 96 64");
            props.put("focusCellColor", "240 0 0");

            props.put("disabledForegroundColor", "128 128 164");
            props.put("disabledBackgroundColor", "0 0 72");

            props.put("selectionForegroundColor", "0 0 0");
            props.put("selectionBackgroundColor", "196 148 16");

            props.put("inputForegroundColor", "228 228 255");
            props.put("inputBackgroundColor", "0 0 96");

            props.put("rolloverColor", "240 168 0");
            props.put("rolloverColorLight", "240 168 0");
            props.put("rolloverColorDark", "196 137 0");

            // set your theme
            com.jtattoo.plaf.hifi.HiFiLookAndFeel.setCurrentTheme(props);
            // select the Look and Feel
            UIManager.setLookAndFeel("com.jtattoo.plaf.mcwin.McWinLookAndFeel");

            } catch (Exception e) { }

        Msc_Screen screen = new Msc_Screen();
        screen.setSize(600, 400);
        screen.setVisible(true);
        // TODO code application logic here
    }
}
