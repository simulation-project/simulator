package com.iti.telecom.editor;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.AbstractAction;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.SwingUtilities;
import javax.swing.TransferHandler;
import javax.swing.UIManager;

import com.iti.telecom.editor.EditorActions.AlignCellsAction;
import com.iti.telecom.editor.EditorActions.AutosizeAction;
import com.iti.telecom.editor.EditorActions.BackgroundAction;
import com.iti.telecom.editor.EditorActions.BackgroundImageAction;
import com.iti.telecom.editor.EditorActions.ColorAction;
import com.iti.telecom.editor.EditorActions.ExitAction;
import com.iti.telecom.editor.EditorActions.GridColorAction;
import com.iti.telecom.editor.EditorActions.GridStyleAction;
import com.iti.telecom.editor.EditorActions.HistoryAction;
import com.iti.telecom.editor.EditorActions.ImportAction;
import com.iti.telecom.editor.EditorActions.KeyValueAction;
import com.iti.telecom.editor.EditorActions.NewAction;
import com.iti.telecom.editor.EditorActions.OpenAction;
import com.iti.telecom.editor.EditorActions.PageBackgroundAction;
import com.iti.telecom.editor.EditorActions.PageSetupAction;
import com.iti.telecom.editor.EditorActions.PrintAction;
import com.iti.telecom.editor.EditorActions.PromptPropertyAction;
import com.iti.telecom.editor.EditorActions.PromptValueAction;
import com.iti.telecom.editor.EditorActions.SaveAction;
import com.iti.telecom.editor.EditorActions.ScaleAction;
import com.iti.telecom.editor.EditorActions.SelectShortestPathAction;
import com.iti.telecom.editor.EditorActions.SelectSpanningTreeAction;
import com.iti.telecom.editor.EditorActions.SetLabelPositionAction;
import com.iti.telecom.editor.EditorActions.SetStyleAction;
import com.iti.telecom.editor.EditorActions.StyleAction;
import com.iti.telecom.editor.EditorActions.StylesheetAction;
import com.iti.telecom.editor.EditorActions.ToggleAction;
import com.iti.telecom.editor.EditorActions.ToggleConnectModeAction;
import com.iti.telecom.editor.EditorActions.ToggleCreateTargetItem;
import com.iti.telecom.editor.EditorActions.ToggleDirtyAction;
import com.iti.telecom.editor.EditorActions.ToggleGridItem;
import com.iti.telecom.editor.EditorActions.TogglePropertyItem;
import com.iti.telecom.editor.EditorActions.ToggleRulersItem;
import com.iti.telecom.editor.EditorActions.WarningAction;
import com.iti.telecom.editor.EditorActions.ZoomPolicyAction;
import com.mxgraph.swing.mxGraphComponent;
import com.mxgraph.swing.util.mxGraphActions;
import com.mxgraph.util.mxConstants;
import com.mxgraph.util.mxPoint;
import com.mxgraph.util.mxResources;
import com.mxgraph.view.mxGraph;

public class EditorMenuBar extends JMenuBar {

    /**
     *
     */
    private static final long serialVersionUID = 4060203894740766714L;

    @SuppressWarnings("serial")
    public EditorMenuBar(final BasicGraphEditor editor) {
        final mxGraphComponent graphComponent = editor.getGraphComponent();
        final mxGraph graph = graphComponent.getGraph();
        JMenu menu = null;
        JMenu submenu = null;

        // Creates the file menu

       // menu = add(new JMenu(mxResources.get("cell")));
      //  populateCellMenu(menu, editor);
       // menu.addSeparator();
        submenu = add(new JMenu(mxResources.get("zoom")));

        submenu.add(editor.bind("400%", new EditorActions.ScaleAction(4.0D)));
        submenu.add(editor.bind("200%", new EditorActions.ScaleAction(2.0D)));
        submenu.add(editor.bind("150%", new EditorActions.ScaleAction(1.5D)));
        submenu.add(editor.bind("100%", new EditorActions.ScaleAction(1.0D)));
        submenu.add(editor.bind("75%", new EditorActions.ScaleAction(0.75D)));
        submenu.add(editor.bind("50%", new EditorActions.ScaleAction(0.5D)));

        submenu.addSeparator();
     JMenu  submenu2 =  add(new JMenu(mxResources.get("gridtype")));

    submenu2.add(editor.bind(mxResources.get("dashed"), new EditorActions.GridStyleAction(3)));

    submenu2.add(editor.bind(mxResources.get("dot"), new EditorActions.GridStyleAction(0)));

     submenu2.add(editor.bind(mxResources.get("line"), new EditorActions.GridStyleAction(2)));

     submenu2.add(editor.bind(mxResources.get("cross"), new EditorActions.GridStyleAction(1)));




    }

