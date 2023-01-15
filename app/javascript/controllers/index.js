import { application } from './application'

import AnchorController from './anchor_controller.js'
application.register('anchor', AnchorController)

import CanvasController from './canvas_controller.js'
application.register('canvas', CanvasController)

import ClipboardController from './clipboard_controller.js'
application.register('clipboard', ClipboardController)

import ConfigurationController from './configuration_controller.js'
application.register('configuration', ConfigurationController)

import CodeController from './code_controller.js'
application.register('code', CodeController)

import DropdownController from './dropdown_controller.js'
application.register('dropdown', DropdownController)

import FlashController from './flash_controller.js'
application.register('flash', FlashController)

import PreventController from './prevent_controller.js'
application.register('prevent', PreventController)

import ScrollController from './scroll_controller.js'
application.register('scroll', ScrollController)

import ToggleController from './toggle_controller.js'
application.register('toggle', ToggleController)

import TooltipController from './tooltip_controller.js'
application.register('tooltip', TooltipController)
