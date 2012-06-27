package com.iti.telecom.editor;

import com.iti.telecom.beans.MS;
import javax.swing.JPopupMenu;
import javax.swing.TransferHandler;

import com.iti.telecom.editor.EditorActions.HistoryAction;
import com.mxgraph.model.mxGraphModel;
import com.mxgraph.swing.mxGraphComponent;
import com.mxgraph.util.mxResources;
import com.mxgraph.view.mxGraphView;
import javax.swing.KeyStroke;

public class MobileStationPopUp extends JPopupMenu
{

    public  mxGraphComponent graphComponent;
	public MobileStationPopUp(BasicGraphEditor editor , MS msObject)
	{
		boolean selected = !editor.getGraphComponent().getGraph().isSelectionEmpty();
                graphComponent = editor.getGraphComponent();
                mxGraphModel graphModel =  (mxGraphModel) graphComponent.getGraph().getModel();
                mxGraphView view;

		add(editor.bind(mxResources.get("undo"), new HistoryAction(true),
				"/com/iti/telecom/images/undo.gif"));
		addSeparator();

		    add(editor.bind(mxResources.get("delete"), new EditorActions.DeleteAction(),
                       "/com/iti/telecom/images/cut.gif")).setEnabled(selected);
		add(editor.bind(mxResources.get("copy"), TransferHandler
						.getCopyAction(),
						"/com/iti/telecom/images/copy.gif"))
				.setEnabled(selected);
		add(editor.bind(mxResources.get("paste"), TransferHandler
				.getPasteAction(),
				"/com/iti/telecom/images/paste.gif"));
                addSeparator();
               add(editor.bind(mxResources.get("switchedOn"), new EditorActions.SwitchON(),
				"/com/iti/telecom/images/on.png")).setEnabled(msObject.isSwitchedOn());
		addSeparator();
                add(editor.bind(mxResources.get("switchedOff"), new EditorActions.SwitchOFF()
				,
				"/com/iti/telecom/images/off.png")).setEnabled(msObject.isSwitchedOff());
		addSeparator();
		
                add(editor.bind(mxResources.get("properties"),
                        new EditorActions.PropertiesAction(),"/com/iti/telecom/images/conf.png")).setAccelerator(KeyStroke.getKeyStroke(80, 2));
                addSeparator();
		
                add(editor.bind(mxResources.get("Call"),
                        new EditorActions.MakeCall(),"/com/iti/telecom/images/call.png")).setEnabled(msObject.isCall());
                addSeparator();
		
               // add(editor.bind(mxResources.get("add"),
                 //       new EditorActions.AddFriends(),"/com/iti/telecom/images/call.png")).setEnabled(msObject.isSwitchedOn());
        
        }
}
