package com.iti.telecom.editor;

import com.iti.telecom.beans.HLR;
import com.iti.telecom.beans.MS;
import com.iti.telecom.beans.MSC;
import java.awt.BorderLayout;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;
import java.io.File;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenuBar;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTabbedPane;
import javax.swing.JToolBar;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

import com.mxgraph.layout.mxCircleLayout;
import com.mxgraph.layout.mxCompactTreeLayout;
import com.mxgraph.layout.mxEdgeLabelLayout;
import com.mxgraph.layout.mxIGraphLayout;
import com.mxgraph.layout.mxOrganicLayout;
import com.mxgraph.layout.mxParallelEdgeLayout;
import com.mxgraph.layout.mxPartitionLayout;
import com.mxgraph.layout.mxStackLayout;
import com.mxgraph.layout.hierarchical.mxHierarchicalLayout;
import com.mxgraph.model.mxCell;
import com.mxgraph.model.mxIGraphModel;
import com.mxgraph.swing.mxGraphComponent;
import com.mxgraph.swing.mxGraphOutline;
import com.mxgraph.swing.handler.mxKeyboardHandler;
import com.mxgraph.swing.handler.mxRubberband;
import com.mxgraph.swing.util.mxMorphing;
import com.mxgraph.util.mxEvent;
import com.mxgraph.util.mxEventObject;
import com.mxgraph.util.mxRectangle;
import com.mxgraph.util.mxResources;
import com.mxgraph.util.mxUndoManager;
import com.mxgraph.util.mxUndoableEdit;
import com.mxgraph.util.mxEventSource.mxIEventListener;
import com.mxgraph.util.mxUndoableEdit.mxUndoableChange;
import com.mxgraph.view.mxGraph;
import java.awt.*;
import java.awt.event.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import javax.swing.*;

public class BasicGraphEditor extends JPanel {

    static {
        try {
            mxResources.add("com/iti/telecom/resources/editor");
        } catch (Exception e) {
            // ignore
        }
    }

    public static void logMsg(String msg) {
        //SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yy-MM-dd   kk-mm-ss");
        logedArea.append(" >> "+msg +"\n" );
    }
    /**
     * extends JScrollPane implements Printable
     * graphComponent.getViewport().setOpaque(true);
     * graphComponent.getViewport().setBackground(newColor);
     */
    protected mxGraphComponent graphComponent;
    public static   JTextArea logedArea ;
    protected JTabbedPane libraryPane;
    protected mxUndoManager undoManager;
    protected String appTitle;
    protected JLabel statusBar;
    protected File currentFile;
    protected boolean modified = false;
    protected mxRubberband rubberband;
    protected mxKeyboardHandler keyboardHandler;
    public static JFrame mainFrame = null;
    protected mxIEventListener undoHandler = new mxIEventListener() {

        public void invoke(Object source, mxEventObject evt) {
            undoManager.undoableEditHappened((mxUndoableEdit) evt.getProperty("edit"));
        }
    };
    protected mxIEventListener changeTracker = new mxIEventListener() {

        public void invoke(Object source, mxEventObject evt) {
            setModified(true);
        }
    };

    public JTextArea getLogedArea() {
        return logedArea;
    }

    public void setLogedArea(JTextArea logedArea) {
        this.logedArea = logedArea;
    }

    
    public BasicGraphEditor(String appTitle, mxGraphComponent component) {
        // Stores and updates the frame title
        this.appTitle = appTitle;
        logedArea = new JTextArea(30, 40);
        logedArea.setEditable(false);
        //logedArea.setLineWrap(true);
        logedArea.setForeground(Color.GRAY);
        logedArea.setFont(new Font("TimesRoman",Font.BOLD,14));
        // Stores a reference to the graph and creates the command history
        graphComponent = component;
        /**
         * Implements a graph object that allows to create diagrams from a graph
         * model and stylesheet.
         */
        final mxGraph graph = graphComponent.getGraph();
        undoManager = createUndoManager();

        // Do not change the scale and translation after files have been loaded
        // reset Edges On Resize.
        graph.setResetViewOnRootChange(false);

        // Updates the modified flag if the graph model changes
        graph.getModel().addListener(mxEvent.CHANGE, changeTracker);

        // Adds the command history to the model and view
        graph.getModel().addListener(mxEvent.UNDO, undoHandler);
        graph.getView().addListener(mxEvent.UNDO, undoHandler);

        // Keeps the selection in sync with the command history
        mxIEventListener undoHandler = new mxIEventListener() {

            public void invoke(Object source, mxEventObject evt) {
                List<mxUndoableChange> changes = ((mxUndoableEdit) evt.getProperty("edit")).getChanges();
                graph.setSelectionCells(graph.getSelectionCellsForChanges(changes));
            }
        };

        undoManager.addListener(mxEvent.UNDO, undoHandler);
        undoManager.addListener(mxEvent.REDO, undoHandler);

        

        // Creates the library pane that contains the tabs with the palettes
        libraryPane = new JTabbedPane();
        JSplitPane inner = new JSplitPane(JSplitPane.VERTICAL_SPLIT,
                libraryPane, new JScrollPane(logedArea));
        inner.setDividerLocation(140);
        inner.setResizeWeight(1);
        inner.setDividerSize(6);
        inner.setBorder(null);

        // Creates the outer split pane that contains the inner split pane and
        // the graph component on the right side of the window
        JSplitPane outer = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, inner,
                graphComponent);
        outer.setOneTouchExpandable(true);
        outer.setDividerLocation(500);
        outer.setDividerSize(6);
        outer.setBorder(null);

