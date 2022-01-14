# Resets the window after a main file set
# Updates the filename in the StatusPage & calls generate_hashes

module Hashbrown
  extend self

  HASH_LIST_TITLE = TRANSLATIONS[CURRENT_LANGUAGE]["Hashes"]
  TOOLS_TITLE     = TRANSLATIONS[CURRENT_LANGUAGE]["Tools"]

  def reset(clear : Bool? = false)
    OPEN_FILE_BUTTON.visible = true
    HEADER_TITLE.visible = true
    BOTTOM_TABS.visible = true

    tools = Adw::Clamp.cast(B_TL["tools"])

    if clear
      STACK.remove(HASH_LIST)
      STACK.remove(tools)
    end

    hash_list_page = STACK.add_titled(HASH_LIST, "hashes", HASH_LIST_TITLE)
    hash_list_page.icon_name = "view-list-bullet-symbolic"
    tools_page = STACK.add_titled(tools, "tools", TOOLS_TITLE)
    # applications-utilities-symbolic
    # applications-engineering-symbolic
    # applications-system-symbolic / emblem-system-symbolic
    tools_page.icon_name = "preferences-system-symbolic"

    WINDOW_BOX.append(STACK)
    WINDOW_BOX.append(BOTTOM_TABS)
  end

  def set_file(filepath : Path)
    HASH_LIST.title = filepath.basename.to_s
    HASH_LIST.description = filepath.dirname.to_s
    Hashbrown.generate_hashes(filepath.to_s)
  end
end
