package com.iti.telecom.editor;

import cmd.CommandParser;
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

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenuBar;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
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
import java.util.ArrayList;
import java.util.Collection;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.*;
import javax.swing.text.BadLocationException;
import javax.swing.text.DefaultCaret;

/**
 *
 * @author amer
 */
public class BasicGraphEditor extends JPanel{

    
    /*command part*/
        cmd.CommandParser parser;
        int cmdStart, cmdEnd, promptCount, commandCount = 0, count = 0;
        Vector commands;
        String prompt, line;
        /*command part*/
        
        
        
    static {
        try {
            mxResources.add("com/iti/telecom/resources/editor");
        } catch (Exception e) {
            // ignore
        }
    }

    public static void logMsg(String msg) {
        //SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yy-MM-dd   kk-mm-ss");
        logedArea.append(" >> " + msg + "\n");
    }
    /**
     * Main GUI Component
     */
    protected mxGraphComponent graphComponent;
    /**
     * Used For Logging New Actions.
     */
    public static JTextArea logedArea;
    public static JTextArea commandTextArea;
    /**
     * left Upperd Tabbed pane Contain Components that draged
     */
    protected JTabbedPane libraryPane;
    protected JTabbedPane loggingTabedPane;
    /**
     * Manage Undo Actions [ctrl+z]
     */
    protected mxUndoManager undoManager;
    protected String appTitle;
    protected JLabel statusBar;
    protected File currentFile;
    protected boolean modified = false;
    protected mxRubberband rubberband;
    /**
     * Handle all KeyBoard Actions like ("control S"), "save"); ("control shift
     * S"), saveAs ("control N"), "new" ("control O"), "open" ("control Z"),
     * "undo" ("control Y"), "redo" ("control shift V"),"selectVertices"
     * ("control shift E"), "selectEdges"
     */
    protected mxKeyboardHandler keyboardHandler;
    public static JFrame mainFrame = null;
    /**
     * Undo Event Listener
     */
    protected mxIEventListener undoHandler = new mxIEventListener() {

        public void invoke(Object source, mxEventObject evt) {
            undoManager.undoableEditHappened((mxUndoableEdit) evt.getProperty("edit"));
        }
    };
    /**
     * used to flagged that change happened
     */
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

    /**
     * Setting Objects , MainFrame Size and titles
     *
     * @param appTitle
     * @param component
     */
    public BasicGraphEditor(String appTitle, mxGraphComponent component) {
        try {
            // Stores and updates the frame title
            this.appTitle = appTitle;
            logedArea = new JTextArea(30, 40);
            logedArea.setEditable(false);
            //logedArea.setLineWrap(true);
            logedArea.setForeground(Color.GRAY);
            logedArea.setFont(new Font("TimesRoman", Font.BOLD, 14));
            //********************************************************//
            commandTextArea = new JTextArea(30, 40);
            commandTextArea.setEditable(true);
            //logedArea.setLineWrap(true);
            commandTextArea.setForeground(Color.GRAY);
            commandTextArea.setFont(new Font("TimesRoman", Font.BOLD, 14));


            DefaultCaret caret = (DefaultCaret) logedArea.getCaret();
            caret.setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);
            graphComponent = component;

            final mxGraph graph = graphComponent.getGraph();
            undoManager = createUndoManager();

            graph.setResetViewOnRootChange(false);

            /**
             * Record that change Happened
             */
            graph.getModel().addListener(mxEvent.CHANGE, changeTracker);
            /**
             * add Undo Handler to model and View
             */
            graph.getModel().addListener(mxEvent.UNDO, undoHandler);
            graph.getView().addListener(mxEvent.UNDO, undoHandler);

            
            
            
            // Keeps the selection in sync with the command history
            mxIEventListener undoHandler = new mxIEventListener() {

                public void invoke(Object source, mxEventObject evt) {
                    List<mxUndoableChange> changes = ((mxUndoableEdit) evt.getProperty("edit")).getChanges();
                    graph.setSelectionCells(graph.getSelectionCellsForChanges(changes));
                }
            };
            /**
             * Enable Undo , Redo to Undo Manager
             */
            undoManager.addListener(mxEvent.UNDO, undoHandler);
            undoManager.addListener(mxEvent.REDO, undoHandler);



            /**
             * Creates the library pane that contains the tabs with the palettes
             */
            libraryPane = new JTabbedPane();
            loggingTabedPane = new JTabbedPane();

            loggingTabedPane.addTab("Logging", new JScrollPane(logedArea));
            loggingTabedPane.addTab("Command", new JScrollPane(commandTextArea));
            /**
             * Split Frame between palette and Logging area
             */
            JSplitPane inner = new JSplitPane(JSplitPane.VERTICAL_SPLIT,
                    libraryPane, loggingTabedPane);


            inner.setDividerLocation(140);
            inner.setResizeWeight(1);
            inner.setDividerSize(6);
            inner.setBorder(null);

            /**
             * Creates the outer split pane that contains the inner split pane and
             * the graph component on the right side of the window
             */
            JSplitPane outer = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, inner,
                    graphComponent);
            outer.setOneTouchExpandable(true);
            outer.setDividerLocation(500);
            outer.setDividerSize(6);
            outer.setBorder(null);


            statusBar = createStatusBar();


            // Puts everything together
            setLayout(new BorderLayout());
            add(outer, BorderLayout.CENTER);
            installToolBar();
            // zoom(graph ,1);
            // Installs rubberband selection and handling for some special
            // keystrokes such as F2, Control-C, -V, X, A etc.
            installHandlers();
            installListeners();
            updateTitle();
            
