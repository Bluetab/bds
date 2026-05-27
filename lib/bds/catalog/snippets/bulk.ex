defmodule Bds.Catalog.Snippets.Bulk do
  @moduledoc false

  def snippets do
    %{}
    |> Map.merge(get_started())
    |> Map.merge(app_bars())
    |> Map.merge(badges())
    |> Map.merge(buttons())
    |> Map.merge(cards())
    |> Map.merge(checkboxes())
    |> Map.merge(chips())
    |> Map.merge(code())
    |> Map.merge(combobox())
    |> Map.merge(colors())
    |> Map.merge(containers())
    |> Map.merge(dialogs())
    |> Map.merge(directions())
    |> Map.merge(dividers())
    |> Map.merge(expansions())
    |> Map.merge(fields())
    |> Map.merge(grid())
    |> Map.merge(helpers())
    |> Map.merge(icons())
    |> Map.merge(layout())
    |> Map.merge(lists())
    |> Map.merge(main_layout())
    |> Map.merge(media())
    |> Map.merge(menus())
    |> Map.merge(navigation())
    |> Map.merge(overlays())
    |> Map.merge(pages())
    |> Map.merge(progress())
    |> Map.merge(radio())
    |> Map.merge(selects())
    |> Map.merge(shapes())
    |> Map.merge(sliders())
    |> Map.merge(snackbars())
    |> Map.merge(switches())
    |> Map.merge(tables())
    |> Map.merge(tabs())
    |> Map.merge(textarea())
    |> Map.merge(tree())
    |> Map.merge(tooltips())
    |> Map.merge(typography())
  end

  defp get_started do
    %{
      "get-started:0" => ~S"""
      <.bt_card variant="filled">
        <:title>Project architecture</:title>
        <p>
          Edit <.bt_code>src/styles/tokens.css</.bt_code> first, then each component under
          <.bt_code>src/styles/components/</.bt_code>.
        </p>
        <.bt_code_block>
      import Bds.Components
      import Bds.Components.CatalogUi
        </.bt_code_block>
      </.bt_card>
      """,
      "get-started:1" => ~S"""
      <.bt_button>Save changes</.bt_button>
      <.bt_button variant="outline">Cancel</.bt_button>
      """
    }
  end

  defp app_bars do
    %{
      "app-bars:0" => ~S"""
      <.bt_appbar>
        <.bt_icon_button label="Menu" icon="☰" />
        <strong>Bluetab Project</strong>
        <.bt_spacer />
        <.bt_icon_button label="Search" icon="⌕" />
        <.bt_icon_button label="User" icon="◎" />
      </.bt_appbar>
      """,
      "app-bars:1" => ~S"""
      <.bt_appbar variant="primary">
        <.bt_icon_button variant="primary" label="Back" icon="←" />
        <strong>Analytics Dashboard</strong>
        <.bt_spacer />
        <.bt_button variant="secondary">Publish</.bt_button>
      </.bt_appbar>
      """,
      "app-bars:2" => ~S"""
      <.bt_bottom_nav label="Bottom navigation">
        <:item icon="⌂" label="Home" current />
        <:item icon="▦" label="Apps" />
        <:item icon="☷" label="Data" />
        <:item icon="⚙" label="Settings" />
      </.bt_bottom_nav>
      """
    }
  end

  defp badges do
    %{
      "badges:0" => ~S"""
      <.bt_badge_wrap>
        <.bt_icon>⌂</.bt_icon>
        <.bt_badge variant="dot" />
      </.bt_badge_wrap>
      """,
      "badges:1" => ~S"""
      <.bt_badge_wrap>
        <.bt_icon>⌂</.bt_icon>
        <.bt_badge>10</.bt_badge>
      </.bt_badge_wrap>
      """,
      "badges:2" => ~S"""
      <.bt_button>
        Alerts
        <.bt_badge variant="inline">3</.bt_badge>
      </.bt_button>
      <.bt_button variant="secondary">
        Processes
        <.bt_badge variant="inline-success">OK</.bt_badge>
      </.bt_button>
      """
    }
  end

  defp buttons do
    %{
      "buttons:0" => ~S"""
      <.bt_button>Primary</.bt_button>
      <.bt_button variant="secondary">Secondary</.bt_button>
      <.bt_button variant="tertiary">Tertiary</.bt_button>
      <.bt_button variant="outline">Outline</.bt_button>
      <.bt_button variant="ghost">Ghost</.bt_button>
      """,
      "buttons:1" => ~S"""
      <.bt_button class="bt-button bt-button--sm">Small</.bt_button>
      <.bt_button>Medium</.bt_button>
      <.bt_button class="bt-button bt-button--lg">Large</.bt_button>
      """,
      "buttons:2" => ~S"""
      <.bt_icon_button label="Search" icon="⌕" />
      <.bt_icon_button variant="primary" label="Save" icon="✓" />
      <.bt_fab label="Create"><.bt_icon>＋</.bt_icon></.bt_fab>
      <.bt_fab extended label="Create"><.bt_icon>＋</.bt_icon> Create</.bt_fab>
      """,
      "buttons:3" => ~S"""
      <.bt_segmented label="View">
        <:item label="Day" pressed />
        <:item label="Week" />
        <:item label="Month" />
      </.bt_segmented>
      """
    }
  end

  defp cards do
    %{
      "cards:0" => ~S"""
      <.bt_card>
        <:title>Standard card</:title>
        Group related information on a screen.
        <:actions>
          <.bt_button variant="ghost">Learn more</.bt_button>
          <.bt_button>Accept</.bt_button>
        </:actions>
      </.bt_card>
      """,
      "cards:1" => ~S"""
      <.bt_card variant="elevated" span="">
        <:title>Data product</:title>
        Card with media block, elevation, and actions.
      </.bt_card>
      """,
      "cards:2" => ~S"""
      <.bt_card variant="filled">
        <:title>Filled card</:title>
        Soft sections or secondary groupings.
      </.bt_card>
      <.bt_card variant="primary">
        <:title>Primary card</:title>
        Highlighted product or brand messages.
      </.bt_card>
      """
    }
  end

  defp checkboxes do
    %{
      "checkboxes:0" => ~S"""
      <.bt_input type="checkbox" name="terms" label="Accept terms" />
      <.bt_input type="checkbox" name="copy" label="Send copy" checked />
      """,
      "checkboxes:1" => ~S"""
      <.bt_input type="checkbox" name="unavailable" label="Unavailable option" disabled />
      <.bt_input type="checkbox" name="required" label="Required option" checked disabled />
      """
    }
  end

  defp chips do
    %{
      "chips:0" => ~S"""
      <.bt_chip>Data</.bt_chip>
      <.bt_chip variant="selected">Selected</.bt_chip>
      <.bt_chip variant="outline">Outline</.bt_chip>
      <.bt_chip tag="button"><.bt_icon>＋</.bt_icon> Add filter</.bt_chip>
      """,
      "chips:1" => ~S"""
      <.bt_status variant="success">Active</.bt_status>
      <.bt_status variant="warning">Pending</.bt_status>
      <.bt_status variant="error">Error</.bt_status>
      <.bt_status variant="info">Info</.bt_status>
      """
    }
  end

  defp code do
    %{
      "code:0" => ~S"""
      <.bt_muted>
        Mention classes with <.bt_code>bt-button</.bt_code> or paths with
        <.bt_code class="bt-code-inline--wrap">docs/how-to-use-design-system.md</.bt_code>.
      </.bt_muted>
      """,
      "code:1" => ~S"""
      <.bt_code_block>
      @import "bluetab-design-system/styles.css";

      import { initBtInteractions } from "bluetab-design-system/interactions";
      initBtInteractions();
      </.bt_code_block>
      """,
      "code:2" => ~S"""
      <.bt_example_grid>
        <.bt_card variant="elevated" class="bt-card--third">A</.bt_card>
        <.bt_card variant="filled" class="bt-card--third">B</.bt_card>
        <.bt_card variant="third">C</.bt_card>
      </.bt_example_grid>
      """
    }
  end

  defp colors do
    %{
      "colors:0" => ~S"""
      <%!-- bt-color-grid: layout utility, no function component --%>
      <div class="bt-color-grid">
        <.bt_color_swatch label="Primary" swatch="var(--bt-color-primary)" />
        <.bt_color_swatch label="Secondary" swatch="var(--bt-color-secondary)" />
        <.bt_color_swatch label="Tertiary" swatch="var(--bt-color-tertiary)" />
        <.bt_color_swatch label="Surface" swatch="var(--bt-color-surface-muted)" />
      </div>
      """,
      "colors:1" => ~S"""
      <div class="bt-row">
        <.bt_status variant="success">Success</.bt_status>
        <.bt_status variant="warning">Warning</.bt_status>
        <.bt_status variant="error">Error</.bt_status>
        <.bt_status variant="info">Info</.bt_status>
      </div>
      """
    }
  end

  defp containers do
    %{
      "containers:0" => ~S"""
      <.bt_container>
        <h3>Container</h3>
        <p>Reusable block for documentation panels and content zones.</p>
      </.bt_container>
      """,
      "containers:1" => ~S"""
      <.bt_container variant="compact">
        <p>Compact container with reduced padding.</p>
      </.bt_container>
      """
    }
  end

  defp dialogs do
    %{
      "dialogs:0" => ~S"""
      <.bt_button data-dialog-open="dialog-basic">Open dialog</.bt_button>
      <.bt_dialog id="dialog-basic" title="Confirm action">
        This dialog uses design-system JavaScript interactions.
        <:actions>
          <.bt_button variant="ghost" data-dialog-close>Cancel</.bt_button>
          <.bt_button data-dialog-close>Accept</.bt_button>
        </:actions>
      </.bt_dialog>
      """,
      "dialogs:1" => ~S"""
      <.bt_button variant="danger" data-dialog-open="dialog-alert">Delete</.bt_button>
      <.bt_dialog id="dialog-alert" title="Delete record" role="alertdialog">
        This action cannot be undone.
        <:actions>
          <.bt_button variant="ghost" data-dialog-close>Back</.bt_button>
          <.bt_button variant="danger" data-dialog-close>Delete</.bt_button>
        </:actions>
      </.bt_dialog>
      """
    }
  end

  defp directions do
    %{
      "directions:0" => ~S"""
      <%!-- bt-dir-*: layout utilities --%>
      <div class="bt-dir-row">
        <.bt_button variant="secondary">One</.bt_button>
        <.bt_button variant="secondary">Two</.bt_button>
        <.bt_button variant="secondary">Three</.bt_button>
      </div>
      """,
      "directions:1" => ~S"""
      <div class="bt-dir-column">
        <.bt_button variant="secondary">First</.bt_button>
        <.bt_button variant="secondary">Second</.bt_button>
        <.bt_button variant="secondary">Third</.bt_button>
      </div>
      """,
      "directions:2" => ~S"""
      <div class="bt-dir-reverse">
        <.bt_button variant="secondary">A</.bt_button>
        <.bt_button variant="secondary">B</.bt_button>
        <.bt_button variant="secondary">C</.bt_button>
      </div>
      """
    }
  end

  defp dividers do
    %{
      "dividers:0" => ~S"""
      <%!-- bt-stack: layout utility --%>
      <div class="bt-stack">
        <span>Top content</span>
        <.bt_divider />
        <span>Bottom content</span>
      </div>
      """,
      "dividers:1" => ~S"""
      <div class="bt-row">
        <span>Start</span>
        <.bt_divider vertical />
        <span>End</span>
      </div>
      """
    }
  end

  defp expansions do
    %{
      "expansions:0" => ~S"""
      <.bt_expansion title="What does this component include?">
        Expandable content for documentation, FAQs, or secondary data.
      </.bt_expansion>
      """
    }
  end

  defp fields do
    %{
      "fields:0" => ~S"""
      <.bt_input name="name" label="Name" type="text" placeholder="e.g. Data Governance" help="Optional help text." />
      <.bt_input
        name="error_field"
        label="Field with error"
        type="text"
        value="Incorrect value"
        errors={["Review this value before continuing."]}
      />
      """,
      "fields:1" => ~S"""
      <.bt_input name="search" label="Search" type="search" placeholder="Search component" />
      """
    }
  end

  defp grid do
    %{
      "grid:0" => ~S"""
      <%!-- bt-layout-demo: layout utility --%>
      <div class="bt-layout-demo">
        <div>1</div>
        <div>2</div>
        <div>3</div>
      </div>
      """,
      "grid:1" => ~S"""
      <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr)); gap: var(--bt-space-3); width:100%;">
        <.bt_card variant="filled">A</.bt_card>
        <.bt_card variant="filled">B</.bt_card>
        <.bt_card variant="filled">C</.bt_card>
      </div>
      """
    }
  end

  defp helpers do
    %{
      "helpers:0" => ~S"""
      <div class="bt-stack">
        <div class="bt-inline">
          <.bt_status variant="info">Inline</.bt_status>
          <.bt_status variant="success">Wrap</.bt_status>
        </div>
        <.bt_muted>
          Use <.bt_code>.bt-stack</.bt_code>, <.bt_code>.bt-inline</.bt_code>, <.bt_code>.bt-row</.bt_code> for layout.
        </.bt_muted>
      </div>
      """,
      "helpers:1" => ~S"""
      <%!-- bt-surface / bt-round-* / bt-shadow-*: helper utilities --%>
      <div class="bt-surface bt-round-sm bt-shadow-sm" style="padding: var(--bt-space-4);">Small radius</div>
      <div class="bt-surface bt-round-lg bt-shadow-md" style="padding: var(--bt-space-4);">Large radius</div>
      """
    }
  end

  defp icons do
    %{
      "icons:0" => ~S"""
      <.bt_icon>⌂</.bt_icon>
      <.bt_icon>⌕</.bt_icon>
      <.bt_icon>⚙</.bt_icon>
      <.bt_icon>✓</.bt_icon>
      <.bt_icon>×</.bt_icon>
      """,
      "icons:1" => ~S"""
      <.bt_button>
        <.bt_icon>✓</.bt_icon>
        Validate
      </.bt_button>
      """
    }
  end

  defp layout do
    %{
      "layout:0" => ~S"""
      <%!-- bt-shell / bt-sidebar: no function components --%>
      <div class="bt-shell">
        <aside class="bt-sidebar">Sidebar</aside>
        <main class="bt-main">Main content</main>
      </div>
      """,
      "layout:1" => ~S"""
      <div class="bt-shell bt-shell--app">
        <.bt_topbar>
          <:brand>
            <.bt_navbar_logo_link href="#" logo_src="/images/logo.png">App</.bt_navbar_logo_link>
          </:brand>
          <:actions>
            <.bt_navbar_theme_toggle />
          </:actions>
        </.bt_topbar>
        <main class="bt-main">Main content</main>
      </div>
      """,
      "layout:2" => ~S"""
      <.bt_section title="Section title" description="Brief section description.">
        <:actions>
          <.bt_button variant="secondary">Action</.bt_button>
        </:actions>
      </.bt_section>
      """
    }
  end

  defp lists do
    %{
      "lists:0" => ~S"""
      <%!-- bt_list_item has no actions slot; icon button composed in row --%>
      <.bt_list_group>
        <div class="bt-list-item">
          <.bt_list_item initials="B" title="Bluetab Design System" subtitle="List component" />
          <.bt_icon_button label="More" icon="⋯" />
        </div>
        <.bt_list_item initials="D" title="Data Product" subtitle="Secondary item" />
      </.bt_list_group>
      """
    }
  end

  defp main_layout do
    %{
      "main-layout:0" => ~S"""
      <.bt_card variant="filled">
        <.bt_appbar>
          <strong>Dashboard</strong>
          <.bt_spacer />
          <.bt_button variant="secondary">Export</.bt_button>
        </.bt_appbar>
        <div class="bt-layout-demo" style="margin-top: var(--bt-space-4);">
          <div>KPI</div>
          <div>Chart</div>
          <div>Table</div>
        </div>
      </.bt_card>
      """
    }
  end

  defp media do
    %{
      "media:0" => ~S"""
      <.bt_card span="">
        <.bt_muted>Responsive media inside a card.</.bt_muted>
      </.bt_card>
      """,
      "media:1" => ~S"""
      <%!-- list-item avatar: no dedicated media component --%>
      <div class="bt-list-item__avatar">BT</div>
      <div class="bt-list-item__avatar" style="background: var(--bt-color-secondary-soft); color: var(--bt-color-secondary-hover);">UX</div>
      """
    }
  end

  defp menus do
    %{
      "menus:0" => ~S"""
      <.bt_menu_wrap id="menu-basic" toggle_label="Open menu">
        <:item label="Edit" />
        <:item label="Duplicate" />
        <:item label="Delete" />
      </.bt_menu_wrap>
      """
    }
  end

  defp navigation do
    %{
      "navigation:0" => ~S"""
      <%!-- bt-sidebar__nav: sidebar layout utility --%>
      <nav class="bt-sidebar__nav" style="width: 16rem;">
        <.bt_nav_link icon="⌂" current>Home</.bt_nav_link>
        <.bt_nav_link icon="▣">Components</.bt_nav_link>
        <.bt_nav_link icon="⚙">Settings</.bt_nav_link>
      </nav>
      """,
      "navigation:1" => ~S"""
      <.bt_bottom_nav>
        <:item icon="⌂" label="Home" current />
        <:item icon="⌕" label="Search" />
        <:item icon="◎" label="Profile" />
      </.bt_bottom_nav>
      """
    }
  end

  defp overlays do
    %{
      "overlays:0" => ~S"""
      <.bt_button data-overlay-open="overlay-basic">Open overlay</.bt_button>
      <.bt_overlay id="overlay-basic">
        <h3>Overlay</h3>
        <p>Useful for panels and temporary content.</p>
        <.bt_button data-overlay-close>Close</.bt_button>
      </.bt_overlay>
      """,
      "overlays:1" => ~S"""
      <%!-- bt-drawer-demo: static layout demo --%>
      <div class="bt-drawer-demo">
        <aside class="bt-drawer-demo__panel">
          <strong>Drawer</strong>
          <p>Side panel.</p>
        </aside>
      </div>
      """
    }
  end

  defp pages do
    %{
      "pages:0" => ~S"""
      <.bt_section title="Overview" description="Page content." />
      """,
      "pages:1" => ~S"""
      <.bt_nav_link href="#components" icon="▣" current>Components</.bt_nav_link>
      """
    }
  end

  defp progress do
    %{
      "progress:0" => ~S"""
      <.bt_progress value={68} label="Progress at 68%" />
      """,
      "progress:1" => ~S"""
      <.bt_progress_circle value={72} label="72%" />
      """
    }
  end

  defp radio do
    %{
      "radio:0" => ~S"""
      <.bt_radio name="view" label="Weekly" checked />
      <.bt_radio name="view" label="Monthly" />
      <.bt_radio name="view" label="Yearly" />
      """
    }
  end

  defp selects do
    %{
      "selects:0" => ~S"""
      <.bt_input
        name="framework"
        label="Framework"
        type="select"
        options={["Bluetab DS", "Material Design", "Carbon"]}
      />
      """,
      "selects:1" => ~S"""
      <.bt_input
        name="status"
        label="Status"
        type="select"
        options={["Active", "Pending", "Archived"]}
        help="This value affects visibility."
      />
      """
    }
  end

  defp shapes do
    %{
      "shapes:0" => ~S"""
      <%!-- bt-shape-* / bt-center: helper utilities --%>
      <div class="bt-center bt-shape-circle" style="width:5rem; background:var(--bt-color-primary-soft); color:var(--bt-color-primary);">Circle</div>
      <div class="bt-center bt-shape-soft" style="width:7rem; height:5rem; background:var(--bt-color-secondary-soft); color:var(--bt-color-secondary-hover);">Soft</div>
      <div class="bt-center bt-shape-blob" style="width:7rem; height:5rem; background:var(--bt-color-tertiary-soft); color:var(--bt-color-tertiary);">Blob</div>
      """
    }
  end

  defp sliders do
    %{
      "sliders:0" => ~S"""
      <.bt_slider name="percent" value={64} aria-label="Percentage" />
      """,
      "sliders:1" => ~S"""
      <.bt_slider id="quality-slider" name="quality" label="Quality" value={80} help="Drag to adjust the value." />
      """
    }
  end

  defp snackbars do
    %{
      "snackbars:0" => ~S"""
      <.bt_button data-snackbar-open="snackbar-basic">Show snackbar</.bt_button>
      <.bt_snackbar id="snackbar-basic">
        Item saved successfully.
        <:actions>
          <.bt_button variant="ghost" data-snackbar-close>Close</.bt_button>
        </:actions>
      </.bt_snackbar>
      """
    }
  end

  defp switches do
    %{
      "switches:0" => ~S"""
      <.bt_switch name="active_mode" label="Active mode" checked />
      """,
      "switches:1" => ~S"""
      <.bt_switch name="notifications" label="Notifications" />
      """
    }
  end

  defp tables do
    %{
      "tables:0" => ~S"""
      <.bt_table id="catalog-table" rows={rows}>
        <:col label="Component">{row.component}</:col>
        <:col label="Status">
          <.bt_status variant={row.status_variant}>{row.status}</.bt_status>
        </:col>
        <:col label="Usage">{row.usage}</:col>
      </.bt_table>
      """
    }
  end

  defp tabs do
    %{
      "tabs:0" => ~S"""
      <.bt_tabs id="catalog-tabs">
        <:tab id="tab-1" label="Overview" selected />
        <:tab id="tab-2" label="Details" />
        <:tab id="tab-3" label="Settings" />
        <:panel id="panel-1" tab_id="tab-1">Overview content.</:panel>
        <:panel id="panel-2" tab_id="tab-2">Details content.</:panel>
        <:panel id="panel-3" tab_id="tab-3">Settings content.</:panel>
      </.bt_tabs>
      """
    }
  end

  defp combobox do
    %{
      "combobox:0" => ~S"""
      <.bt_combobox name="project_search" label="Project" value="portal" open placeholder="Search by name or ID…">
        <:options>
          <.bt_combobox_option selected>
            <span class="bt-combobox__option-title">1042</span>
            <span> — Portal Redesign</span>
          </.bt_combobox_option>
          <.bt_combobox_option>
            <span class="bt-combobox__option-title">1088</span>
            <span> — Portal Maintenance</span>
          </.bt_combobox_option>
        </:options>
      </.bt_combobox>
      """,
      "combobox:1" => ~S"""
      <.bt_combobox name="project_search" label="Project" value="data" open loading />
      """
    }
  end

  defp tree do
    %{
      "tree:0" => ~S"""
      <.bt_tree
        id="tree-demo"
        nodes={[
          %{
            key: "bu:1",
            kind_label: "BU",
            name: "Technology",
            meta: "Alex Rivera",
            children: [
              %{
                key: "cluster:10",
                kind_label: "Cluster",
                name: "EMEA",
                children: [
                  %{key: "project:1", kind_label: "Project", name: "Portal Redesign", doc_num: 1042, children: []}
                ]
              }
            ]
          }
        ]}
        expanded={MapSet.new(["bu:1", "cluster:10"])}
      />
      """,
      "tree:1" => ~S"""
      <.bt_tree_empty>No nodes match your search.</.bt_tree_empty>
      """
    }
  end

  defp textarea do
    %{
      "textarea:0" => ~S"""
      <.bt_input name="notes" label="Notes" type="textarea" placeholder="Write a description" />
      """,
      "textarea:1" => ~S"""
      <.bt_input
        name="description"
        label="Description"
        type="textarea"
        value="Sample text for documentation."
        help="Recommended maximum: 240 characters."
      />
      """
    }
  end

  defp tooltips do
    %{
      "tooltips:0" => ~S"""
      <.bt_tooltip text="Create new item">
        <.bt_icon_button label="Create" icon="＋" />
      </.bt_tooltip>
      """,
      "tooltips:1" => ~S"""
      <.bt_tooltip text="Additional information">
        <.bt_status variant="info">Hover me</.bt_status>
      </.bt_tooltip>
      """
    }
  end

  defp typography do
    %{
      "typography:0" => ~S"""
      <div class="bt-stack">
        <h1>Heading 1</h1>
        <h2>Heading 2</h2>
        <h3>Heading 3</h3>
        <.bt_lead>Lead paragraph for important introductions.</.bt_lead>
        <p>Base text for product and documentation content.</p>
      </div>
      """,
      "typography:1" => ~S"""
      <.bt_eyebrow>Bluetab label</.bt_eyebrow>
      <h3>Highlighted content</h3>
      <.bt_muted>Secondary text with lower visual emphasis.</.bt_muted>
      """
    }
  end
end