    /**
     * Adds menu items to the given shape menu. This is factored out because the
     * shape menu appears in the menubar and also in the popupmenu.
     */
    public static void populateShapeMenu(JMenu menu, BasicGraphEditor editor) {
        menu.add(editor.bind(mxResources.get("home"), mxGraphActions.getHomeAction(),
                "/com/iti/telecom/images/house.gif"));

        menu.addSeparator();

        menu.add(editor.bind(mxResources.get("exitGroup"), mxGraphActions.getExitGroupAction(),
                "/com/iti/telecom/images/up.gif"));
        menu.add(editor.bind(mxResources.get("enterGroup"), mxGraphActions.getEnterGroupAction(),
                "/com/iti/telecom/images/down.gif"));

        menu.addSeparator();

        menu.add(editor.bind(mxResources.get("group"), mxGraphActions.getGroupAction(),
                "/com/iti/telecom/images/group.gif"));
        menu.add(editor.bind(mxResources.get("ungroup"), mxGraphActions.getUngroupAction(),
                "/com/iti/telecom/images/ungroup.gif"));

        menu.addSeparator();

        menu.add(editor.bind(mxResources.get("removeFromGroup"), mxGraphActions.getRemoveFromParentAction()));

        menu.add(editor.bind(mxResources.get("updateGroupBounds"),
                mxGraphActions.getUpdateGroupBoundsAction()));

        menu.addSeparator();

        menu.add(editor.bind(mxResources.get("collapse"), mxGraphActions.getCollapseAction(),
                "/com/iti/telecom/images/collapse.gif"));
        menu.add(editor.bind(mxResources.get("expand"), mxGraphActions.getExpandAction(),
                "/com/iti/telecom/images/expand.gif"));

        menu.addSeparator();

        menu.add(editor.bind(mxResources.get("toBack"), mxGraphActions.getToBackAction(),
                "/com/iti/telecom/images/toback.gif"));
        menu.add(editor.bind(mxResources.get("toFront"), mxGraphActions.getToFrontAction(),
                "/com/iti/telecom/images/tofront.gif"));

        menu.addSeparator();

        JMenu submenu = (JMenu) menu.add(new JMenu(mxResources.get("align")));

        submenu.add(editor.bind(mxResources.get("left"), new AlignCellsAction(
                mxConstants.ALIGN_LEFT),
                "/com/iti/telecom/images/alignleft.gif"));
        submenu.add(editor.bind(mxResources.get("center"),
                new AlignCellsAction(mxConstants.ALIGN_CENTER),
                "/com/iti/telecom/images/aligncenter.gif"));
        submenu.add(editor.bind(mxResources.get("right"), new AlignCellsAction(
                mxConstants.ALIGN_RIGHT),
                "/com/iti/telecom/images/alignright.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("top"), new AlignCellsAction(
                mxConstants.ALIGN_TOP),
                "/com/iti/telecom/images/aligntop.gif"));
        submenu.add(editor.bind(mxResources.get("middle"),
                new AlignCellsAction(mxConstants.ALIGN_MIDDLE),
                "/com/iti/telecom/images/alignmiddle.gif"));
        submenu.add(editor.bind(mxResources.get("bottom"),
                new AlignCellsAction(mxConstants.ALIGN_BOTTOM),
                "/com/iti/telecom/images/alignbottom.gif"));

        menu.addSeparator();

