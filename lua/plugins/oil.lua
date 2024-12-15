-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- If I wanted to configure declaratively (no runtime logic)
    -- opts = { default_file_explorer = true }

    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            buf_options = { buflisted = true },
            delete_to_trash = true,
            -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
            skip_confirm_for_simple_edits = true,
            -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
            -- (:help prompt_save_on_select_new_entry)
            prompt_save_on_select_new_entry = false,
            win_options = { winbar = "%!v:lua.get_oil_winbar()" },
              keymaps = {
                ["p"] = { "actions.parent", mode = "n" },
                ["P"] = { "actions.open_cwd", mode = "n" },
              },
        })
    end,
}


