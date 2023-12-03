import { application } from "./application"

import AnchorController from "./anchor_controller.js"
application.register("anchor", AnchorController)

import ClipboardController from "./clipboard_controller.js"
application.register("clipboard", ClipboardController)

import ConfigurationController from "./configuration_controller.js"
application.register("configuration", ConfigurationController)

import CodeController from "./code_controller.js"
application.register("code", CodeController)

import CanvasController from "./canvas_controller.js"
application.register("canvas", CanvasController)

import DateRangePickerController from "./date_range_picker_controller.js"
application.register("date-range-picker", DateRangePickerController)

import DialogController from "./dialog_controller.js"
application.register("dialog", DialogController)

import DropdownController from "./dropdown_controller.js"
application.register("dropdown", DropdownController)

import FlashController from "./flash_controller.js"
application.register("flash", FlashController)

import HelperController from "./helper_controller.js"
application.register("helper", HelperController)

import ModalController from "./modal_controller.js"
application.register("modal", ModalController)

import NavController from "./nav_controller.js"
application.register("nav", NavController)

import PreventController from "./prevent_controller.js"
application.register("prevent", PreventController)

import ScrollController from "./scroll_controller.js"
application.register("scroll", ScrollController)

import SearchController from "./search_controller.js"
application.register("search", SearchController)

import SelectAllController from "./select_all_controller.js"
application.register("select-all", SelectAllController)

import SmoothController from "./smooth_controller.js"
application.register("smooth", SmoothController)

import TabsController from "./tabs_controller.js"
application.register("tabs", TabsController)

import PagesController from "./pages_controller.js"
application.register("pages", PagesController)

import ToggleController from "./toggle_controller.js"
application.register("toggle", ToggleController)

import TooltipController from "./tooltip_controller.js"
application.register("tooltip", TooltipController)