        // Creates the status bar
        /**
         * @author ahmed amer status bar is label.
         */
        statusBar = createStatusBar();

        // Display some useful information about repaint events
        installRepaintListener();

        // Puts everything together
        setLayout(new BorderLayout());
        add(outer, BorderLayout.CENTER);
        add(statusBar, BorderLayout.SOUTH);
        installToolBar();
       // zoom(graph ,1);
        // Installs rubberband selection and handling for some special
        // keystrokes such as F2, Control-C, -V, X, A etc.
        installHandlers();
        installListeners();
        updateTitle();  
    }

    /**
     *
     */
    protected mxUndoManager createUndoManager() {
        return new mxUndoManager();
    }

    /**
     *
     */
    protected void installHandlers() {
        rubberband = new mxRubberband(graphComponent);
        keyboardHandler = new EditorKeyboardHandler(graphComponent);
    }

    /**
     *
     */
    protected void installToolBar() {
        add(new EditorToolBar(this, JToolBar.HORIZONTAL), BorderLayout.NORTH);
    }

    /**
     *
     */
    protected JLabel createStatusBar() {
        JLabel statusBar = new JLabel(mxResources.get("ready"));
        /**
         * put border to label to make him seems as status bar .
         */
        statusBar.setBorder(BorderFactory.createEmptyBorder(2, 4, 2, 4));

        return statusBar;
    }

    /**
     * author AHmed amer
     */
    protected void installRepaintListener() {
        graphComponent.getGraph().addListener(mxEvent.REPAINT,
                new mxIEventListener() {

                    public void invoke(Object source, mxEventObject evt) {
                        // Buffered Image  [ data Of Image ] as buffer.
                        String buffer = (graphComponent.getTripleBuffer() != null) ? ""
                                : " (unbuffered)";
                        mxRectangle dirty = (mxRectangle) evt.getProperty("region");
                        if (dirty == null) {
                            status("Repaint all" + buffer);
                        } else {
                            status("Repaint: x=" + (int) (dirty.getX()) + " y="
                                    + (int) (dirty.getY()) + " w="
                                    + (int) (dirty.getWidth()) + " h="
                                    + (int) (dirty.getHeight()) + buffer);
                        }
                    }
                });
    }

    /**
     *
     */
    public EditorPalette insertPalette(String title) {
        final EditorPalette palette = new EditorPalette();
        final JScrollPane scrollPane = new JScrollPane(palette);
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);
        scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        libraryPane.add(title, scrollPane);

        
        // Updates the widths of the palettes if the container size changes
        libraryPane.addComponentListener(new ComponentAdapter() {

            /**
             *
             */
            public void componentResized(ComponentEvent e) {
                int w = scrollPane.getWidth()
                        - scrollPane.getVerticalScrollBar().getWidth();
                palette.setPreferredWidth(w);
            }
        });

        return palette;
    }

    /**
     *
     */
    protected void mouseWheelMoved(MouseWheelEvent e) {
        if (e.getWheelRotation() < 0) {
            graphComponent.zoomIn();
        } else {
            graphComponent.zoomOut();
        }
    }    



    /**
     *
     */
    protected void showGraphPopupMenu(MouseEvent e) {
        Point pt = SwingUtilities.convertPoint(e.getComponent(), e.getPoint(),
                graphComponent);
        mxGraph graph = graphComponent.getGraph();
        mxIGraphModel model = graph.getModel();
        Object cell = graph.getSelectionCell();

        mxCell cellGraph = (mxCell) cell;
        Object resultmol = model.getValue(cell);
        if (resultmol instanceof MS) {
            MobileStationPopUp menu = new MobileStationPopUp(BasicGraphEditor.this ,(MS)resultmol);
            menu.show(graphComponent, pt.x, pt.y);
        } else {
            EditorPopupMenu menu = new EditorPopupMenu(BasicGraphEditor.this);
            menu.show(graphComponent, pt.x, pt.y);
        }

        //   System.out.println("ID : "+ graphComponent.getCellAt(pt.x, pt.y));
        e.consume();
    }

    /**
     *
     */
    protected void mouseLocationChanged(MouseEvent e) {
        status(e.getX() + ", " + e.getY());
    }

    /**
     *
     */
    protected void installListeners() {
        // Installs mouse wheel listener for zooming
        MouseWheelListener wheelTracker = new MouseWheelListener() {

            /**
             *
             */
            public void mouseWheelMoved(MouseWheelEvent e) {
                if (e.getSource() instanceof mxGraphOutline
                        || e.isControlDown()) {
                    BasicGraphEditor.this.mouseWheelMoved(e);
                }
            }
        };

        
        // Installs the popup menu in the graph component
        graphComponent.getGraphControl().addMouseListener(new MouseAdapter() {

            public void mousePressed(MouseEvent e) {
                mouseReleased(e);
                mxGraph mGraph = graphComponent.getGraph();
                Object cell = mGraph.getSelectionCell();
                mxIGraphModel model = mGraph.getModel();
                selectEdges(mGraph, cell, model);
            }

            @Override
            public void mouseReleased(MouseEvent e) {
                if (e.isPopupTrigger()) {
                    showGraphPopupMenu(e);
                }
            }
        });

        graphComponent.getGraphControl().addMouseMotionListener(
                new MouseMotionListener() {

                    public void mouseDragged(MouseEvent e) {
                        mouseLocationChanged(e);
                    }

                    public void mouseMoved(MouseEvent e) {
                        mouseDragged(e);
                    }
                });
    }

    public void selectEdges(mxGraph graph, Object cell, mxIGraphModel model) {
        Object resultmol = model.getValue(cell);

        if (cell != null) {
            mxCell comp = (mxCell) cell;
            if ((!comp.isEdge()) || resultmol instanceof MSC || resultmol instanceof HLR) {
                System.out.println(resultmol instanceof MSC ? "MSC " : resultmol instanceof HLR ? "HLR" : "Not any HLR MSC");
                Object[] outgoingEdges = graph.getOutgoingEdges(cell);
                Collection cells = new ArrayList();

                cells.add(cell);
                for (int i = 0; i < outgoingEdges.length; i++) {
                    cells.add(outgoingEdges[i]);
                }

                graph.setSelectionCells(cells.toArray());
            }
        }
    }

    /**
     *
     */
    public void setCurrentFile(File file) {
        File oldValue = currentFile;
        currentFile = file;

        firePropertyChange("currentFile", oldValue, file);

        if (oldValue != file) {
            updateTitle();
        }
    }

    /**
     *
     */
    public File getCurrentFile() {
        return currentFile;
    }

    /**
     *
     * @param modified
     */
    public void setModified(boolean modified) {
        boolean oldValue = this.modified;
        this.modified = modified;

        firePropertyChange("modified", oldValue, modified);

        if (oldValue != modified) {
            updateTitle();
        }
    }

    /**
     *
     * @return whether or not the current graph has been modified
     */
    public boolean isModified() {
        return modified;
    }

    /**
     *
     */
    public mxGraphComponent getGraphComponent() {
        return graphComponent;
    }

   
    /**
     *
     */
    public JTabbedPane getLibraryPane() {
        return libraryPane;
    }

    /**
     *
     */
    public mxUndoManager getUndoManager() {
        return undoManager;
    }

    /**
     *
     * @param name
     * @param action
     * @return a new Action bound to the specified string name
     */
    public Action bind(String name, final Action action) {
        return bind(name, action, null);
    }

    /**
     *
     * @param name
     * @param action
     * @return a new Action bound to the specified string name and icon
     */
    @SuppressWarnings("serial")
    public Action bind(String name, final Action action, String iconUrl) {
        return new AbstractAction(name, (iconUrl != null) ? new ImageIcon(
                BasicGraphEditor.class.getResource(iconUrl)) : null) {

            public void actionPerformed(ActionEvent e) {
                action.actionPerformed(new ActionEvent(getGraphComponent(), e.getID(), e.getActionCommand()));
            }
        };
    }

    /**
     *
     * @param msg
     */
    public void status(String msg) {
        statusBar.setText(msg);
    }

    /**
     *
     */
    public void updateTitle() {
        JFrame frame = (JFrame) SwingUtilities.windowForComponent(this);
        if (frame != null) {
            String title = (currentFile != null) ? currentFile.getAbsolutePath() : mxResources.get("newDiagram");
            if (modified) {
                title += "*";
            }
            frame.setTitle(title + " - " + appTitle);
        }
    }

    public void about() {
        JFrame frame = (JFrame) SwingUtilities.windowForComponent(this);
        if (frame != null) {
            EditorAboutFrame about = new EditorAboutFrame(frame);
            about.setModal(true);

            // Centers inside the application frame
            int x = frame.getX() + (frame.getWidth() - about.getWidth()) / 2;
            int y = frame.getY() + (frame.getHeight() - about.getHeight()) / 2;
            about.setLocation(x, y);

            // Shows the modal dialog and waits
            about.setVisible(true);
        }
    }

    /**
     *
     */
    public void exit() {
        JFrame frame = (JFrame) SwingUtilities.windowForComponent(this);
       // JOptionPane.showMessageDialog(this, "closinngggggg");
        if (frame != null) {
            //JOptionPane.showMessageDialog(this, "closinngggggg");
            //System.out.println("closinngggg");
            frame.dispose();
        }
    }

    /**
     *
     */
    public void setLookAndFeel(String clazz) {
        JFrame frame = (JFrame) SwingUtilities.windowForComponent(this);

        if (frame != null) {
            try {
                UIManager.setLookAndFeel(clazz);
                SwingUtilities.updateComponentTreeUI(frame);

                // Needs to assign the key bindings again
                keyboardHandler = new EditorKeyboardHandler(graphComponent);
            } catch (Exception e1) {
                e1.printStackTrace();
            }
        }
    }

    /**
     *
     */
    public JFrame createFrame(JMenuBar menuBar) {
        JFrame frame = new JFrame();
        frame.getContentPane().add(this);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JMenu menu = new JMenu("Themes");
        JMenuItem graphite = new JMenuItem("Graphite");
        JMenuItem aero = new JMenuItem("Aero");
        JMenuItem mac = new JMenuItem("Mac");
        menu.add(mac);
        menu.add(aero);
        menu.add(graphite);
        menuBar.add(menu);
        frame.setJMenuBar(menuBar);
        aero.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
              AeroactionPerformed(e);
            }
        });
        mac.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
              MacactionPerformed(e);
            }
        });
        graphite.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
              GraphiteactionPerformed(e);
            }
        });
        frame.setSize(870, 640);
        frame.addWindowListener(new WindowAdapter(){
         public void windowClosing(WindowEvent we){
             System.out.println("Deleting DB");
             // ms_app.DatabaseHandler.deleteDB_HLR();
             // ms_app.DatabaseHandler.deleteDB_MSC();
            }
         });
        GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        Rectangle maximumWindowBounds = ge.getMaximumWindowBounds();
        frame.setSize(maximumWindowBounds.getSize());
        // Updates the frame title
        updateTitle();

        return frame;
    }

    /**
     * Creates an action that executes the specified layout.
     *
     * @param key Key to be used for getting the label from mxResources and also
     * to create the layout instance for the commercial graph editor example.
     * @return an action that executes the specified layout
     */
    @SuppressWarnings("serial")
    public Action graphLayout(final String key, boolean animate) {
        final mxIGraphLayout layout = createLayout(key, animate);

        if (layout != null) {
            return new AbstractAction(mxResources.get(key)) {

                public void actionPerformed(ActionEvent e) {
                    final mxGraph graph = graphComponent.getGraph();
                    Object cell = graph.getSelectionCell();

                    if (cell == null
                            || graph.getModel().getChildCount(cell) == 0) {
                        cell = graph.getDefaultParent();
                    }

                    graph.getModel().beginUpdate();
                    try {
                        long t0 = System.currentTimeMillis();
                        layout.execute(cell);
                        status("Layout: " + (System.currentTimeMillis() - t0)
                                + " ms");
                    } finally {
                        mxMorphing morph = new mxMorphing(graphComponent, 20,
                                1.2, 20);

                        morph.addListener(mxEvent.DONE, new mxIEventListener() {

                            public void invoke(Object sender, mxEventObject evt) {
                                graph.getModel().endUpdate();
                            }
                        });

                        morph.startAnimation();
                    }

                }
            };
        } else {
            return new AbstractAction(mxResources.get(key)) {

                public void actionPerformed(ActionEvent e) {
                    JOptionPane.showMessageDialog(graphComponent,
                            mxResources.get("noLayout"));
                }
            };
        }
    }

    /**
     * Creates a layout instance for the given identifier.
     */
    protected mxIGraphLayout createLayout(String ident, boolean animate) {
        mxIGraphLayout layout = null;
        
        if (ident != null) {
            mxGraph graph = graphComponent.getGraph();

            if (ident.equals("verticalHierarchical")) {
                layout = new mxHierarchicalLayout(graph);
            } else if (ident.equals("horizontalHierarchical")) {
                layout = new mxHierarchicalLayout(graph, JLabel.WEST);
            } else if (ident.equals("verticalTree")) {
                layout = new mxCompactTreeLayout(graph, false);
            } else if (ident.equals("horizontalTree")) {
                layout = new mxCompactTreeLayout(graph, true);
            } else if (ident.equals("parallelEdges")) {
                layout = new mxParallelEdgeLayout(graph);
            } else if (ident.equals("placeEdgeLabels")) {
                layout = new mxEdgeLabelLayout(graph);
            } else if (ident.equals("organicLayout")) {
                layout = new mxOrganicLayout(graph);
            }
            if (ident.equals("verticalPartition")) {
                layout = new mxPartitionLayout(graph, false) {

                    /**
                     * Overrides the empty implementation to return the size of
                     * the graph control.
                     */
                    public mxRectangle getContainerSize() {
                        return graphComponent.getLayoutAreaSize();
                    }
                };
            } else if (ident.equals("horizontalPartition")) {
                layout = new mxPartitionLayout(graph, true) {

                    /**
                     * Overrides the empty implementation to return the size of
                     * the graph control.
                     */
                    public mxRectangle getContainerSize() {
                        return graphComponent.getLayoutAreaSize();
                    }
                };
            } else if (ident.equals("verticalStack")) {
                layout = new mxStackLayout(graph, false) {

                    /**
                     * Overrides the empty implementation to return the size of
                     * the graph control.
                     */
                    public mxRectangle getContainerSize() {
                        return graphComponent.getLayoutAreaSize();
                    }
                };
            } else if (ident.equals("horizontalStack")) {
                layout = new mxStackLayout(graph, true) {

                    /**
                     * Overrides the empty implementation to return the size of
                     * the graph control.
                     */
                    public mxRectangle getContainerSize() {
                        return graphComponent.getLayoutAreaSize();
                    }
                };
            } else if (ident.equals("circleLayout")) {
                layout = new mxCircleLayout(graph);
            }
        }

        return layout;
    }

    private void zoom(mxGraph graph , double scale) {
         graphComponent.getGraph().getView().scaleAndTranslate(scale,
              (graph.getGraphBounds().getCenterX()
              -(graph.getGraphBounds().getWidth()/2))/scale,
              (graph.getGraphBounds().getCenterY()
             -(graph.getGraphBounds().getHeight()/2))/scale);
    }

