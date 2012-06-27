package com.iti.telecom.main;

/**
 * $Id: GraphEditor.java,v 1.11 2012-01-13 12:51:15 david Exp $
 * Copyright (c) 2006-2012, JGraph Ltd */


import com.iti.telecom.beans.HLR;
import com.iti.telecom.beans.MS;
import com.iti.telecom.beans.MSC;
import java.awt.Color;
import java.awt.Point;
import java.net.URL;
import java.text.NumberFormat;
import java.util.Iterator;
import java.util.List;

import javax.swing.ImageIcon;
import javax.swing.UIManager;

import org.w3c.dom.Document;

import com.iti.telecom.editor.BasicGraphEditor;
import com.iti.telecom.editor.EditorMenuBar;
import com.iti.telecom.editor.EditorPalette;
import com.mxgraph.io.mxCodec;
import com.mxgraph.io.mxCodecRegistry;
import com.mxgraph.io.mxObjectCodec;
import com.mxgraph.model.mxCell;
import com.mxgraph.model.mxGeometry;
import com.mxgraph.model.mxICell;
import com.mxgraph.model.mxIGraphModel;
import com.mxgraph.swing.mxGraphComponent;
import com.mxgraph.swing.util.mxSwingConstants;
import com.mxgraph.util.mxConstants;
import com.mxgraph.util.mxPoint;
import com.mxgraph.util.mxResources;
import com.mxgraph.util.mxUtils;
import com.mxgraph.view.mxCellState;
import com.mxgraph.view.mxGraph;
import java.util.Properties;
import send_to_erl.Java_Receiver;

public class GraphEditor extends BasicGraphEditor
{
        public static String description = "GSM  Network";
	public static final NumberFormat numberFormat = NumberFormat.getInstance();
	static public send_to_erl.sendtoerl2 sender;
        //public static String theme = "com.jtattoo.plaf.mcwin.McWinLookAndFeel";
       
      //  static public send_to_erl.Java_Receiver receiver;
        /**
	 * Holds the URL for the icon to be used as a handle for creating new
	 * connections. This is currently unused.
	 */
	public static URL url = null;
        
	//GraphEditor.class.getResource("/com/iti/telecom/images/connector.gif");

	public GraphEditor() throws Exception
	{
		this("mxGraph Editor", new CustomGraphComponent(new CustomGraph()));
	}

	/**
	 * 
	 */
	public GraphEditor(String appTitle, mxGraphComponent component) throws Exception
	{
		super(appTitle, component);
                
                new Java_Receiver();
                sender = new send_to_erl.sendtoerl2();
                
		final mxGraph graph = this.graphComponent.getGraph();            
                graph.setCellsResizable(false);
                graph.setCellsEditable(false);
                mxConstants.DEFAULT_HOTSPOT=3.0D;
                mxCodecRegistry.addPackage("com.iti.telecom.beans");
                mxCodecRegistry.register(new mxObjectCodec(new MS()));
                mxCodecRegistry.register(new mxObjectCodec(new HLR()));
                mxCodecRegistry.register(new mxObjectCodec(new MSC()));

                MS mobileStation = new MS();
                mobileStation.setAction("1");
                HLR hlr = new HLR();
                hlr.setAction("2");
                MSC msc=new MSC();
                msc.setAction("3");




		EditorPalette imagesPalette = insertPalette(mxResources.get("images"));
		imagesPalette
				.addTemplate(
						"MSC",
						new ImageIcon(
								GraphEditor.class
										.getResource("/com/iti/telecom/images/package.png")),
						"image;image=/com/iti/telecom/images/package.png",
						100, 100, msc);

		imagesPalette
				.addTemplate(
						"HLR",
						new ImageIcon(
								GraphEditor.class
										.getResource("/com/iti/telecom/images/server.png")),
						"image;image=/com/iti/telecom/images/server.png",
						100, 100, hlr);
		imagesPalette
				.addTemplate(
						"MS",
						new ImageIcon(
								GraphEditor.class
										.getResource("/com/iti/telecom/images/mobile_phone.png")),
						"image;image=/com/iti/telecom/images/mobile_phone.png",
						100, 100, mobileStation);
	}

	/**
	* 
	*/
	public static class CustomGraphComponent extends mxGraphComponent
	{
		/**
		 * 
		 * @param graph
		 */
		public CustomGraphComponent(mxGraph graph)
		{
			super(graph);

			// Sets switches typically used in an editor
			setPageVisible(true);
			setGridVisible(true);
			setToolTips(true);
			getConnectionHandler().setCreateTarget(true);

			// Loads the defalt stylesheet from an external file
			mxCodec codec = new mxCodec();
			Document doc = mxUtils.loadDocument(GraphEditor.class.getResource(
			"/com/iti/telecom/resources/default-style.xml").toString());
                        // graph StyleSheet Holds style sheet OF  Cells
			codec.decode(doc.getDocumentElement(), graph.getStylesheet());
			// Sets the background to white
			getViewport().setOpaque(false);
			getViewport().setBackground(Color.WHITE);
                        /**
                         * I wana  to put inial Menus
                         */

		}

