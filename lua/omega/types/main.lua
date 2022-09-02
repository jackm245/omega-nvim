---@diagnostic disable: unused-local
--# selene: allow(unused_variable)

---A module for omega config
---@class OmegaModule
---@field keybindings function Set up keybindings for this module
---@field plugins table Keys
---@field configs table<string,function>

---@class HeirlineComponent
---Description: This is the string that gets printed in the statusline. No escaping is performed, so it may contain sequences that have a special meaning within the statusline, such as %f (filename), %p (percentage through file), %-05.10( %) (to control text alignment and padding), etc. For more, see :h 'statusline'. To print an actual %, use %%.
---@field provider string|number
---Description: hl controls the colors of what is printed by the component's provider, or by any of its descendants. At evaluation time, the hl of any component gets merged with the hl of its parent (whether it is a function or table), so that, when specified, the fields in the child hl will always take precedence unless force is true.
---@field hl table
---Description: This function controls whether the component should be evaluated or not. It is the first function to be executed at evaluation time. The truthy of the return value is tested, so any value besides nil and false will evaluate to true. Of course, this will affect all of the component's progeny.
---@field condition function
---Description: Register a lua callback to be called on mouse click(s). You need to supply a global name the function will be registered with. Arguments passed to the function are the same described for the @ statusline field, with the addition of the component reference (self) as the first parameter. By default, the callback is dynamically registered only the first time the component containing it is evaluated. If update is true, the callback will be (re-)registered at each evaluation cycle. Note: be careful of the arguments passed to the callback, you may often prefer wrapping a 'third-party' functions rather than passing their reference as is.
---@field on_click table