//    class AeroListener implements ActionListener
//	{
		public void AeroactionPerformed(ActionEvent ae)
		{
            try {
                //com.iti.telecom.main.GraphEditor.theme="com.jtattoo.plaf.aero.AeroLookAndFeel";
                UIManager.setLookAndFeel("com.jtattoo.plaf.aero.AeroLookAndFeel");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (InstantiationException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalAccessException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedLookAndFeelException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            }

                SwingUtilities.updateComponentTreeUI(this);
	}


                public void MacactionPerformed(ActionEvent ae)
		{
            try {
                //com.iti.telecom.main.GraphEditor.theme="com.jtattoo.plaf.aero.AeroLookAndFeel";
                UIManager.setLookAndFeel("com.jtattoo.plaf.mcwin.McWinLookAndFeel");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (InstantiationException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalAccessException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedLookAndFeelException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            }

                SwingUtilities.updateComponentTreeUI(this);
	}


                public void GraphiteactionPerformed(ActionEvent ae)
		{
            try {
                //com.iti.telecom.main.GraphEditor.theme="com.jtattoo.plaf.aero.AeroLookAndFeel";
                UIManager.setLookAndFeel("com.jtattoo.plaf.graphite.GraphiteLookAndFeel");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (InstantiationException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IllegalAccessException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            } catch (UnsupportedLookAndFeelException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            }

                SwingUtilities.updateComponentTreeUI(this);
	}
}