            /*command line part*/
            
            parser=new CommandParser(this);
            
                prompt = "Simulator>";
                commandTextArea.setText(prompt);
                promptCount = prompt.length();
                commands = new Vector();
                //active();
                cmdStart = commandTextArea.getLineStartOffset(commandTextArea.getLineCount() - 1) + promptCount;
                cmdEnd = commandTextArea.getLineEndOffset(commandTextArea.getLineCount() - 1);
        } catch (BadLocationException ex) {
            Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        commandTextArea.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTextArea1KeyPressed(evt);
            }
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTextArea1KeyReleased(evt);
            }
        });
    }

    /**
     * create undo manager
     */
    protected mxUndoManager createUndoManager() {
        return new mxUndoManager();
    }

    /**
     * install Handlers
     */
    protected void installHandlers() {
        rubberband = new mxRubberband(graphComponent);
        keyboardHandler = new EditorKeyboardHandler(graphComponent);
    }

    /**
     * add tool bar
     */
    protected void installToolBar() {
      //  add(new EditorToolBar(this, JToolBar.HORIZONTAL), BorderLayout.NORTH);
    }

    /**
     *
     */
    protected JLabel createStatusBar() {
        JLabel statusBar = new JLabel(mxResources.get("ready"));
        statusBar.setBorder(BorderFactory.createEmptyBorder(2, 4, 2, 4));
        return statusBar;
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
            MobileStationPopUp menu = new MobileStationPopUp(BasicGraphEditor.this, (MS) resultmol);
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
        graphComponent.getGraphHandler().setRemoveCellsFromParent(false);
        
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
        frame.addWindowListener(new WindowAdapter() {

            public void windowClosing(WindowEvent we) {
                System.out.println("Deleting DB");
                 ms_app.DatabaseHandler.deleteDB_HLR();
                ms_app.DatabaseHandler.deleteDB_MSC();
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

    private void zoom(mxGraph graph, double scale) {
        graphComponent.getGraph().getView().scaleAndTranslate(scale,
                (graph.getGraphBounds().getCenterX()
                - (graph.getGraphBounds().getWidth() / 2)) / scale,
                (graph.getGraphBounds().getCenterY()
                - (graph.getGraphBounds().getHeight() / 2)) / scale);
    }

    public void AeroactionPerformed(ActionEvent ae) {
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

    public void MacactionPerformed(ActionEvent ae) {
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

    public void GraphiteactionPerformed(ActionEvent ae) {
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

    public void keyTyped(KeyEvent e) {
    }

    public void keyPressed(KeyEvent e) {
         char i = e.getKeyChar();
        String str = Character.toString(i);
        System.out.println("---> Str " + str);
    }

    public void keyReleased(KeyEvent e) {
    }
    
    
    private void jTextArea1KeyPressed(java.awt.event.KeyEvent evt) {                                      

		if(commandTextArea.getCaretPosition()<cmdStart)
			commandTextArea.setEditable(false);
	else
	{
            try {
                commandTextArea.setEditable(true);
                if (evt.getKeyCode() == 38) {
                    commandTextArea.setSelectionStart(cmdStart);
                    commandTextArea.setSelectionEnd(cmdEnd + 1);
                    if (commandCount > 0) {
                        String newCommand = (String) commands.get(commandCount - 1);
                        commandTextArea.replaceSelection(newCommand);
                        commandCount--;
                   }
                } else if (evt.getKeyCode() == 40) {
                    commandTextArea.setSelectionStart(cmdStart);
                    commandTextArea.setSelectionEnd(cmdEnd + 1);
                    if (commandCount + 1 < commands.size()) {

                        String newCommand = (String) commands.get(commandCount + 1);
                        commandTextArea.replaceSelection(newCommand);
                        commandCount++;
                                            }
                    else if(commandCount + 1 == commands.size())
                    {commandTextArea.replaceSelection("");
                    commandCount++;
                    }
                    else
                    commandTextArea.replaceSelection("");       
                } else if (evt.getKeyCode() == 8) //backspace
                {
                    count -= 2;
                    if (cmdEnd <= cmdStart + 1) {
                        commandTextArea.setEditable(false);

                    }

                } else if (evt.getKeyCode() == 10) {
                    commandTextArea.select(cmdStart, cmdEnd + 1);
                    String cmd = commandTextArea.getSelectedText();
                    commands.add(cmd);
                    parser.executeCommand(cmd);
                    String g = commandTextArea.getText();
                    commandTextArea.setCaretPosition(g.length());
                    commandTextArea.append("\n" + prompt);

                    commandCount = commands.size();
                }

                cmdStart = commandTextArea.getLineStartOffset(commandTextArea.getLineCount() - 1) + promptCount;
                cmdEnd = commandTextArea.getLineEndOffset(commandTextArea.getLineCount() - 1);
            } catch (BadLocationException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            }
    
	}
    }                                     

    private void jTextArea1KeyReleased(java.awt.event.KeyEvent evt) {                                       
        if (evt.getKeyCode() == 10) {
            String s = commandTextArea.getText().trim();
            commandTextArea.setText(s);
        } else if (evt.getKeyCode() == 38) {
            commandTextArea.setCaretPosition(cmdEnd);
        }
    }
        public void appendResult(String str)
    {
        commandTextArea.append("\n"+str);
        int i=commandTextArea.getRows()+5;
        commandTextArea.setRows(i);
    }

    public void clearTextArea() {
        commandTextArea.setText("");
    }
}
