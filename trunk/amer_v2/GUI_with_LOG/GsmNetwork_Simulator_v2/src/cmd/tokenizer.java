/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package cmd;

import java.util.ArrayList;

/**
 *
 * @author mahmoud
 */
public class tokenizer {
    String input;
    ArrayList<String> tokens;

    public tokenizer() {
    }
    ArrayList<String> generateTokens(String t)
    {
        
        String[] splitted=t.split(" ");
        for(int i=0;i<splitted.length;i++)
        System.out.println(splitted[i]);
        return tokens;
    }
}
