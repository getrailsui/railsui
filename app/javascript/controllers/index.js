import { application } from "./application"

import RailsuiAnchorController from "./railsui_anchor_controller.js"
application.register("railsui-anchor", RailsuiAnchorController)

import RailsuiConfigurationController from "./railsui_configuration_controller.js"
application.register("railsui-configuration", RailsuiConfigurationController)

import RailsuiCodeController from "./railsui_code_controller.js"
application.register("railsui-code", RailsuiCodeController)

import RailsuiCanvasController from "./railsui_canvas_controller.js"
application.register("railsui-canvas", RailsuiCanvasController)

import RailsuiDialogController from "./railsui_dialog_controller.js"
application.register("railsui-dialog", RailsuiDialogController)

import RailsuiFlashController from "./railsui_flash_controller.js"
application.register("railsui-flash", RailsuiFlashController)

import RailsuiHelperController from "./railsui_helper_controller.js"
application.register("railsui-helper", RailsuiHelperController)

import RailsuiNavController from "./railsui_nav_controller.js"
application.register("railsui-nav", RailsuiNavController)

import RailsuiPreventController from "./railsui_prevent_controller.js"
application.register("railsui-prevent", RailsuiPreventController)

import RailsuiScrollController from "./railsui_scroll_controller.js"
application.register("railsui-scroll", RailsuiScrollController)

import RailsuiScrollSpyController from "./railsui_scroll_spy_controller.js"
application.register("railsui-scroll-spy", RailsuiScrollSpyController)

import RailsuiSearchController from "./railsui_search_controller.js"
application.register("railsui-search", RailsuiSearchController)

import RailsuiSelectAllController from "./railsui_select_all_controller.js"
application.register("railsui-select-all", RailsuiSelectAllController)

import RailsuiSmoothController from "./railsui_smooth_controller.js"
application.register("railsui-smooth", RailsuiSmoothController)

import RailsuiSnippetController from "./railsui_snippet_controller.js"
application.register("railsui-snippet", RailsuiSnippetController)

import RailsuiPagesController from "./railsui_pages_controller.js"
application.register("railsui-pages", RailsuiPagesController)

import RailsuiLoadingController from "./railsui_loading_controller.js"
application.register("railsui-loading", RailsuiLoadingController)

// Import components adhoc.
import {
  RailsuiClipboard,
  RailsuiCountUp,
  RailsuiDateRangePicker,
  RailsuiDropdown,
  RailsuiModal,
  RailsuiTabs,
  RailsuiToast,
  RailsuiToggle,
  RailsuiTooltip,
} from "railsui-stimulus"

application.register("railsui-clipboard", RailsuiClipboard)
application.register("railsui-count-up", RailsuiCountUp)
application.register("railsui-date-range-picker", RailsuiDateRangePicker)
application.register("railsui-dropdown", RailsuiDropdown)
application.register("railsui-modal", RailsuiModal)
application.register("railsui-tabs", RailsuiTabs)
application.register("railsui-toast", RailsuiToast)
application.register("railsui-toggle", RailsuiToggle)
application.register("railsui-tooltip", RailsuiTooltip)