		/**
		 * Overrides drop behaviour to set the cell style if the target
		 * is not a valid drop target and the cells are of the same
		 * type (eg. both vertices or both edges). 
		 */
        @Override
		public Object[] importCells(Object[] cells, double dx, double dy,
				Object target, Point location)
		{
			if (target == null && cells.length == 1 && location != null)
			{
				target = getCellAt(location.x, location.y);

				if (target instanceof mxICell && cells[0] instanceof mxICell)
				{
					mxICell targetCell = (mxICell) target;
					mxICell dropCell = (mxICell) cells[0];

					if (targetCell.isVertex() == dropCell.isVertex()
							|| targetCell.isEdge() == dropCell.isEdge())
					{
						mxIGraphModel model = graph.getModel();
						model.setStyle(target, model.getStyle(cells[0]));
						graph.setSelectionCell(target);

						return null;
					}
				}
			}

			return super.importCells(cells, dx, dy, target, location);
		}

	}

	/**
	 * A graph that creates new edges from a given template edge.
	 */
	public static class CustomGraph extends mxGraph
	{
		/**
		 * Holds the edge to be used as a template for inserting new edges.
		 */
		protected Object edgeTemplate;
		/**
		 * Custom graph that defines the alternate edge style to be used when
		 * the middle control point of edges is double clicked (flipped).
		 */
		public CustomGraph()
		{
			setAlternateEdgeStyle("edgeStyle=mxEdgeStyle.ElbowConnector;elbow=vertical");
		}
		/**
		 * Sets the edge template to be used to inserting edges.
		 */
		public void setEdgeTemplate(Object template)
		{
			edgeTemplate = template;
		}

		/**
		 * Prints out some useful information about the cell in the tooltip.
		 */
		public String getToolTipForCell(Object cell)
		{
			String tip = "<html>";
			mxGeometry geo = getModel().getGeometry(cell);
			mxCellState state = getView().getState(cell);

			if (getModel().isEdge(cell))
			{
				tip += "points={";

				if (geo != null)
				{
					List<mxPoint> points = geo.getPoints();

					if (points != null)
					{
						Iterator<mxPoint> it = points.iterator();

						while (it.hasNext())
						{
							mxPoint point = it.next();
							tip += "[x=" + numberFormat.format(point.getX())
									+ ",y=" + numberFormat.format(point.getY())
									+ "],";
						}

						tip = tip.substring(0, tip.length() - 1);
					}
				}

				tip += "}<br>";
				tip += "absPoints={";

				if (state != null)
				{

					for (int i = 0; i < state.getAbsolutePointCount(); i++)
					{
						mxPoint point = state.getAbsolutePoint(i);
						tip += "[x=" + numberFormat.format(point.getX())
								+ ",y=" + numberFormat.format(point.getY())
								+ "],";
					}

					tip = tip.substring(0, tip.length() - 1);
				}

				tip += "}";
			}
			else
			{
				tip += "geo=[";

				if (geo != null)
				{
					tip += "x=" + numberFormat.format(geo.getX()) + ",y="
							+ numberFormat.format(geo.getY()) + ",width="
							+ numberFormat.format(geo.getWidth()) + ",height="
							+ numberFormat.format(geo.getHeight());
				}
				tip += "]<br>";
				tip += "state=[";

				if (state != null)
				{
					tip += "x=" + numberFormat.format(state.getX()) + ",y="
							+ numberFormat.format(state.getY()) + ",width="
							+ numberFormat.format(state.getWidth())
							+ ",height="
							+ numberFormat.format(state.getHeight());
				}
				tip += "]";
			}
			mxPoint trans = getView().getTranslate();

			tip += "<br>scale=" + numberFormat.format(getView().getScale())
					+ ", translate=[x=" + numberFormat.format(trans.getX())
					+ ",y=" + numberFormat.format(trans.getY()) + "]";
			tip += "</html>";

			return tip;
		}

		/**
		 * Overrides the method to use the currently selected edge template for
		 * new edges.
		 * 
		 * @param graph
		 * @param parent
		 * @param id
		 * @param value
		 * @param source
		 * @param target
		 * @param style
		 * @return
		 */
		public Object createEdge(Object parent, String id, Object value,
				Object source, Object target, String style)
		{
			if (edgeTemplate != null)
			{
				mxCell edge = (mxCell) cloneCells(new Object[] { edgeTemplate })[0];
				edge.setId(id);
                              
				return edge;
			}
                            // BasicGraphEditor.logMsg("Create Edge   ID : "+id);
			return super.createEdge(parent, id, value, source, target, style);
		}

	}

	/**
	 * 
	 * @param args
	 */
	public static void main(String[] args) throws Exception
	{
//		try
//		{
//			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
//		}
//		catch (Exception e1)
//		{
//			e1.printStackTrace();
//		}
//		mxSwingConstants.SHADOW_COLOR = Color.LIGHT_GRAY;
//
//		mxConstants.W3C_SHADOWCOLOR = "#D3D3D3";
            
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
            UIManager.setLookAndFeel("com.jtattoo.plaf.fast.FastLookAndFeel");

            //SwingUtilities.updateComponentTreeUI(Component parent);

            } catch (Exception e) { }

		
		GraphEditor editor = new GraphEditor();
		mainFrame =editor.createFrame(new EditorMenuBar(editor));
                mainFrame.setVisible(true);
                //sender = new send_to_erl.sendtoerl2();
                //receiver = new msc.Java_Receiver();
	}
}
