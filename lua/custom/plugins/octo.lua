return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/which-key.nvim',
  },

  -- Global entry points (always available)
  keys = {
    { '<leader>oo', '<cmd>Octo<cr>', desc = 'octo: command palette' },

    -- issues
    { '<leader>oil', '<cmd>Octo issue list<cr>', desc = 'octo: list issues' },
    { '<leader>oic', '<cmd>Octo issue create<cr>', desc = 'octo: create issue' },

    -- pull requests
    { '<leader>opl', '<cmd>Octo pr list<cr>', desc = 'octo: list pull requests' },
    { '<leader>opc', '<cmd>Octo pr create<cr>', desc = 'octo: create pull request' },
    { '<leader>opo', '<cmd>Octo pr checkout<cr>', desc = 'octo: checkout pull request' },

    -- reviews
    { '<leader>ors', '<cmd>Octo review start<cr>', desc = 'octo: start review' },
    { '<leader>orr', '<cmd>Octo review resume<cr>', desc = 'octo: resume review' },

    -- notifications
    { '<leader>onl', '<cmd>Octo notification list<cr>', desc = 'octo: list notifications' },

    -- repo
    { '<leader>orb', '<cmd>Octo repo browse<cr>', desc = 'octo: open repo in browser' },
  },

  opts = {
    picker = 'snacks',
    enable_builtin = true,
    default_remote = { 'upstream', 'origin' },
    default_merge_method = 'rebase',

    reviews = {
      auto_show_threads = true,
      focus = 'right',
    },

    ui = {
      use_signcolumn = false,
      use_signstatus = true,
    },
    picker_config = {
      snacks = {
        layout = {
          preset = 'sidebar',
        },
      },
    },
    -- 🔒 STRICT MODE
    mappings_disable_default = true,

    -- All buffer-local Octo mappings rewritten under <leader>o
    mappings = {
      issue = {
        issue_options = { lhs = '<leader>oio', desc = 'issue: options' },
        close_issue = { lhs = '<leader>oic', desc = 'issue: close' },
        reopen_issue = { lhs = '<leader>oir', desc = 'issue: reopen' },
        reload = { lhs = '<leader>oirl', desc = 'issue: reload' },
        open_in_browser = { lhs = '<leader>oib', desc = 'issue: open in browser' },
        copy_url = { lhs = '<leader>oiy', desc = 'issue: copy url' },

        add_comment = { lhs = '<leader>oica', desc = 'issue: add comment' },
        add_reply = { lhs = '<leader>oicr', desc = 'issue: reply to comment' },
        delete_comment = { lhs = '<leader>oicd', desc = 'issue: delete comment' },

        next_comment = { lhs = '<leader>oin', desc = 'issue: next comment' },
        prev_comment = { lhs = '<leader>oip', desc = 'issue: previous comment' },
      },

      pull_request = {
        pr_options = { lhs = '<leader>opo', desc = 'pr: options' },
        checkout_pr = { lhs = '<leader>opco', desc = 'pr: checkout' },
        merge_pr = { lhs = '<leader>opm', desc = 'pr: merge' },
        squash_and_merge_pr = { lhs = '<leader>ops', desc = 'pr: squash & merge' },
        rebase_and_merge_pr = { lhs = '<leader>opr', desc = 'pr: rebase & merge' },

        list_commits = { lhs = '<leader>opc', desc = 'pr: list commits' },
        list_changed_files = { lhs = '<leader>opf', desc = 'pr: list files' },
        show_pr_diff = { lhs = '<leader>opd', desc = 'pr: show diff' },

        add_comment = { lhs = '<leader>opca', desc = 'pr: add comment' },
        add_reply = { lhs = '<leader>opcr', desc = 'pr: reply to comment' },

        open_in_browser = { lhs = '<leader>opb', desc = 'pr: open in browser' },
        copy_url = { lhs = '<leader>opy', desc = 'pr: copy url' },

        review_start = { lhs = '<leader>oprs', desc = 'pr: start review' },
        review_resume = { lhs = '<leader>oprr', desc = 'pr: resume review' },
      },

      review_diff = {
        submit_review = { lhs = '<leader>ors', desc = 'review: submit' },
        discard_review = { lhs = '<leader>ord', desc = 'review: discard' },
        add_review_comment = { lhs = '<leader>orca', desc = 'review: add comment', mode = { 'n', 'x' } },
        add_review_suggestion = { lhs = '<leader>orsa', desc = 'review: add suggestion', mode = { 'n', 'x' } },

        next_thread = { lhs = '<leader>orn', desc = 'review: next thread' },
        prev_thread = { lhs = '<leader>orp', desc = 'review: previous thread' },

        close_review_tab = { lhs = '<leader>orc', desc = 'review: close tab' },
      },

      file_panel = {
        next_entry = { lhs = '<leader>ofn', desc = 'files: next file' },
        prev_entry = { lhs = '<leader>ofp', desc = 'files: previous file' },
        select_entry = { lhs = '<leader>ofe', desc = 'files: open diff' },
        refresh_files = { lhs = '<leader>ofr', desc = 'files: refresh' },
        toggle_files = { lhs = '<leader>oft', desc = 'files: toggle panel' },
      },

      notification = {
        read = { lhs = '<leader>onr', desc = 'notification: mark read' },
        done = { lhs = '<leader>ond', desc = 'notification: mark done' },
        unsubscribe = { lhs = '<leader>onu', desc = 'notification: unsubscribe' },
      },
    },
  },

  config = function(_, opts)
    require('octo').setup(opts)

    local wk = require 'which-key'

    wk.register {
      -- root
      { '<leader>o', group = 'octo' },

      -- command palette
      { '<leader>oo', desc = 'command palette' },

      -- repo
      { '<leader>ob', desc = 'open repo in browser' },

      -- files
      { '<leader>of', group = 'files' },
      { '<leader>ofe', desc = 'open diff' },
      { '<leader>ofn', desc = 'next file' },
      { '<leader>ofp', desc = 'previous file' },
      { '<leader>ofr', desc = 'refresh panel' },
      { '<leader>oft', desc = 'toggle panel' },

      -- issues
      { '<leader>oi', group = 'issues' },
      { '<leader>oib', desc = 'open in browser' },
      { '<leader>oic', desc = 'create issue' },
      { '<leader>oil', desc = 'list issues' },
      { '<leader>oio', desc = 'options' },
      { '<leader>oir', desc = 'reopen / reload' },
      { '<leader>oiy', desc = 'copy url' },

      -- notifications
      { '<leader>on', group = 'notifications' },
      { '<leader>ond', desc = 'mark done' },
      { '<leader>onl', desc = 'list notifications' },
      { '<leader>onr', desc = 'mark read' },
      { '<leader>onu', desc = 'unsubscribe' },

      -- pull requests
      { '<leader>op', group = 'pull requests' },
      { '<leader>opb', desc = 'open in browser' },
      { '<leader>opc', desc = 'create pr' },
      { '<leader>opd', desc = 'show diff' },
      { '<leader>opf', desc = 'list files' },
      { '<leader>opl', desc = 'list prs' },
      { '<leader>opm', desc = 'merge pr' },
      { '<leader>opo', desc = 'checkout pr' },
      { '<leader>opr', desc = 'rebase merge' },
      { '<leader>ops', desc = 'squash merge' },
      { '<leader>opy', desc = 'copy url' },

      -- reviews
      { '<leader>or', group = 'reviews' },
      { '<leader>orc', desc = 'close review tab' },
      { '<leader>ord', desc = 'discard review' },
      { '<leader>orr', desc = 'resume review' },
      { '<leader>ors', desc = 'start review' },
    }
  end,
}
