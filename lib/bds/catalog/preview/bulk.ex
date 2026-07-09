defmodule Bds.Catalog.Preview.Bulk do
  @moduledoc false
  use Phoenix.Component

  import Bds.Components
  import Bds.Components.Calendar
  import Bds.Components.Performance
  import Bds.Components.Expense
  import Bds.Components.CatalogUi

  @table_rows [
    %{component: "Button", status: "Active", status_variant: "success", usage: "Actions"},
    %{component: "Dialog", status: "Review", status_variant: "warning", usage: "Modals"},
    %{component: "Table", status: "Active", status_variant: "success", usage: "Data"}
  ]

  @interaction_snippet """
  @import "bluetab-design-system/styles.css";

  import { initBtInteractions } from "bluetab-design-system/interactions";
  initBtInteractions();
  """

  def render("get-started", 0, assigns) do
    ~H"""
    <.bt_card variant="filled">
      <:title>Project architecture</:title>
      <p>
        Edit <.bt_code>src/styles/tokens.css</.bt_code> first, then each component under
        <.bt_code>src/styles/components/</.bt_code>.
      </p>
      <.bt_code_block>
    import Bds.Components
    import Bds.Components.CatalogUi
    import Bds.Components.Performance
      </.bt_code_block>
    </.bt_card>
    """
  end

  def render("get-started", 1, assigns) do
    ~H"""
    <.bt_button>Save changes</.bt_button>
    <.bt_button variant="outline">Cancel</.bt_button>
    """
  end

  def render("app-bars", 0, assigns) do
    ~H"""
    <.bt_appbar>
      <.bt_icon_button label="Menu" icon="☰" />
      <strong>Bluetab Project</strong>
      <.bt_spacer />
      <.bt_icon_button label="Search" icon="⌕" />
      <.bt_icon_button label="User" icon="◎" />
    </.bt_appbar>
    """
  end

  def render("app-bars", 1, assigns) do
    ~H"""
    <.bt_appbar variant="primary">
      <.bt_icon_button variant="primary" label="Back" icon="←" />
      <strong>Analytics Dashboard</strong>
      <.bt_spacer />
      <.bt_button variant="secondary">Publish</.bt_button>
    </.bt_appbar>
    """
  end

  def render("app-bars", 2, assigns) do
    ~H"""
    <.bt_bottom_nav label="Bottom navigation">
      <:item icon="⌂" label="Home" current />
      <:item icon="▦" label="Apps" />
      <:item icon="☷" label="Data" />
      <:item icon="⚙" label="Settings" />
    </.bt_bottom_nav>
    """
  end

  def render("avatars", 0, assigns) do
    ~H"""
    <.bt_avatar name="Alejandro Ramos" email="alejandro.ramos@example.com" initials="AR" compactness="compact" />
    """
  end

  def render("avatars", 1, assigns) do
    ~H"""
    <.bt_avatar
      name="María López"
      email="maria.lopez@example.com"
      initials="ML"
      compactness="expanded"
    />
    """
  end

  def render("avatars", 2, assigns) do
    ~H"""
    <div class="bt-stack" style="gap: var(--bt-space-3);">
      <.bt_avatar
        name="Jordan Kim"
        email="jordan.kim@example.com"
        src="https://i.pravatar.cc/96?u=compact"
        compactness="compact"
      />
      <.bt_avatar
        name="Jordan Kim"
        email="jordan.kim@example.com"
        src="https://i.pravatar.cc/128?u=expanded"
        compactness="expanded"
      />
    </div>
    """
  end

  def render("badges", 0, assigns) do
    ~H"""
    <.bt_badge_wrap>
      <.bt_icon>⌂</.bt_icon>
      <.bt_badge variant="dot" />
    </.bt_badge_wrap>
    """
  end

  def render("badges", 1, assigns) do
    ~H"""
    <.bt_badge_wrap>
      <.bt_icon>⌂</.bt_icon>
      <.bt_badge>10</.bt_badge>
    </.bt_badge_wrap>
    """
  end

  def render("badges", 2, assigns) do
    ~H"""
    <.bt_button>
      Alerts <.bt_badge variant="inline">3</.bt_badge>
    </.bt_button>
    <.bt_button variant="secondary">
      Processes <.bt_badge variant="inline-success">OK</.bt_badge>
    </.bt_button>
    """
  end

  def render("buttons", 0, assigns) do
    ~H"""
    <.bt_button>Primary</.bt_button>
    <.bt_button variant="secondary">Secondary</.bt_button>
    <.bt_button variant="tertiary">Tertiary</.bt_button>
    <.bt_button variant="outline">Outline</.bt_button>
    <.bt_button variant="ghost">Ghost</.bt_button>
    """
  end

  def render("buttons", 1, assigns) do
    ~H"""
    <.bt_button class="bt-button bt-button--sm">Small</.bt_button>
    <.bt_button>Medium</.bt_button>
    <.bt_button class="bt-button bt-button--lg">Large</.bt_button>
    """
  end

  def render("buttons", 2, assigns) do
    ~H"""
    <.bt_icon_button label="Search" icon="⌕" />
    <.bt_icon_button variant="primary" label="Save" icon="✓" />
    <.bt_fab label="Create"><.bt_icon>＋</.bt_icon></.bt_fab>
    <.bt_fab extended label="Create"><.bt_icon>＋</.bt_icon> Create</.bt_fab>
    """
  end

  def render("buttons", 3, assigns) do
    ~H"""
    <.bt_segmented label="View">
      <:item label="Day" pressed />
      <:item label="Week" />
      <:item label="Month" />
    </.bt_segmented>
    """
  end

  def render("cards", 0, assigns) do
    ~H"""
    <.bt_card>
      <:title>Standard card</:title>
      Group related information on a screen.
      <:actions>
        <.bt_button variant="ghost">Learn more</.bt_button>
        <.bt_button>Accept</.bt_button>
      </:actions>
    </.bt_card>
    """
  end

  def render("cards", 1, assigns) do
    ~H"""
    <.bt_card variant="elevated" span="">
      <:title>Data product</:title>
      Card with media block, elevation, and actions.
    </.bt_card>
    """
  end

  def render("cards", 2, assigns) do
    ~H"""
    <.bt_card variant="filled">
      <:title>Filled card</:title>
      Soft sections or secondary groupings.
    </.bt_card>
    <.bt_card variant="primary">
      <:title>Primary card</:title>
      Highlighted product or brand messages.
    </.bt_card>
    """
  end

  def render("checkboxes", 0, assigns) do
    ~H"""
    <.bt_input type="checkbox" name="terms" label="Accept terms" />
    <.bt_input type="checkbox" name="copy" label="Send copy" checked />
    """
  end

  def render("checkboxes", 1, assigns) do
    ~H"""
    <.bt_input type="checkbox" name="unavailable" label="Unavailable option" disabled />
    <.bt_input type="checkbox" name="required" label="Required option" checked disabled />
    """
  end

  def render("chips", 0, assigns) do
    ~H"""
    <.bt_chip>Data</.bt_chip>
    <.bt_chip variant="selected">Selected</.bt_chip>
    <.bt_chip variant="outline">Outline</.bt_chip>
    <.bt_chip tag="button"><.bt_icon>＋</.bt_icon> Add filter</.bt_chip>
    """
  end

  def render("chips", 1, assigns) do
    ~H"""
    <.bt_status variant="success">Active</.bt_status>
    <.bt_status variant="warning">Pending</.bt_status>
    <.bt_status variant="error">Error</.bt_status>
    <.bt_status variant="info">Info</.bt_status>
    """
  end

  def render("code", 0, assigns) do
    ~H"""
    <.bt_muted>
      Mention classes with <.bt_code>bt-button</.bt_code> or paths with
      <.bt_code class="bt-code-inline--wrap">docs/how-to-use-design-system.md</.bt_code>.
    </.bt_muted>
    """
  end

  def render("code", 1, assigns) do
    assigns = assign(assigns, :interaction_snippet, @interaction_snippet)

    ~H"""
    <.bt_code_block>{@interaction_snippet}</.bt_code_block>
    """
  end

  def render("code", 2, assigns) do
    ~H"""
    <.bt_example_grid>
      <.bt_card variant="elevated" class="bt-card--third">A</.bt_card>
      <.bt_card variant="filled" class="bt-card--third">B</.bt_card>
      <.bt_card variant="third">C</.bt_card>
    </.bt_example_grid>
    """
  end

  def render("colors", 0, assigns) do
    ~H"""
    <div class="bt-color-grid">
      <.bt_color_swatch label="Primary" swatch="var(--bt-color-primary)" />
      <.bt_color_swatch label="Secondary" swatch="var(--bt-color-secondary)" />
      <.bt_color_swatch label="Tertiary" swatch="var(--bt-color-tertiary)" />
      <.bt_color_swatch label="Surface" swatch="var(--bt-color-surface-muted)" />
    </div>
    """
  end

  def render("colors", 1, assigns) do
    ~H"""
    <div class="bt-row">
      <.bt_status variant="success">Success</.bt_status>
      <.bt_status variant="warning">Warning</.bt_status>
      <.bt_status variant="error">Error</.bt_status>
      <.bt_status variant="info">Info</.bt_status>
    </div>
    """
  end

  def render("containers", 0, assigns) do
    ~H"""
    <.bt_container>
      <h3>Container</h3>
      <p>Reusable block for documentation panels and content zones.</p>
    </.bt_container>
    """
  end

  def render("containers", 1, assigns) do
    ~H"""
    <.bt_container variant="compact">
      <p>Compact container with reduced padding.</p>
    </.bt_container>
    """
  end

  def render("dialogs", 0, assigns) do
    ~H"""
    <.bt_button data-dialog-open="dialog-basic">Open dialog</.bt_button>
    <.bt_dialog id="dialog-basic" title="Confirm action">
      This dialog uses design-system JavaScript interactions.
      <:actions>
        <.bt_button variant="ghost" data-dialog-close>Cancel</.bt_button>
        <.bt_button data-dialog-close>Accept</.bt_button>
      </:actions>
    </.bt_dialog>
    """
  end

  def render("dialogs", 1, assigns) do
    ~H"""
    <.bt_button variant="danger" data-dialog-open="dialog-alert">Delete</.bt_button>
    <.bt_dialog id="dialog-alert" title="Delete record" role="alertdialog">
      This action cannot be undone.
      <:actions>
        <.bt_button variant="ghost" data-dialog-close>Back</.bt_button>
        <.bt_button variant="danger" data-dialog-close>Delete</.bt_button>
      </:actions>
    </.bt_dialog>
    """
  end

  def render("directions", 0, assigns) do
    ~H"""
    <div class="bt-dir-row">
      <.bt_button variant="secondary">One</.bt_button>
      <.bt_button variant="secondary">Two</.bt_button>
      <.bt_button variant="secondary">Three</.bt_button>
    </div>
    """
  end

  def render("directions", 1, assigns) do
    ~H"""
    <div class="bt-dir-column">
      <.bt_button variant="secondary">First</.bt_button>
      <.bt_button variant="secondary">Second</.bt_button>
      <.bt_button variant="secondary">Third</.bt_button>
    </div>
    """
  end

  def render("directions", 2, assigns) do
    ~H"""
    <div class="bt-dir-reverse">
      <.bt_button variant="secondary">A</.bt_button>
      <.bt_button variant="secondary">B</.bt_button>
      <.bt_button variant="secondary">C</.bt_button>
    </div>
    """
  end

  def render("dividers", 0, assigns) do
    ~H"""
    <div class="bt-stack">
      <span>Top content</span>
      <.bt_divider />
      <span>Bottom content</span>
    </div>
    """
  end

  def render("dividers", 1, assigns) do
    ~H"""
    <div class="bt-row">
      <span>Start</span>
      <.bt_divider vertical />
      <span>End</span>
    </div>
    """
  end

  def render("expansions", 0, assigns) do
    ~H"""
    <.bt_expansion title="What does this component include?">
      Expandable content for documentation, FAQs, or secondary data.
    </.bt_expansion>
    """
  end

  def render("fields", 0, assigns) do
    ~H"""
    <.bt_input name="name" label="Name" type="text" placeholder="e.g. Data Governance" help="Optional help text." />
    <.bt_input
      name="error_field"
      label="Field with error"
      type="text"
      value="Incorrect value"
      errors={["Review this value before continuing."]}
    />
    """
  end

  def render("fields", 1, assigns) do
    ~H"""
    <.bt_input name="search" label="Search" type="search" placeholder="Search component" />
    """
  end

  def render("grid", 0, assigns) do
    ~H"""
    <div class="bt-layout-demo">
      <div>1</div>
      <div>2</div>
      <div>3</div>
    </div>
    """
  end

  def render("grid", 1, assigns) do
    ~H"""
    <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr)); gap: var(--bt-space-3); width:100%;">
      <.bt_card variant="filled">A</.bt_card>
      <.bt_card variant="filled">B</.bt_card>
      <.bt_card variant="filled">C</.bt_card>
    </div>
    """
  end

  def render("helpers", 0, assigns) do
    ~H"""
    <div class="bt-stack">
      <div class="bt-inline">
        <.bt_status variant="info">Inline</.bt_status>
        <.bt_status variant="success">Wrap</.bt_status>
      </div>
      <.bt_muted>
        Use <.bt_code>.bt-stack</.bt_code>, <.bt_code>.bt-inline</.bt_code>, <.bt_code>.bt-row</.bt_code> for layout.
      </.bt_muted>
    </div>
    """
  end

  def render("helpers", 1, assigns) do
    ~H"""
    <div class="bt-surface bt-round-sm bt-shadow-sm" style="padding: var(--bt-space-4);">Small radius</div>
    <div class="bt-surface bt-round-lg bt-shadow-md" style="padding: var(--bt-space-4);">Large radius</div>
    """
  end

  def render("icons", 0, assigns) do
    ~H"""
    <.bt_icon>⌂</.bt_icon>
    <.bt_icon>⌕</.bt_icon>
    <.bt_icon>⚙</.bt_icon>
    <.bt_icon>✓</.bt_icon>
    <.bt_icon>×</.bt_icon>
    """
  end

  def render("icons", 1, assigns) do
    ~H"""
    <.bt_button>
      <.bt_icon>✓</.bt_icon>
      Validate
    </.bt_button>
    """
  end

  def render("layout", 0, assigns) do
    ~H"""
    <div class="bt-shell">
      <aside class="bt-sidebar">Sidebar</aside>
      <main class="bt-main">Main content</main>
    </div>
    """
  end

  def render("layout", 1, assigns) do
    ~H"""
    <div class="bt-shell bt-shell--app">
      <.bt_topbar>
        <:brand>
          <.bt_navbar_logo_link href="#" logo_src="/images/logo-bluetab.svg" logo_alt="Bluetab" />
        </:brand>
        <:actions>
          <.bt_navbar_theme_toggle />
        </:actions>
      </.bt_topbar>
      <main class="bt-main">Main content</main>
    </div>
    """
  end

  def render("layout", 2, assigns) do
    ~H"""
    <div class="bt-shell bt-shell--app">
      <.bt_topbar>
        <:brand>
          <.bt_navbar_logo_link href="#" logo_src="/images/logo-bluetab.svg" logo_alt="Bluetab" />
        </:brand>
        <:actions>
          <.bt_navbar_user_menu
            name="Alex Rivera"
            email="alex.rivera@example.com"
            role="Member"
            initials="AR"
          >
            <.bt_navbar_user_menu_prefs>
              <.bt_navbar_user_menu_locale_toggle
                locale="es"
                locales={[%{code: "es", label: "Spanish"}, %{code: "en", label: "English"}]}
              />
              <.bt_navbar_user_menu_theme_toggle />
            </.bt_navbar_user_menu_prefs>
            <div class="bt-navbar-menu-divider" />
            <a href="#" class="bt-navbar-menu-item bt-navbar-menu-item--danger">Log out</a>
          </.bt_navbar_user_menu>
        </:actions>
      </.bt_topbar>
      <main class="bt-main">Main content</main>
    </div>
    """
  end

  def render("layout", 3, assigns) do
    ~H"""
    <.bt_section title="Section title" description="Brief section description.">
      <:actions>
        <.bt_button variant="secondary">Action</.bt_button>
      </:actions>
    </.bt_section>
    """
  end

  def render("lists", 0, assigns) do
    ~H"""
    <.bt_list_group>
      <div class="bt-list-item">
        <.bt_list_item initials="B" title="Bluetab Design System" subtitle="List component" />
        <.bt_icon_button label="More" icon="⋯" />
      </div>
      <.bt_list_item initials="D" title="Data Product" subtitle="Secondary item" />
    </.bt_list_group>
    """
  end

  def render("main-layout", 0, assigns) do
    ~H"""
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
  end

  def render("media", 0, assigns) do
    ~H"""
    <.bt_card span="">
      <.bt_muted>Responsive media inside a card.</.bt_muted>
    </.bt_card>
    """
  end

  def render("media", 1, assigns) do
    ~H"""
    <div class="bt-list-item__avatar">BT</div>
    <div class="bt-list-item__avatar" style="background: var(--bt-color-secondary-soft); color: var(--bt-color-secondary-hover);">UX</div>
    """
  end

  def render("menus", 0, assigns) do
    ~H"""
    <.bt_menu_wrap id="menu-basic" toggle_label="Open menu">
      <:item label="Edit" />
      <:item label="Duplicate" />
      <:item label="Delete" />
    </.bt_menu_wrap>
    """
  end

  def render("navigation", 0, assigns) do
    ~H"""
    <nav class="bt-sidebar__nav" style="width: 16rem;">
      <.bt_nav_link icon="⌂" current>Home</.bt_nav_link>
      <.bt_nav_link icon="▣">Components</.bt_nav_link>
      <.bt_nav_link icon="⚙">Settings</.bt_nav_link>
    </nav>
    """
  end

  def render("navigation", 1, assigns) do
    ~H"""
    <.bt_bottom_nav>
      <:item icon="⌂" label="Home" current />
      <:item icon="⌕" label="Search" />
      <:item icon="◎" label="Profile" />
    </.bt_bottom_nav>
    """
  end

  def render("overlays", 0, assigns) do
    ~H"""
    <.bt_button data-overlay-open="overlay-basic">Open overlay</.bt_button>
    <.bt_overlay id="overlay-basic">
      <h3>Overlay</h3>
      <p>Useful for panels and temporary content.</p>
      <.bt_button data-overlay-close>Close</.bt_button>
    </.bt_overlay>
    """
  end

  def render("overlays", 1, assigns) do
    ~H"""
    <div class="bt-drawer-demo">
      <aside class="bt-drawer-demo__panel">
        <strong>Drawer</strong>
        <p>Side panel.</p>
      </aside>
    </div>
    """
  end

  def render("pages", 0, assigns) do
    ~H"""
    <.bt_section title="Overview" description="Page content." />
    """
  end

  def render("pages", 1, assigns) do
    ~H"""
    <.bt_nav_link href="#components" icon="▣" current>Components</.bt_nav_link>
    """
  end

  def render("progress", 0, assigns) do
    ~H"""
    <.bt_progress value={68} label="Progress at 68%" />
    """
  end

  def render("progress", 1, assigns) do
    ~H"""
    <.bt_progress_circle value={72} label="72%" />
    """
  end

  def render("radio", 0, assigns) do
    ~H"""
    <.bt_radio name="view" label="Weekly" checked />
    <.bt_radio name="view" label="Monthly" />
    <.bt_radio name="view" label="Yearly" />
    """
  end

  def render("selects", 0, assigns) do
    ~H"""
    <.bt_input
      name="framework"
      label="Framework"
      type="select"
      options={["Bluetab DS", "Material Design", "Carbon"]}
    />
    """
  end

  def render("selects", 1, assigns) do
    ~H"""
    <.bt_input
      name="status"
      label="Status"
      type="select"
      options={["Active", "Pending", "Archived"]}
      help="This value affects visibility."
    />
    """
  end

  def render("shapes", 0, assigns) do
    ~H"""
    <div class="bt-center bt-shape-circle" style="width:5rem; background:var(--bt-color-primary-soft); color:var(--bt-color-primary);">Circle</div>
    <div class="bt-center bt-shape-soft" style="width:7rem; height:5rem; background:var(--bt-color-secondary-soft); color:var(--bt-color-secondary-hover);">Soft</div>
    <div class="bt-center bt-shape-blob" style="width:7rem; height:5rem; background:var(--bt-color-tertiary-soft); color:var(--bt-color-tertiary);">Blob</div>
    """
  end

  def render("sliders", 0, assigns) do
    ~H"""
    <.bt_slider name="percent" value={64} aria-label="Percentage" />
    """
  end

  def render("sliders", 1, assigns) do
    ~H"""
    <.bt_slider id="quality-slider" name="quality" label="Quality" value={80} help="Drag to adjust the value." />
    """
  end

  def render("snackbars", 0, assigns) do
    ~H"""
    <.bt_button data-snackbar-open="snackbar-basic">Show snackbar</.bt_button>
    <.bt_snackbar id="snackbar-basic">
      Item saved successfully.
      <:actions>
        <.bt_button variant="ghost" data-snackbar-close>Close</.bt_button>
      </:actions>
    </.bt_snackbar>
    """
  end

  def render("switches", 0, assigns) do
    ~H"""
    <.bt_switch name="active_mode" label="Active mode" checked />
    """
  end

  def render("switches", 1, assigns) do
    ~H"""
    <.bt_switch name="notifications" label="Notifications" />
    """
  end

  def render("tables", 0, assigns) do
    assigns = assign(assigns, :table_rows, @table_rows)

    ~H"""
    <.bt_table id="catalog-table" rows={@table_rows}>
      <:col :let={row} label="Component">{row.component}</:col>
      <:col :let={row} label="Status">
        <.bt_status variant={row.status_variant}>{row.status}</.bt_status>
      </:col>
      <:col :let={row} label="Usage">{row.usage}</:col>
    </.bt_table>
    """
  end

  def render("tabs", 0, assigns) do
    ~H"""
    <.bt_tabs id="catalog-tabs">
      <:tab id="tab-1" label="Overview" selected />
      <:tab id="tab-2" label="Details" />
      <:tab id="tab-3" label="Settings" />
      <:panel id="panel-1" tab_id="tab-1">Overview content.</:panel>
      <:panel id="panel-2" tab_id="tab-2">Details content.</:panel>
      <:panel id="panel-3" tab_id="tab-3">Settings content.</:panel>
    </.bt_tabs>
    """
  end

  def render("textarea", 0, assigns) do
    ~H"""
    <.bt_input name="notes" label="Notes" type="textarea" placeholder="Write a description" />
    """
  end

  def render("textarea", 1, assigns) do
    ~H"""
    <.bt_input
      name="description"
      label="Description"
      type="textarea"
      value="Sample text for documentation."
      help="Recommended maximum: 240 characters."
    />
    """
  end

  def render("tooltips", 0, assigns) do
    ~H"""
    <.bt_tooltip text="Create new item">
      <.bt_icon_button label="Create" icon="＋" />
    </.bt_tooltip>
    """
  end

  def render("tooltips", 1, assigns) do
    ~H"""
    <.bt_tooltip text="Additional information">
      <.bt_status variant="info">Hover me</.bt_status>
    </.bt_tooltip>
    """
  end

  def render("combobox", 0, assigns) do
    ~H"""
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
        <.bt_combobox_option variant="warning">
          <span class="bt-combobox__option-title">991</span>
          <span> — Legacy Portal</span>
          <span class="bt-combobox__option-sub">Ended 2024-12-31</span>
        </.bt_combobox_option>
      </:options>
    </.bt_combobox>
    """
  end

  def render("combobox", 1, assigns) do
    ~H"""
    <.bt_combobox name="project_search" label="Project" value="data" open loading />
    """
  end

  def render("tree", 0, assigns) do
    nodes = [
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
              %{
                key: "project:1",
                kind_label: "Project",
                name: "Portal Redesign",
                doc_num: 1042,
                children: []
              }
            ]
          }
        ]
      }
    ]

    assigns =
      assigns
      |> assign(:nodes, nodes)
      |> assign(:expanded, MapSet.new(["bu:1", "cluster:10"]))

    ~H"""
    <.bt_tree id="tree-demo" nodes={@nodes} expanded={@expanded} />
    """
  end

  def render("tree", 1, assigns) do
    ~H"""
    <.bt_tree_empty>No nodes match your search.</.bt_tree_empty>
    """
  end

  def render("calendar-day", 0, assigns) do
    ~H"""
    <.bt_calendar_day
      day={12}
      status="imputado"
      projects={[
        %{name: "Proyecto A", hours: 4.0, status: "aprobado"},
        %{name: "Proyecto B", hours: 4.0, status: "liberado"}
      ]}
      class="w-40 h-32"
    />
    """
  end

  def render("calendar-day", 1, assigns) do
    ~H"""
    <div class="bt-stack" style="flex-flow: row wrap; gap: var(--bt-space-2);">
      <.bt_calendar_day day={1} status="nuevo" class="w-20 h-20" />
      <.bt_calendar_day day={2} status="completado" class="w-20 h-20" />
      <.bt_calendar_day day={3} status="aprobado" class="w-20 h-20" />
      <.bt_calendar_day day={4} status="festivo" class="w-20 h-20" />
    </div>
    """
  end

  def render("calendar-toolbar", 0, assigns) do
    ~H"""
    <.bt_calendar_toolbar month_label="June 2026">
      <:left><.bt_icon_button label="Templates" icon="▥" /></:left>
      <:center>
        <.bt_icon_button label="Previous" icon="‹" />
        <.bt_icon_button label="Next" icon="›" />
      </:center>
      <:right><.bt_icon_button label="Today" icon="◎" /></:right>
    </.bt_calendar_toolbar>
    """
  end

  def render("calendar-weekdays", 0, assigns) do
    ~H"""
    <.bt_calendar_weekdays
      show_weekends
      grid_columns="repeat(5, minmax(0, 5fr)) repeat(2, minmax(0, 1fr))"
    />
    """
  end

  def render("calendar-legend", 0, assigns) do
    ~H"""
    <.bt_calendar_legend
      items={[
        %{status: "imputado", icon: "◐", count: 6},
        %{status: "completado", icon: "●", count: 5},
        %{status: "aprobado", icon: "✓", count: 2}
      ]}
    />
    """
  end

  def render("calendar-template", 0, assigns) do
    ~H"""
    <.bt_calendar_template_card
      name="Acme — billable"
      projects={[%{name: "PX-1024 · Platform rollout", hours: 8.0}]}
    />
    """
  end

  def render("calendar-day-modal", 0, assigns) do
    ~H"""
    <.bt_calendar_day_modal
      show
      date={~D[2026-06-12]}
      status="imputado"
      total_hours={8.0}
      entries={[
        %{
          id: "1",
          project_name: "Proyecto A",
          hours: 4.0,
          input_type: "Development",
          status: "aprobado",
          status_label: "Approved"
        },
        %{
          id: "2",
          project_name: "Proyecto B",
          hours: 4.0,
          input_type: "Development",
          status: "liberado",
          status_label: "Sent"
        }
      ]}
    />
    """
  end

  def render("calendar-shell", 0, assigns) do
    ~H"""
    <.bt_calendar_shell sidebar_open class="min-h-96">
      <:sidebar>
        <.bt_calendar_templates_panel title="Templates">
          <.bt_calendar_template_card name="Acme — billable" hours={8.0} />
        </.bt_calendar_templates_panel>
      </:sidebar>
      <:toolbar>
        <.bt_calendar_toolbar month_label="June 2026" />
        <.bt_calendar_weekdays
          show_weekends
          grid_columns="repeat(5, minmax(0, 1fr)) repeat(2, minmax(0, 0.5fr))"
        />
      </:toolbar>
      <.bt_calendar_month_grid grid_columns="repeat(5, minmax(0, 1fr)) repeat(2, minmax(0, 0.5fr))">
        <.bt_calendar_month_cell>
          <.bt_calendar_day day={2} status="imputado" class="h-full" />
        </.bt_calendar_month_cell>
        <.bt_calendar_month_cell>
          <.bt_calendar_day day={3} status="completado" class="h-full" />
        </.bt_calendar_month_cell>
        <.bt_calendar_month_cell>
          <.bt_calendar_day day={4} status="aprobado" class="h-full" />
        </.bt_calendar_month_cell>
      </.bt_calendar_month_grid>
      <:legend>
        <.bt_calendar_legend
          items={[
            %{status: "imputado", icon: "◐", count: 6},
            %{status: "aprobado", icon: "✓", count: 2}
          ]}
        />
      </:legend>
    </.bt_calendar_shell>
    """
  end

  def render("performance-evaluator", 0, assigns) do
    ~H"""
    <section class="bt-stack" style="gap: var(--bt-space-4);">
      <h2 class="bt-performance-section-title">Your evaluator</h2>
      <.bt_performance_evaluator_card
        id="catalog-performance-evaluator"
        name="Morgan Chen"
        email="morgan.chen@example.com"
      />
    </section>
    """
  end

  def render("performance-hours", 0, assigns) do
    ~H"""
    <section class="bt-stack" style="gap: var(--bt-space-4);">
      <h2 class="bt-performance-section-title">Reported hours</h2>
      <.bt_performance_hours_panel
        id="catalog-performance-hours"
        hours_groups={[
          %{key: "acme", label: "Acme Corp · Digital", total_label: "128.5h", projects: []},
          %{key: "northwind", label: "Northwind · SAP", total_label: "44h", projects: []}
        ]}
        hidden_group_count={0}
      />
    </section>
    """
  end

  def render("performance-briefing-card", 0, assigns) do
    ~H"""
    <.bt_performance_briefing_card
      id="catalog-performance-briefing"
      status="published"
      date_label="2026-04-08"
      period_name="H1 2026"
      creator_label="Morgan Chen"
      role_description="Own technical direction for the Northwind FI rollout."
      ack_state={:acknowledged}
      objectives={[
        %{
          index: 1,
          category: "PX",
          title: "Blueprint sign-off",
          description: "Signed-off solution design.",
          weight_share_label: "35%",
          completion: "total",
          completion_label: "Fully achieved",
          evaluator_comment: "Delivered on schedule with clear client sign-off."
        }
      ]}
      evaluation={
        %{
          date_label: "2026-04-22",
          creator_label: "Morgan Chen",
          rating: "b",
          rating_label: "Above expected",
          rationale: "—",
          strengths: "Clear communication.",
          weaknesses: "Optimistic test estimates.",
          recommendations: "Continue pairing on automation.",
          ack_state: :acknowledged,
          ack_date_label: "2026-04-25"
        }
      }
    />
    """
  end

  def render("performance-briefing-card", 1, assigns) do
    ~H"""
    <.bt_performance_briefing_card
      id="catalog-performance-briefing-draft"
      status="draft"
      date_label="2026-05-12"
      creator_label="Morgan Chen"
      role_description="Lead delivery on the Acme platform migration."
      ack_state={:hidden}
    />
    """
  end

  def render("performance-team-card", 0, assigns) do
    ~H"""
    <.bt_performance_team_card
      id="catalog-performance-team"
      name="Sam Okonkwo"
      email="sam.okonkwo@example.com"
      category="Consultant"
      project_label="Acme · Platform migration"
      hours_label="96h"
      briefing_date_label="2026-01-31"
      briefing_status="published"
      evaluation_date_label="2026-05-13"
      evaluation_rating="a"
      evaluation_status="published"
    />
    """
  end

  def render("typography", 0, assigns) do
    ~H"""
    <div class="bt-stack">
      <h1>Heading 1</h1>
      <h2>Heading 2</h2>
      <h3>Heading 3</h3>
      <.bt_lead>Lead paragraph for important introductions.</.bt_lead>
      <p>Base text for product and documentation content.</p>
    </div>
    """
  end

  def render("typography", 1, assigns) do
    ~H"""
    <.bt_eyebrow>Bluetab label</.bt_eyebrow>
    <h3>Highlighted content</h3>
    <.bt_muted>Secondary text with lower visual emphasis.</.bt_muted>
    """
  end

  def render("breadcrumb", 0, assigns) do
    ~H"""
    <.bt_breadcrumb
      items={[
        %{label: "Liquidaciones", navigate: "/"},
        %{label: "Trip Madrid Q1", current: true}
      ]}
      separator="›"
    />
    """
  end

  def render("empty-state", 0, assigns) do
    ~H"""
    <.bt_empty title="No liquidaciones in this view" description="Create a new liquidación or sync with SAP.">
      <:actions>
        <.bt_button variant="primary">New liquidación</.bt_button>
        <.bt_button variant="outline">Sync</.bt_button>
      </:actions>
    </.bt_empty>
    """
  end

  def render("stepper", 0, assigns) do
    ~H"""
    <.bt_stepper current={2} steps={["Project", "Details", "Review"]} />
    """
  end

  def render("liveview-modal", 0, assigns) do
    ~H"""
    <.bt_modal id="catalog-modal" title="New liquidación" subtitle="Complete the expense liquidación details." close_event="noop">
      <p class="bt-muted">Wizard body content goes here.</p>
      <:footer>
        <.bt_button variant="ghost">Cancel</.bt_button>
        <.bt_button variant="primary">Continue</.bt_button>
      </:footer>
    </.bt_modal>
    """
  end

  def render("spinner", 0, assigns) do
    ~H"""
    <div class="bt-spinner-row">
      <.bt_spinner size="sm" />
      <.bt_spinner />
      <.bt_spinner size="lg" />
    </div>
    """
  end

  def render("expense-liquidacion-card", 0, assigns) do
    ~H"""
    <.bt_expense_liquidacion_card
      id="catalog-expense-liq"
      concept="Client workshop travel"
      date_label="2026-03-18"
      project_name="Northwind rollout"
      gasto_count={3}
      current_step_index={2}
      current_step_label="Pending approval"
      pill_variant="warning"
    />
    """
  end

  def render("expense-gasto-card", 0, assigns) do
    ~H"""
    <.bt_expense_gasto_card
      id="catalog-expense-gasto"
      type_label="Taxi"
      date_label="2026-03-17"
      title="Airport to hotel"
      amount="42.50"
      currency_suffix="EUR"
    />
    """
  end

  def render(_, _, _assigns), do: nil
end