        menu.add(editor.bind(mxResources.get("autosize"),
                new AutosizeAction()));

    }

    /**
     * Adds menu items to the given format menu. This is factored out because
     * the format menu appears in the menubar and also in the popupmenu.
     */
    public static void populateFormatMenu(JMenu menu, BasicGraphEditor editor) {
        JMenu submenu = (JMenu) menu.add(new JMenu(mxResources.get("background")));

        submenu.add(editor.bind(mxResources.get("fillcolor"), new ColorAction(
                "Fillcolor", mxConstants.STYLE_FILLCOLOR),
                "/com/iti/telecom/images/fillcolor.gif"));
        submenu.add(editor.bind(mxResources.get("gradient"), new ColorAction(
                "Gradient", mxConstants.STYLE_GRADIENTCOLOR)));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("image"),
                new PromptValueAction(mxConstants.STYLE_IMAGE, "Image")));
        submenu.add(editor.bind(mxResources.get("shadow"), new ToggleAction(
                mxConstants.STYLE_SHADOW)));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("opacity"),
                new PromptValueAction(mxConstants.STYLE_OPACITY,
                "Opacity (0-100)")));

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("label")));

        submenu.add(editor.bind(mxResources.get("fontcolor"), new ColorAction(
                "Fontcolor", mxConstants.STYLE_FONTCOLOR),
                "/com/iti/telecom/images/fontcolor.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("labelFill"), new ColorAction(
                "Label Fill", mxConstants.STYLE_LABEL_BACKGROUNDCOLOR)));
        submenu.add(editor.bind(mxResources.get("labelBorder"),
                new ColorAction("Label Border",
                mxConstants.STYLE_LABEL_BORDERCOLOR)));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("rotateLabel"),
                new ToggleAction(mxConstants.STYLE_HORIZONTAL, true)));

        submenu.add(editor.bind(mxResources.get("textOpacity"),
                new PromptValueAction(mxConstants.STYLE_TEXT_OPACITY,
                "Opacity (0-100)")));

        submenu.addSeparator();

        JMenu subsubmenu = (JMenu) submenu.add(new JMenu(mxResources.get("position")));

        subsubmenu.add(editor.bind(mxResources.get("top"),
                new SetLabelPositionAction(mxConstants.ALIGN_TOP,
                mxConstants.ALIGN_BOTTOM)));
        subsubmenu.add(editor.bind(mxResources.get("middle"),
                new SetLabelPositionAction(mxConstants.ALIGN_MIDDLE,
                mxConstants.ALIGN_MIDDLE)));
        subsubmenu.add(editor.bind(mxResources.get("bottom"),
                new SetLabelPositionAction(mxConstants.ALIGN_BOTTOM,
                mxConstants.ALIGN_TOP)));

        subsubmenu.addSeparator();

        subsubmenu.add(editor.bind(mxResources.get("left"),
                new SetLabelPositionAction(mxConstants.ALIGN_LEFT,
                mxConstants.ALIGN_RIGHT)));
        subsubmenu.add(editor.bind(mxResources.get("center"),
                new SetLabelPositionAction(mxConstants.ALIGN_CENTER,
                mxConstants.ALIGN_CENTER)));
        subsubmenu.add(editor.bind(mxResources.get("right"),
                new SetLabelPositionAction(mxConstants.ALIGN_RIGHT,
                mxConstants.ALIGN_LEFT)));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("wordWrap"),
                new KeyValueAction(mxConstants.STYLE_WHITE_SPACE, "wrap")));
        submenu.add(editor.bind(mxResources.get("noWordWrap"),
                new KeyValueAction(mxConstants.STYLE_WHITE_SPACE, null)));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("hide"), new ToggleAction(
                mxConstants.STYLE_NOLABEL)));

        menu.addSeparator();

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("line")));

        submenu.add(editor.bind(mxResources.get("linecolor"), new ColorAction(
                "Linecolor", mxConstants.STYLE_STROKECOLOR),
                "/com/iti/telecom/images/linecolor.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("orthogonal"), new ToggleAction(
                mxConstants.STYLE_ORTHOGONAL)));
        submenu.add(editor.bind(mxResources.get("dashed"), new ToggleAction(
                mxConstants.STYLE_DASHED)));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("linewidth"),
                new PromptValueAction(mxConstants.STYLE_STROKEWIDTH,
                "Linewidth")));

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("connector")));

        submenu.add(editor.bind(mxResources.get("straight"),
                new SetStyleAction("straight"),
                "/com/iti/telecom/images/straight.gif"));

        submenu.add(editor.bind(mxResources.get("horizontal"),
                new SetStyleAction(""),
                "/com/iti/telecom/images/connect.gif"));
        submenu.add(editor.bind(mxResources.get("vertical"),
                new SetStyleAction("vertical"),
                "/com/iti/telecom/images/vertical.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("entityRelation"),
                new SetStyleAction("edgeStyle=mxEdgeStyle.EntityRelation"),
                "/com/iti/telecom/images/entity.gif"));
        submenu.add(editor.bind(mxResources.get("arrow"), new SetStyleAction(
                "arrow"), "/com/iti/telecom/images/arrow.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("plain"), new ToggleAction(
                mxConstants.STYLE_NOEDGESTYLE)));

        menu.addSeparator();

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("linestart")));

        submenu.add(editor.bind(mxResources.get("open"), new KeyValueAction(
                mxConstants.STYLE_STARTARROW, mxConstants.ARROW_OPEN),
                "/com/iti/telecom/images/open_start.gif"));
        submenu.add(editor.bind(mxResources.get("classic"), new KeyValueAction(
                mxConstants.STYLE_STARTARROW, mxConstants.ARROW_CLASSIC),
                "/com/iti/telecom/images/classic_start.gif"));
        submenu.add(editor.bind(mxResources.get("block"), new KeyValueAction(
                mxConstants.STYLE_STARTARROW, mxConstants.ARROW_BLOCK),
                "/com/iti/telecom/images/block_start.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("diamond"), new KeyValueAction(
                mxConstants.STYLE_STARTARROW, mxConstants.ARROW_DIAMOND),
                "/com/iti/telecom/images/diamond_start.gif"));
        submenu.add(editor.bind(mxResources.get("oval"), new KeyValueAction(
                mxConstants.STYLE_STARTARROW, mxConstants.ARROW_OVAL),
                "/com/iti/telecom/images/oval_start.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("none"), new KeyValueAction(
                mxConstants.STYLE_STARTARROW, mxConstants.NONE)));
        submenu.add(editor.bind(mxResources.get("size"), new PromptValueAction(
                mxConstants.STYLE_STARTSIZE, "Linestart Size")));

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("lineend")));

        submenu.add(editor.bind(mxResources.get("open"), new KeyValueAction(
                mxConstants.STYLE_ENDARROW, mxConstants.ARROW_OPEN),
                "/com/iti/telecom/images/open_end.gif"));
        submenu.add(editor.bind(mxResources.get("classic"), new KeyValueAction(
                mxConstants.STYLE_ENDARROW, mxConstants.ARROW_CLASSIC),
                "/com/iti/telecom/images/classic_end.gif"));
        submenu.add(editor.bind(mxResources.get("block"), new KeyValueAction(
                mxConstants.STYLE_ENDARROW, mxConstants.ARROW_BLOCK),
                "/com/iti/telecom/images/block_end.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("diamond"), new KeyValueAction(
                mxConstants.STYLE_ENDARROW, mxConstants.ARROW_DIAMOND),
                "/com/iti/telecom/images/diamond_end.gif"));
        submenu.add(editor.bind(mxResources.get("oval"), new KeyValueAction(
                mxConstants.STYLE_ENDARROW, mxConstants.ARROW_OVAL),
                "/com/iti/telecom/images/oval_end.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("none"), new KeyValueAction(
                mxConstants.STYLE_ENDARROW, mxConstants.NONE)));
        submenu.add(editor.bind(mxResources.get("size"), new PromptValueAction(
                mxConstants.STYLE_ENDSIZE, "Lineend Size")));

        menu.addSeparator();

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("alignment")));

        submenu.add(editor.bind(mxResources.get("left"), new KeyValueAction(
                mxConstants.STYLE_ALIGN, mxConstants.ALIGN_LEFT),
                "/com/iti/telecom/images/left.gif"));
        submenu.add(editor.bind(mxResources.get("center"), new KeyValueAction(
                mxConstants.STYLE_ALIGN, mxConstants.ALIGN_CENTER),
                "/com/iti/telecom/images/center.gif"));
        submenu.add(editor.bind(mxResources.get("right"), new KeyValueAction(
                mxConstants.STYLE_ALIGN, mxConstants.ALIGN_RIGHT),
                "/com/iti/telecom/images/right.gif"));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("top"), new KeyValueAction(
                mxConstants.STYLE_VERTICAL_ALIGN, mxConstants.ALIGN_TOP),
                "/com/iti/telecom/images/top.gif"));
        submenu.add(editor.bind(mxResources.get("middle"), new KeyValueAction(
                mxConstants.STYLE_VERTICAL_ALIGN, mxConstants.ALIGN_MIDDLE),
                "/com/iti/telecom/images/middle.gif"));
        submenu.add(editor.bind(mxResources.get("bottom"), new KeyValueAction(
                mxConstants.STYLE_VERTICAL_ALIGN, mxConstants.ALIGN_BOTTOM),
                "/com/iti/telecom/images/bottom.gif"));

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("spacing")));

        submenu.add(editor.bind(mxResources.get("top"), new PromptValueAction(
                mxConstants.STYLE_SPACING_TOP, "Top Spacing")));
        submenu.add(editor.bind(mxResources.get("right"),
                new PromptValueAction(mxConstants.STYLE_SPACING_RIGHT,
                "Right Spacing")));
        submenu.add(editor.bind(mxResources.get("bottom"),
                new PromptValueAction(mxConstants.STYLE_SPACING_BOTTOM,
                "Bottom Spacing")));
        submenu.add(editor.bind(mxResources.get("left"), new PromptValueAction(
                mxConstants.STYLE_SPACING_LEFT, "Left Spacing")));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("global"),
                new PromptValueAction(mxConstants.STYLE_SPACING, "Spacing")));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("sourceSpacing"),
                new PromptValueAction(
                mxConstants.STYLE_SOURCE_PERIMETER_SPACING, mxResources.get("sourceSpacing"))));
        submenu.add(editor.bind(mxResources.get("targetSpacing"),
                new PromptValueAction(
                mxConstants.STYLE_TARGET_PERIMETER_SPACING, mxResources.get("targetSpacing"))));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("perimeter"),
                new PromptValueAction(mxConstants.STYLE_PERIMETER_SPACING,
                "Perimeter Spacing")));

        submenu = (JMenu) menu.add(new JMenu(mxResources.get("direction")));

        submenu.add(editor.bind(mxResources.get("north"), new KeyValueAction(
                mxConstants.STYLE_DIRECTION, mxConstants.DIRECTION_NORTH)));
        submenu.add(editor.bind(mxResources.get("east"), new KeyValueAction(
                mxConstants.STYLE_DIRECTION, mxConstants.DIRECTION_EAST)));
        submenu.add(editor.bind(mxResources.get("south"), new KeyValueAction(
                mxConstants.STYLE_DIRECTION, mxConstants.DIRECTION_SOUTH)));
        submenu.add(editor.bind(mxResources.get("west"), new KeyValueAction(
                mxConstants.STYLE_DIRECTION, mxConstants.DIRECTION_WEST)));

        submenu.addSeparator();

        submenu.add(editor.bind(mxResources.get("rotation"),
                new PromptValueAction(mxConstants.STYLE_ROTATION,
                "Rotation (0-360)")));

        menu.addSeparator();

        menu.add(editor.bind(mxResources.get("rounded"), new ToggleAction(
                mxConstants.STYLE_ROUNDED)));

        menu.add(editor.bind(mxResources.get("style"), new StyleAction()));
    }

    public static void populateCellMenu(JMenu menu, BasicGraphEditor editor) {

        menu.add(editor.bind(mxResources.get("properties"), new EditorActions.PropertiesAction()));
        
    }
}
