import { application } from "./application"

import TooltipController from "./tooltip_controller.js"
application.register("tooltip", TooltipController)

import CanvasController from "./canvas_controller.js"
application.register("canvas", CanvasController)

import ConfigurationController from "./configuration_controller.js"
application.register("configuration", ConfigurationController)

import FlashController from "./flash_controller.js"
application.register("flash", FlashController)
