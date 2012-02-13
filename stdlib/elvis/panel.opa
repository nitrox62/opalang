/*
    Copyright © 2011 MLstate

    This file is part of OPA.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

/**
 * Elvis Panels
 *
 * @category UI
 * @author David Rajchenbach-Teller, 2011
 * @destination PUBLIC
 * @stability EXPERIMENTAL
 */

/**
 * {1 Panels}
 *
 * Panels have multiple uses:
 * - they serve as containers for several elvises
 * - they serve as cut-off points for changing theme, e.g. the theme outside a panel can be different from the theme inside the panel
 * - they can be given classes that can be referenced from CSS, e.g. to allow sizing
 * - children elvises are automatically given classes, e.g. to allow positioning
 */

/**
 * {1 Theming}
 *
 * The panel always has classes "mlstate", "elvis", "panel", plus any classes implied by the theme or by the options.
 * The children of the panel have the same theme as the panel itself, which is either the theme provided as option, or otherwise the parent theme.
 * Each child is embedded in a container numbered [panel_child_0], [panel_child_1], etc.
 */

type EPanel.options =
{
   classes:  list(string)
   children: list(Elvis.elvis(Elvis.masked, Elvis.masked))
   theme:    option(Elvis.theme)
   is_visible:  bool
}

type EPanel.sources =
{
}

@abstract type EPanel.implementation = {
  dom: dom
}

type EPanel.elvis = Elvis.elvis(EPanel.sources, EPanel.implementation)

EPanel =
{{
/**
 * {1 Constructors}
 */
   make(options: EPanel.options): EPanel.elvis =
   (
      id = "epanel_{Random.string(32)}"
      dom = Dom.select_id(id)
      content(parent_theme) =
         theme        = options.theme?parent_theme
         theme_classes= Elvis.Theme.get_classes(theme)
         more_classes = List.to_string_using("", "", " ", options.classes)
         xhtml =
              <div id={id} class="{theme_classes} mlstate elvis panel {more_classes}" style={if not(options.is_visible) then [{display = {css_none}}] else []}>
              {
                  List.map((child -> <div class="panel_child">{Elvis.for_display_in_theme(child, theme)}</div>), options.children)
              }
              </div>
         dom = Dom.of_xhtml(xhtml)
         {~dom ~xhtml}
      Elvis.make({}, ({~dom}), content)
   )

   default_options =
   {
      classes = []
      children= []
      theme   = {none}
      is_visible = {true}
   }

/**
 * {1 Effects}
 */
  set_visible(panel: EPanel.elvis, visible: bool): void =
  (
    dom = (Elvis.implem(panel)).dom
    if visible then Dom.show(dom) else Dom.hide(dom)
  )

  transition(panel: EPanel.elvis, transition: Dom.animation): void =
  (
    dom = (Elvis.implem(panel)).dom
    _ = Dom.transition(dom, transition)
    void
  )

  scroll_into_view(panel: EPanel.elvis): void =
  (
    dom = (Elvis.implem(panel)).dom
    do Dom.scroll_into_view(dom)
    void
  )
}}
